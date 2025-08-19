part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoadInProgress extends AuthState {
  const AuthLoadInProgress();
}

class AuthLoadSuccess extends AuthState {
  final AuthenticatedUser user;

  const AuthLoadSuccess(this.user);
}

class AuthLoadFailure extends AuthState {
  final String message;

  const AuthLoadFailure(this.message);
}

class AuthLogoutSuccess extends AuthState {
  const AuthLogoutSuccess();
}

class AuthLogoutFailure extends AuthState {
  final String message;

  const AuthLogoutFailure(
    this.message,
  );
}

class AuthRegisterSuccess extends AuthState {
  final AuthenticatedUser user;

  const AuthRegisterSuccess(this.user);
}

class AuthRegisterFailure extends AuthState {
  final String message;

  const AuthRegisterFailure(
    this.message,
  );
}

class AuthLoginSuccess extends AuthState {
  final AuthenticatedUser user;
  const AuthLoginSuccess(this.user);
}

class AuthLoginInProgress extends AuthState {
  const AuthLoginInProgress();
}

class AuthRegisterInProgress extends AuthState {
  const AuthRegisterInProgress();
}

class AuthLogoutInProgress extends AuthState {
  const AuthLogoutInProgress();
}

class AuthLoginFailure extends AuthState {
  final String message;

  const AuthLoginFailure(this.message);
}