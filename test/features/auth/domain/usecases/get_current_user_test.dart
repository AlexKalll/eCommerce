import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/usecase.dart';
import 'package:ecommerce/features/auth/domain/entities/authenticated_user.dart';
import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecommerce/features/auth/domain/usecases/get_current_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_current_user_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late GetCurrentUser useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = GetCurrentUser(mockAuthRepository);
  });

  const authenticatedUser = AuthenticatedUser(
      id: '123', name: 'name', email: 'test@example.com', accessToken: 'token');

  test('should get the current user from the repository', () async {
    // Arrange
    when(mockAuthRepository.getCurrentUser())
        .thenAnswer((_) async => const Right(authenticatedUser));

    // Act
    final result = await useCase(NoParams());

    // Assert
    expect(result, const Right(authenticatedUser));
    verify(mockAuthRepository.getCurrentUser());
    verifyNoMoreInteractions(mockAuthRepository);
  });
}