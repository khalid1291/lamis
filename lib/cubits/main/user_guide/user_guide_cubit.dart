import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserGuideCubit extends Cubit<bool> {
  GlobalKey slider = GlobalKey();
  GlobalKey ourBrands = GlobalKey();
  GlobalKey todayDeal = GlobalKey();
  GlobalKey featuredCategories = GlobalKey();
  GlobalKey searchButton = GlobalKey();
  GlobalKey productDetails = GlobalKey();

  UserGuideCubit(bool initialState) : super(initialState);
}
