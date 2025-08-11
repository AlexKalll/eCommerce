import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase.dart';
import '../../domain/entities/authenticated_user.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/register.dart';

part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final Register register;
  final Logout logout;
  final GetCurrentUser getCurrentUser;

  AuthBloc({
    required this.login,
    required this.register,
    required this.logout,
    required this.getCurrentUser,
  }) : super(const AuthInitial()) {
    on<AuthLoadRequested>(_onLoadRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoadRequested(
      AuthLoadRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoadInProgress());

    final user = await getCurrentUser(NoParams());

    user.fold(
      (failure) => emit(AuthLoadFailure(failure.message)),
      (user) => emit(AuthLoadSuccess(user)),
    );
  }

  Future<void> _onLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoginInProgress());

    final result = await login(LoginParams(event.email, event.password));

    result.fold(
      (failure) => emit(AuthLoginFailure(failure.message)),
      (user) {
        emit(AuthLoginSuccess(user));
        emit(AuthLoadSuccess(user));
      },
    );
  }

  Future<void> _onRegisterRequested(
      AuthRegisterRequested event, Emitter<AuthState> emit) async {
    emit(const AuthRegisterInProgress());

    final result =
        await register(RegisterParams(event.name, event.email, event.password));

    result.fold(
      (failure) => emit(AuthRegisterFailure(failure.message)),
      (user) {
        emit(AuthRegisterSuccess(user));
        emit(AuthLoadSuccess(user));
      },
    );
  }

  Future<void> _onLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLogoutInProgress());

    final result = await logout(NoParams());

    result.fold(
      (failure) => emit(AuthLogoutFailure(failure.message)),
      (_) => emit(const AuthLogoutSuccess()),
    );
  }
}