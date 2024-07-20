part of 'today_deal_bloc.dart';

abstract class TodayDealState {}

class TodayDealInitial extends TodayDealState {}

class TodayDealLoading extends TodayDealState {}

class TodayDealDone extends TodayDealState {
  final ProductMiniResponse value;

  TodayDealDone(this.value);
}

class TodayDealError extends TodayDealState {}
