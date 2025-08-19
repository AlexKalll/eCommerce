import 'package:dartz/dartz.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/http.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/authenticated_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_data_source.dart';
import '../datasources/remote/auth_remote_data_source.dart';
import '../models/authenticated_user_model.dart';
import '../models/login_model.dart';
import '../models/register_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final HttpClient client;

  AuthRepositoryImpl({
    required this.client,
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AuthenticatedUser>> login({
    required String email,
    required String password,
  }) async {
    print('🔐 Starting login process for: $email');

    if (await networkInfo.isConnected) {
      print('✅ Network connection confirmed');
      try {
        print('📡 Making login request to remote data source...');
        final accessToken = await remoteDataSource.login(
          LoginModel(email: email, password: password),
        );
        print('✅ Login successful, got access token');

        client.authToken = accessToken.token;
        print('🔑 Set auth token in HTTP client');

        print('👤 Fetching current user...');
        final user = await remoteDataSource.getCurrentUser();
        print('✅ User data retrieved');

        final authenticatedUser = AuthenticatedUserModel(
          id: user.id,
          email: user.email,
          name: user.name,
          accessToken: accessToken.token,
        );

        print('💾 Caching user data locally...');
        await localDataSource.cacheUser(authenticatedUser);
        print('✅ User data cached successfully');

        return Right(authenticatedUser);
      } on TimeoutException catch (e) {
        print('⏰ Login request timed out: ${e.message}');
        return const Left(
          ServerFailure(
            'Request timed out. Please check your internet connection and try again.',
          ),
        );
      } on ServerException catch (e) {
        print('❌ Server exception during login: ${e.message}');
        return const Left(ServerFailure('Unable to login'));
      } on AuthenticationException catch (e) {
        print('🔒 Authentication exception: ${e.message}');
        return Left(AuthFailure(e.message));
      } catch (e) {
        print('💥 Unexpected error during login: $e');
        if (e.toString().contains('SocketException') ||
            e.toString().contains('HandshakeException') ||
            e.toString().contains('ConnectionException')) {
          return const Left(
            ServerFailure(
              'Network connection failed. Please check your internet connection.',
            ),
          );
        }
        return Left(ServerFailure('An unexpected error occurred: $e'));
      }
    } else {
      print('❌ No network connection');
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await localDataSource.clear();
      client.authToken = '';
      return const Right(unit);
    } on CacheException {
      return const Left(CacheFailure('Unable to logout'));
    }
  }

  @override
  Future<Either<Failure, AuthenticatedUser>> getCurrentUser() async {
    try {
      final user = await localDataSource.getUser();
      client.authToken = user.accessToken;
      return Right(user);
    } on CacheException {
      return Left(AuthFailure.tokenExpired());
    }
  }

  @override
  Future<Either<Failure, AuthenticatedUser>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    print('🔐 Starting registration process for: $email');

    if (await networkInfo.isConnected) {
      print('✅ Network connection confirmed');
      try {
        print('📡 Making registration request to remote data source...');
        await remoteDataSource.register(
          RegisterModel(name: name, email: email, password: password),
        );
        print('✅ Registration successful');

        print('🔐 Attempting to login with new credentials...');
        final user = await login(email: email, password: password);

        user.fold(
          (failure) {
            print('❌ Login after registration failed: ${failure.message}');
            client.authToken = '';
          },
          (user) {
            print('✅ Login after registration successful');
            client.authToken = user.accessToken;
          },
        );

        return user;
      } on TimeoutException catch (e) {
        print('⏰ Registration request timed out: ${e.message}');
        return const Left(
          ServerFailure(
            'Registration timed out. Please check your internet connection and try again.',
          ),
        );
      } on ServerException catch (e) {
        print('❌ Server exception during registration: ${e.message}');
        return Left(ServerFailure('Unable to register'));
      } on AuthenticationException catch (e) {
        print('🔒 Authentication exception during registration: ${e.message}');
        return Left(AuthFailure(e.message));
      } catch (e) {
        print('💥 Unexpected error during registration: $e');
        if (e.toString().contains('SocketException') ||
            e.toString().contains('HandshakeException') ||
            e.toString().contains('ConnectionException')) {
          return const Left(
            ServerFailure(
              'Network connection failed. Please check your internet connection.',
            ),
          );
        }
        return Left(
          ServerFailure('An unexpected error occurred during registration: $e'),
        );
      }
    } else {
      print('❌ No network connection for registration');
      return const Left(NetworkFailure());
    }
  }
}
