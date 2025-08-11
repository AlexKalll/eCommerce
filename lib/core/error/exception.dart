import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  final String message;

  const ServerException({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthenticationException extends Equatable implements Exception {
  final String message;

  const AuthenticationException({required this.message});

  @override
  List<Object?> get props => [message];

  factory AuthenticationException.passwordTooShort() {
    return const AuthenticationException(message: 'Password is too short');
  }

  factory AuthenticationException.emailAlreadyInUse() {
    return const AuthenticationException(message: 'Email is already in use');
  }

  factory AuthenticationException.invalidEmailAndPasswordCombination() {
    return const AuthenticationException(
        message: 'Invalid email and password combination');
  }

  factory AuthenticationException.tokenExpired() {
    return const AuthenticationException(message: 'Token has expired');
  }
}

class CacheException extends Equatable implements Exception {
  final String message;

  const CacheException({required this.message});

  @override
  List<Object?> get props => [message];
}