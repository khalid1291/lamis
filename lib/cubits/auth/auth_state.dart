part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthDone extends AuthState {
  final LoginResponse loginResponse;

  AuthDone({required this.loginResponse});
}

class AuthDoneBeforeVerification extends AuthState {
  final GeneralResponse loginResponse;

  AuthDoneBeforeVerification({required this.loginResponse});
}

class RegisterSuccess extends AuthState {
  final SignupResponse signupResponse;

  RegisterSuccess({required this.signupResponse});
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}
