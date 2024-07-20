part of 'main_page_cart_cubit.dart';

abstract class MainPageCartState {}

class MainPageCartInitial extends MainPageCartState {}

class MainPageCartLoading extends MainPageCartState {}

class MainPageCartDone extends MainPageCartState {
  final int number;

  MainPageCartDone(this.number);
}

class MainPageCartError extends MainPageCartState {}
