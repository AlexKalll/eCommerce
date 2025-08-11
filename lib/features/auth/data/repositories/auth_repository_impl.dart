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
    if (await networkInfo.isConnected) {
      try {
        final accessToken = await remoteDataSource
            .login(LoginModel(email: email, password: password));

        client.authToken = accessToken.token;

        final user = await remoteDataSource.getCurrentUser();

        final authenticatedUser = AuthenticatedUserModel(
            id: user.id,
            email: user.email,
            name: user.name,
            accessToken: accessToken.token);

        await localDataSource.cacheUser(authenticatedUser);

        return Right(authenticatedUser);
      } on ServerException {
        return const Left(ServerFailure('Unable to login'));
      }
    } else {
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
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.register(
          RegisterModel(name: name, email: email, password: password),
        );
        final user = await login(email: email, password: password);
        client.authToken = user.fold((l) => '', (r) => r.accessToken);
        return user;
      } on ServerException {
        return const Left(ServerFailure('Unable to register'));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}