import 'dart:convert';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/network/http.dart';
import '../../models/login_model.dart';
import '../../models/register_model.dart';
import '../../models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final HttpClient client;
  final String _baseUrl;

  AuthRemoteDataSourceImpl({required this.client}) : _baseUrl = '$baseUrl/auth';

  @override
  Future<AccessToken> login(LoginModel loginModel) async {
    print('🔐 AuthRemoteDataSourceImpl.login() called');
    print('📡 Making POST request to: $_baseUrl/login');
    print('📦 Login model: ${loginModel.toJson()}');

    try {
      final response = await client.post(
        '$_baseUrl/login',
        loginModel.toJson(),
      );

      print('📥 Response received: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body)['data'];
        print('✅ Parsing access token from: $data');
        return AccessToken.fromJson(data);
      } else if (response.statusCode == 401) {
        print('❌ Authentication failed: 401');
        throw AuthenticationException.invalidEmailAndPasswordCombination();
      } else {
        print('❌ Server error: ${response.statusCode}');
        throw ServerException(message: response.body);
      }
    } catch (e) {
      print('💥 Exception in login: $e');
      rethrow;
    }
  }

  @override
  Future<UserModel> register(RegisterModel registerModel) async {
    print('🔐 AuthRemoteDataSourceImpl.register() called');
    print('📡 Making POST request to: $_baseUrl/register');
    print('📦 Register model: ${registerModel.toJson()}');

    try {
      final response = await client.post(
        '$_baseUrl/register',
        registerModel.toJson(),
      );

      print('📥 Registration response received: ${response.statusCode}');
      print('📥 Registration response body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body)['data'];
        print('✅ Parsing user data from: $data');
        return UserModel.fromJson(data);
      } else if (response.statusCode == 409) {
        print('❌ Registration failed: Email already in use (409)');
        throw AuthenticationException.emailAlreadyInUse();
      } else {
        print('❌ Registration server error: ${response.statusCode}');
        throw ServerException(message: response.body);
      }
    } catch (e) {
      print('💥 Exception in registration: $e');
      rethrow;
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    print('🔐 AuthRemoteDataSourceImpl.getCurrentUser() called');
    print('📡 Making GET request to: $baseUrl/users/me');

    try {
      final response = await client.get('$baseUrl/users/me');

      print('📥 GetCurrentUser response received: ${response.statusCode}');
      print('📥 GetCurrentUser response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        print('✅ Parsing user data from: $data');
        return UserModel.fromJson(data);
      } else if (response.statusCode == 401) {
        print('❌ GetCurrentUser failed: Token expired (401)');
        throw AuthenticationException.tokenExpired();
      } else {
        print('❌ GetCurrentUser server error: ${response.statusCode}');
        throw ServerException(message: response.body);
      }
    } catch (e) {
      print('💥 Exception in getCurrentUser: $e');
      rethrow;
    }
  }
}
