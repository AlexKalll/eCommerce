import 'dart:convert';

import 'package:ecommerce/core/network/http.dart';

import 'package:ecommerce/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:ecommerce/features/auth/data/datasources/remote/auth_remote_data_source_impl.dart';

import 'package:ecommerce/features/auth/data/models/login_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../utils/fixture_reader.dart';

import '../../../../product/data/data_sources/remote/remote_data_source_impl_test.mocks.dart';

void main() {
  late MockHttpClient mockHttpClient;
  late AuthRemoteDataSource authRemoteDataSource;

  group('AuthLocalDataSource', () {
    setUp(() {
      mockHttpClient = MockHttpClient();
      authRemoteDataSource = AuthRemoteDataSourceImpl(
        client: mockHttpClient,
      );
    });

    final loginResponse = fixture('login_response.json');
    const loginModel = LoginModel(email: 'email', password: 'password');

    group('login', () {
      test('should return user from API', () async {
        when(mockHttpClient.post(any, any)).thenAnswer(
            (_) async => HttpResponse(statusCode: 201, body: loginResponse));

        final result = await authRemoteDataSource.login(loginModel);

        expect(result.token, jsonDecode(loginResponse)['data']['access_token']);
      });
    });
  });
}