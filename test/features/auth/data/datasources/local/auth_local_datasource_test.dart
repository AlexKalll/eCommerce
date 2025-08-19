import 'dart:convert';

import 'package:ecommerce/core/error/exception.dart';
import 'package:ecommerce/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:ecommerce/features/auth/data/datasources/local/auth_local_data_source_impl.dart';
import 'package:ecommerce/features/auth/data/models/authenticated_user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../utils/fixture_reader.dart';
import '../../../../product/data/data_sources/local/local_data_source_impl_test.mocks.dart';

void main() {
  late MockSharedPreferences mockSharedPreferences;

  group('AuthLocalDataSource', () {
    late AuthLocalDataSource authLocalDataSource;

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      authLocalDataSource = AuthLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences,
      );
    });

    final userJson = fixture('auth_user.json');
    final user = AuthenticatedUserModel.fromJson(jsonDecode(userJson));

    group('getUser', () {
      test('should return user from SharedPreferences', () async {
        when(mockSharedPreferences.getString(any)).thenReturn(userJson);

        final result = await authLocalDataSource.getUser();

        expect(result, user);
      });

      test('should throw CacheException when user not found in cache',
          () async {
        when(mockSharedPreferences.getString(any)).thenReturn(null);

        final call = authLocalDataSource.getUser;

        expect(() => call(), throwsA(isA<CacheException>()));
      });
    });
  });
}