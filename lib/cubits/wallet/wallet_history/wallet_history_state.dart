part of 'wallet_history_cubit.dart';

abstract class WalletHistoryState {}

class WalletHistoryInitial extends WalletHistoryState {}

class WalletHistoryLoading extends WalletHistoryState {}

class WalletHistoryDone extends WalletHistoryState {
  final WalletHistoryResponse walletHistoryResponse;

  WalletHistoryDone({required this.walletHistoryResponse});
}

class WalletHistoryPagination extends WalletHistoryState {}

class WalletHistoryError extends WalletHistoryState {}
