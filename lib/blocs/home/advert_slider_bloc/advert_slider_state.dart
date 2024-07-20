part of 'advert_slider_bloc.dart';

abstract class AdvertSliderState {}

class AdvertSliderInitial extends AdvertSliderState {}

class AdvertSliderLoading extends AdvertSliderState {}

class AdvertSliderDone extends AdvertSliderState {
  final CarouselSliderResponse value;
  AdvertSliderDone(this.value);
}

class AdvertSliderError extends AdvertSliderState {}
