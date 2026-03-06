import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_service.dart';

sealed class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({
    required this.email,
    required this.password,
  });
}

class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
  });
}

class AuthForgotPasswordRequested extends AuthEvent {
  final String email;
  final String petName;
  final String newPassword;

  AuthForgotPasswordRequested({
    required this.email,
    required this.petName,
    required this.newPassword,
  });
}

class AuthChangePasswordRequested extends AuthEvent {
  final String oldPassword;
  final String newPassword;

  AuthChangePasswordRequested({
    required this.oldPassword,
    required this.newPassword,
  });
}

class AuthDeleteAccountRequested extends AuthEvent {}

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


/// BLOC
class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final AuthService _service;

  AuthBloc(this._service) : super(AuthInitial()) {

    on<AuthCheckRequested>(_onCheck);

    on<AuthLoginRequested>(_onLogin);

    on<AuthRegisterRequested>(_onRegister);

    on<AuthForgotPasswordRequested>(_onForgotPassword);

    on<AuthChangePasswordRequested>(_onChangePassword);

    on<AuthDeleteAccountRequested>(_onDeleteAccount);

    on<AuthLogoutRequested>(_onLogout);
  }


  /// CHECK LOGIN
  Future<void> _onCheck(
      AuthCheckRequested event,
      Emitter<AuthState> emit,
      ) async {

    final loggedIn = await _service.isLoggedIn();

    if (!loggedIn) {
      emit(AuthUnauthenticated());
      return;
    }

    final user = await _service.getUser();

    emit(AuthAuthenticated(user ?? {}));
  }


  Future<void> _onLogin(
      AuthLoginRequested event,
      Emitter<AuthState> emit,
      ) async {

    emit(AuthLoading());

    try {

      final user = await _service.login(
        email: event.email,
        password: event.password,
      );

      emit(AuthAuthenticated(user));

    } catch (err) {

      emit(AuthError(err.toString().replaceFirst('Exception: ', '')));

    }
  }


  Future<void> _onRegister(
      AuthRegisterRequested event,
      Emitter<AuthState> emit,
      ) async {

    emit(AuthLoading());

    try {

      final user = await _service.register(
        name: event.name,
        email: event.email,
        password: event.password,
      );

      emit(AuthAuthenticated(user));

    } catch (err) {

      emit(AuthError(err.toString().replaceFirst('Exception: ', '')));

    }
  }


  Future<void> _onForgotPassword(
      AuthForgotPasswordRequested event,
      Emitter<AuthState> emit,
      ) async {

    emit(AuthLoading());

    try {

      await _service.forgotPassword(
        email: event.email,
        petName: event.petName,
        newPassword: event.newPassword,
      );

      emit(AuthUnauthenticated());

    } catch (err) {

      emit(AuthError(err.toString().replaceFirst('Exception: ', '')));

    }
  }


  Future<void> _onChangePassword(
      AuthChangePasswordRequested event,
      Emitter<AuthState> emit,
      ) async {

    emit(AuthLoading());

    try {

      await _service.changePassword(
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
      );

      final user = await _service.getUser();

      emit(AuthAuthenticated(user ?? {}));

    } catch (err) {

      emit(AuthError(err.toString().replaceFirst('Exception: ', '')));

    }
  }


  /// DELETE ACCOUNT
  Future<void> _onDeleteAccount(
      AuthDeleteAccountRequested event,
      Emitter<AuthState> emit,
      ) async {

    emit(AuthLoading());

    try {

      await _service.deleteAccount();

      emit(AuthUnauthenticated());

    } catch (err) {

      emit(AuthError(err.toString().replaceFirst('Exception: ', '')));

    }
  }


  /// LOGOUT
  Future<void> _onLogout(
      AuthLogoutRequested event,
      Emitter<AuthState> emit,
      ) async {

    await _service.logout();

    emit(AuthUnauthenticated());

  }
}