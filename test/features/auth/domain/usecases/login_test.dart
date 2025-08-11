import 'package:dartz/dartz.dart';
import 'package:ecommerce/features/auth/domain/entities/authenticated_user.dart';
import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecommerce/features/auth/domain/usecases/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository repository;
  late Login usecase;

  setUp(() {
    repository = MockAuthRepository();
    usecase = Login(repository);
  });

  const tName = 'name';
  const tEmail = 'email@gmail.com';
  const tPassword = 'password';
  const tAccessToken = 'token';
  const tUser = AuthenticatedUser(
      id: 'id', name: tName, email: tEmail, accessToken: tAccessToken);

  test('should login using the repository', () async {
    when(repository.login(email: tEmail, password: tPassword))
        .thenAnswer((_) async => const Right(tUser));

    final result = await usecase(const LoginParams(tEmail, tPassword));

    expect(result, const Right(tUser));
    verify(repository.login(email: tEmail, password: tPassword));
    verifyNoMoreInteractions(repository);
  });
}