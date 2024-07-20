part of 'wallet_balance_cubit.dart';

abstract class WalletBalanceState {}

class WalletBalanceInitial extends WalletBalanceState {}

class WalletBalanceLoading extends WalletBalanceState {}

class WalletBalanceDone extends WalletBalanceState {
  final WalletBalanceResponse walletBalanceResponse;

  WalletBalanceDone({required this.walletBalanceResponse});
}

class WalletBalanceError extends WalletBalanceState {}
