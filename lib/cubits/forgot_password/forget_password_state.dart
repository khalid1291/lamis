part of 'forget_password_cubit.dart';

abstract class VerificationState {}

class VerificationInitial extends VerificationState {}

class VerificationLoading extends VerificationState {}

class VerificationDone extends VerificationState {
  final LoginResponse loginResponse;
  VerificationDone({required this.loginResponse});
}

class VerifyRegisterDone extends VerificationState {
  final LoginResponse generalResponse;
  VerifyRegisterDone({required this.generalResponse});
}

class VerificationError extends VerificationState {
  final String message;
  VerificationError({required this.message});
}
