import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase.dart';
import '../entities/authenticated_user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser implements UseCase<AuthenticatedUser, NoParams> {
  final AuthRepository repository;

  const GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, AuthenticatedUser>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}