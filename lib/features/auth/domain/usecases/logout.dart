import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase.dart';
import '../repositories/auth_repository.dart';

class Logout implements UseCase<Unit, NoParams> {
  final AuthRepository repository;

  const Logout(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await repository.logout();
  }
}