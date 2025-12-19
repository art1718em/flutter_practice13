import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice13/domain/usecases/auth/login_usecase.dart';
import 'package:flutter_practice13/domain/usecases/auth/register_usecase.dart';
import 'package:flutter_practice13/domain/usecases/auth/logout_usecase.dart';
import 'package:flutter_practice13/domain/usecases/auth/get_current_user_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(const AuthState()) {
    checkAuth();
  }

  Future<void> checkAuth() async {
    try {
      final user = await getCurrentUserUseCase();
      if (user != null) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        ));
      } else {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
      }
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    await Future.delayed(const Duration(seconds: 1));

    if (!_isValidEmail(email)) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Неверный формат email',
      ));
      return;
    }

    try {
      final user = await loginUseCase(email, password);
      if (user != null) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          clearError: true,
        ));
      } else {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Ошибка входа',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> register(String email, String password, String name) async {
    emit(state.copyWith(status: AuthStatus.loading));
    await Future.delayed(const Duration(seconds: 1));

    if (!_isValidEmail(email)) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Неверный формат email',
      ));
      return;
    }

    if (password.length < 6) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Пароль должен быть не менее 6 символов',
      ));
      return;
    }

    if (name.trim().isEmpty) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Введите имя',
      ));
      return;
    }

    try {
      final user = await registerUseCase(email, password, name);
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> logout() async {
    await logoutUseCase();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
