import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/models.dart';
import '../../../repos//repos.dart';

part 'featured_products_event.dart';
part 'featured_products_state.dart';

class FeaturedProductsBloc
    extends Bloc<FeaturedProductsEvent, FeaturedProductsState> {
  FeaturedProductsBloc() : super(FeaturedProductsInitial()) {
    final myRepo = ProductRepo();

    on<FeaturedProductsEvent>((event, emit) async {
      if (event is FeaturedProductsFetch) {
        emit(FeaturedProductsLoading());
        await myRepo
            .getFeaturedProducts()
            .then((value) => emit(FeaturedProductsDone(value)))
            .onError((error, stackTrace) => emit(FeaturedProductsError()));
      }
    });
  }
}
