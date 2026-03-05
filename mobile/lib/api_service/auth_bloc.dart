
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_service.dart';

sealed class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email, password;
  AuthLoginRequested({required this.email, required this.password});
}

class AuthRegisterRequested extends AuthEvent {
  final String name, email, password;
  AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
  });
}

class AuthLogoutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final Map<String, dynamic> user;
  AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _service;

  AuthBloc(this._service) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onCheck);
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthLogoutRequested>(_onLogout);
  }

  Future<void> _onCheck(AuthCheckRequested e, Emitter emit) async {

    final loggedIn = await _service.isLoggedIn();

    if (!loggedIn) {
      emit(AuthUnauthenticated());
      return;
    }

    final user = await _service.getUser();

    emit(AuthAuthenticated(user ?? {}));
  }
  Future<void> _onLogin(AuthLoginRequested e, Emitter emit) async {
    emit(AuthLoading());
    try {
      final user = await _service.login(email: e.email, password: e.password);
      emit(AuthAuthenticated(user));
    } catch (err) {
      emit(AuthError(err.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onRegister(AuthRegisterRequested e, Emitter emit) async {
    emit(AuthLoading());
    try {
      final user = await _service.register(
        name: e.name,
        email: e.email,
        password: e.password,
      );
      emit(AuthAuthenticated(user));
    } catch (err) {
      emit(AuthError(err.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onLogout(AuthLogoutRequested e, Emitter emit) async {
    await _service.logout();
    emit(AuthUnauthenticated());
  }
}