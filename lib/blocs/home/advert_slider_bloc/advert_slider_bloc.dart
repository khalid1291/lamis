import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repos/repos.dart';
import '../../../models/models.dart';

part 'advert_slider_event.dart';
part 'advert_slider_state.dart';

class AdvertSliderBloc extends Bloc<AdvertSliderEvent, AdvertSliderState> {
  final _myRepo = CarouselRepoImp();
  AdvertSliderBloc() : super(AdvertSliderInitial()) {
    on<AdvertSliderEvent>((event, emit) async {
      if (event is AdvertSliderFetch) {
        emit(AdvertSliderLoading());
        await _myRepo
            .getCarouselSliders()
            .then((value) => emit(AdvertSliderDone(value)))
            .onError((error, stackTrace) => emit(AdvertSliderError()));
      }
    });
  }
}
