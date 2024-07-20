import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/res/app_context_extension.dart';

import '../../../../../models/models.dart';
import '../../../../../repos/repos.dart';
import '../../../main.dart';

part 'brand_products_state.dart';

class BrandProductsCubit extends Cubit<BrandProductState> {
  BrandProductsCubit() : super(BrandProductInitial());
  ProductRepo repo = ProductRepo();

  void getBrandProducts(
      {required int brandId, required int page, required String name}) async {
    if (page == 1) {
      emit(BrandProductLoading());
    } else {
      emit(BrandProductPagination());
    }

    try {
      ProductMiniResponse response =
          await repo.getBrandProducts(brandId: brandId, page: page, name: name);
      // unComment this to view the pagination loading effect
      // List<MiniProduct> products = [];
      //
      // for (int i = 0; i < 10; i++) {
      //   products.add(MiniProduct(
      //     id: 0,
      //     name: "name",
      //     thumbnailImage: "thumbnailImage",
      //     mainPrice: "mainPrice",
      //     strokedPrice: "800",
      //     hasDiscount: false,
      //     rating: 0,
      //     sales: 0,
      //     links: Links(),
      //   ));
      // }
      //
      // response.products = products;
      emit(BrandProductDone(response: response));
    } catch (e) {
      emit(
          BrandProductError(message: MyApp.context.resources.strings.errorGot));
    }
  }
}
