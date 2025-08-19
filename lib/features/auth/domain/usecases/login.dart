import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase.dart';
import '../entities/authenticated_user.dart';
import '../repositories/auth_repository.dart';

class Login implements UseCase<AuthenticatedUser, LoginParams> {
  final AuthRepository repository;

  const Login(this.repository);

  @override
  Future<Either<Failure, AuthenticatedUser>> call(LoginParams params) async {
    return await repository.login(
        email: params.email, password: params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}