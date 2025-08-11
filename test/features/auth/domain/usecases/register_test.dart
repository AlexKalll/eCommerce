import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/features/auth/domain/entities/authenticated_user.dart';
import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecommerce/features/auth/domain/usecases/register.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'register_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository repository;
  late Register usecase;

  setUp(() {
    repository = MockAuthRepository();
    usecase = Register(repository);
  });

  const tName = 'name';
  const tEmail = 'email@gmail.com';
  const tPassword = 'password';
  const tAccessToken = 'token';
  const tUser = AuthenticatedUser(
      id: 'id', name: tName, email: tEmail, accessToken: tAccessToken);

  test('should register using the repository', () async {
    // arrange
    when(repository.register(name: tName, email: tEmail, password: tPassword))
        .thenAnswer((_) async => const Right(tUser));

    // act
    final result =
        await usecase(const RegisterParams(tName, tEmail, tPassword));

    // assert
    expect(result, const Right(tUser));
    verify(
        repository.register(name: tName, email: tEmail, password: tPassword));
    verifyNoMoreInteractions(repository);
  });

  test('should return a failure when password is too short', () async {
    // arrange
    const tShortPassword = '123';

    // act
    final result =
        await usecase(const RegisterParams(tName, tEmail, tShortPassword));

    // assert
    expect(result, Left(AuthFailure.passwordTooShort()));
    verifyNever(repository.register(
        name: tName, email: tEmail, password: tShortPassword));
  });
}