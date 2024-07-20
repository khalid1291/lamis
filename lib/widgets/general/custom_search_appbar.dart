import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/cubits/cubits.dart';
import 'package:lamis/models/categories/category_response.dart';

import 'package:lamis/res/resources_export.dart';
import 'package:lamis/widgets/widgets.dart';

import '../../cubits/search/selected_brands/selected_brands_cubit.dart';
import '../../main/filters_screen.dart';
import '../../models/brands/brands_response.dart';
import '../../models/products/product_mini_response.dart';
import '../../screens/screens.dart';

class CustomSearchAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomSearchAppBar(
      {Key? key,
      this.enableFilter = false,
      required this.onPressed,
      required this.onChanged,
      required this.searchController,
      this.categories,
      this.selectedCategoriesCubit,
      this.selectedBrandsCubit,
      this.pageNumber,
      this.searchTextController,
      this.products,
      this.resultCubit,
      this.minimumPrice,
      this.loadFirstCategories,
      this.loadFirstBrands,
      this.searchFiltersCubit,
      this.maximumPrice,
      this.searchKeyWordCubit,
      this.brands})
      : super(key: key);
  final bool enableFilter;
  final VoidCallback onPressed;
  final dynamic onChanged;
  final TextEditingController searchController;
  final List<Category>? categories;
  final List<Brands>? brands;
  final SelectedCategoriesCubit? selectedCategoriesCubit;
  final SelectedBrandsCubit? selectedBrandsCubit;

  final SearchKeyWordCubit? searchKeyWordCubit;
  final int? pageNumber;
  final Set<MiniProduct>? products;
  final TextEditingController? searchTextController;
  final SortResultCubit? resultCubit;

  final TextEditingController? minimumPrice;
  final TextEditingController? maximumPrice;
  final SearchFiltersCubit? searchFiltersCubit;

  final ShowHideSectionCubit? loadFirstCategories;
  final ShowHideSectionCubit? loadFirstBrands;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        size: 15,
        color: Theme.of(context).colorScheme.lamisColor,
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: NeumorphismContainer(
            child: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 20,
            // AssetImage(context.resources.images.leftArrow),
            color: Theme.of(context).colorScheme.lamisColor,
          ),
          onPressed: () {
            HapticFeedback.heavyImpact();
            Navigator.pop(context);
          },
        )),
      ),
      actions: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                BlocConsumer<MainPageCartCubit, MainPageCartState>(
                  bloc: context.read<MainPageCartCubit>(),
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is MainPageCartDone) {
                      return SizedBox(
                        width: 40,
                        child: NeumorphismContainer(
                            child: badge.Badge(
                          position: badge.BadgePosition.topEnd(
                            top: -3.0,
                            end: -3.5,
                          ),
                          badgeStyle: badge.BadgeStyle(
                              badgeColor:
                                  Theme.of(context).colorScheme.shadow200),
                          badgeContent: Text(
                            state.number.toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.shopping_cart_outlined,
                              size: 23,
                              color: Theme.of(context).colorScheme.lamisColor,
                            ),
                            onPressed: () {
                              HapticFeedback.heavyImpact();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const CartScreen();
                                  },
                                ),
                              );
                            },
                          ),
                        )),
                      );
                    }
                    return SizedBox(
                      width: 40,
                      child: NeumorphismContainer(
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: IconButton(
                            iconSize: 23,
                            icon: Icon(
                              Icons.shopping_cart_outlined,
                              color: Theme.of(context).colorScheme.lamisColor,
                            ),
                            onPressed: () {
                              HapticFeedback.heavyImpact();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const CartScreen();
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                enableFilter
                    ? Row(
                        children: [
                          SizedBox(
                            width: context.resources.dimension.defaultMargin,
                          ),
                          GestureDetector(
                            onTap: () async {
                              HapticFeedback.heavyImpact();
                              var res = await BottomSheets.showModal(context,
                                  type: BottomSheetType.big,
                                  hasBorderMargin: true,
                                  child: FiltersScreen(
                                    firstTimeCategories: loadFirstCategories!,
                                    firstTimeBrands: loadFirstBrands!,
                                    searchFiltersCubit: searchFiltersCubit!,
                                    minimumPrice: minimumPrice!,
                                    maximumPrice: maximumPrice!,
                                    resultCubit: resultCubit!,
                                    selectedBrandsCubit: selectedBrandsCubit!,
                                    searchTextController: searchTextController!,
                                    products: products ?? {},
                                    searchKeyWordCubit: searchKeyWordCubit!,
                                    pageNumber: pageNumber!,
                                    selectedCategoriesCubit:
                                        selectedCategoriesCubit!,
                                    categories: categories!,
                                    brands: brands!,
                                  ));
                            },
                            child: NeumorphismContainer(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ImageIcon(
                                  AssetImage(
                                      context.resources.images.filterIcon),
                                  size: 23,
                                  color:
                                      Theme.of(context).colorScheme.lamisColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            )),
      ],
      flexibleSpace: Padding(
        padding: EdgeInsets.fromLTRB(
            context.resources.dimension.zeroElevation,
            context.resources.dimension.defaultMargin,
            context.resources.dimension.zeroElevation,
            context.resources.dimension.zeroElevation),
        child: Column(
          children: [
            const SizedBox(
              height: 54,
            ),
            Padding(
                padding: MediaQuery.of(context).viewPadding.top >
                        context.resources.dimension
                            .extraHighElevation //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
                    ? EdgeInsets.only(
                        top: context.resources.dimension.extraHighElevation)
                    : EdgeInsets.only(
                        top: context.resources.dimension.highElevation),
                child: Container(
                  height: 54,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          context.resources.dimension.defaultMargin),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.lamisColor)
                      // boxShadow: [
                      //   BoxShadow(
                      //       color: Theme.of(context).colorScheme.shadow200,
                      //       offset: const Offset(-2, 0))
                      // ],
                      // gradient: LinearGradient(
                      //     colors:
                      //         Theme.of(context).colorScheme.blueShadeLiner)
                      ),
                  child: Padding(
                    padding: context.read<LocalizationCubit>().state ==
                            const Locale('en', '')
                        ? EdgeInsets.only(
                            left: context.resources.dimension.smallMargin)
                        : EdgeInsets.only(
                            right: context.resources.dimension.smallMargin),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Theme.of(context).colorScheme.lamisColor,
                        ),
                        SizedBox(
                          width: context.resources.dimension.smallMargin,
                        ),
                        Expanded(
                          child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .lamisColor,
                                      ),
                                      onPressed: onPressed),
                                  hintText: context.resources.strings.search,
                                  hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .subText),
                                  border: InputBorder.none),
                              onChanged: onChanged),
                        ),
                      ],
                    ),
                  ),
                )),
            // buildBottomAppBar(context)
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(120);
}
