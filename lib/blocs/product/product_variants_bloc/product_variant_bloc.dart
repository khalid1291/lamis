import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/models.dart';
import '../../../repos/repos.dart';

part 'product_variant_event.dart';
part 'product_variant_state.dart';

class ProductVariantBloc
    extends Bloc<ProductVariantEvent, ProductVariantState> {
  final _myRepo = ProductRepo();
  ProductVariantBloc() : super(ProductVariantInitial()) {
    on<ProductVariantEvent>((event, emit) async {
      emit(ProductVariantLoading());
      if (event is FetchProductVariants) {
        await _myRepo
            .getVariantPostInfo(
                id: event.id, color: event.color, variants: event.variant)
            .then((value) {
          emit(ProductVariantDone(value!));
        }).onError((error, stackTrace) {
          emit(ProductVariantError());
        });
      }
    });
  }
}
