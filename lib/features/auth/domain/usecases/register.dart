import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase.dart';
import '../entities/authenticated_user.dart';
import '../repositories/auth_repository.dart';

class Register implements UseCase<AuthenticatedUser, RegisterParams> {
  final AuthRepository repository;

  const Register(this.repository);

  @override
  Future<Either<Failure, AuthenticatedUser>> call(RegisterParams params) async {
    if (params.password.length < 6) {
      return Left(AuthFailure.passwordTooShort());
    }

    return await repository.register(
        name: params.name, email: params.email, password: params.password);
  }
}

class RegisterParams extends Equatable {
  final String name;
  final String email;
  final String password;

  const RegisterParams(this.name, this.email, this.password);

  @override
  List<Object?> get props => [name, email, password];
}