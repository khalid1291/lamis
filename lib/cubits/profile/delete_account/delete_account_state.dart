part of 'delete_account_cubit.dart';

abstract class DeleteAccountState {}

class DeleteAccountInitial extends DeleteAccountState {}

class DeleteAccountLoading extends DeleteAccountState {}

class DeleteAccountDone extends DeleteAccountState {}

class DeleteAccountError extends DeleteAccountState {
  final String message;

  DeleteAccountError(this.message);
}
