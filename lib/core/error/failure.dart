import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);

  factory AuthFailure.passwordTooShort() {
    return const AuthFailure('Password is too short');
  }

  factory AuthFailure.emailAlreadyInUse() {
    return const AuthFailure('Email is already in use');
  }

  factory AuthFailure.invalidEmailAndPasswordCombination() {
    return const AuthFailure('Invalid email and password combination');
  }

  factory AuthFailure.tokenExpired() {
    return const AuthFailure('Token has expired');
  }
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}