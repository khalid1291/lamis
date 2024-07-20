import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lamis/cubits/search/selected_brands/selected_brands_cubit.dart';
import 'package:lamis/models/brands/brands_response.dart';
import 'package:lamis/models/categories/category_response.dart';
import 'package:lamis/res/resources_export.dart';
import 'package:lamis/screens/home/home_screen.dart';
import 'package:lamis/widgets/widgets.dart';

import '../../cubits/cubits.dart';
import '../blocs/home/categories_bloc/categories_bloc.dart';
import '../models/products/product_mini_response.dart';

// ignore: must_be_immutable
class FiltersScreen extends StatefulWidget {
  FiltersScreen(
      {Key? key,
      required this.categories,
      required this.brands,
      required this.searchKeyWordCubit,
      required this.pageNumber,
      required this.products,
      required this.resultCubit,
      required this.searchFiltersCubit,
      required this.searchTextController,
      required this.maximumPrice,
      required this.minimumPrice,
      required this.firstTimeCategories,
      required this.firstTimeBrands,
      required this.selectedBrandsCubit,
      required this.selectedCategoriesCubit})
      : super(key: key);

  List<Category> categories;
  List<Brands> brands;
  SelectedCategoriesCubit selectedCategoriesCubit;
  SelectedBrandsCubit selectedBrandsCubit;

  SearchKeyWordCubit searchKeyWordCubit;
  TextEditingController searchTextController;
  Set<MiniProduct> products;
  SortResultCubit resultCubit;

  TextEditingController minimumPrice;
  TextEditingController maximumPrice;
  SearchFiltersCubit searchFiltersCubit;

  ShowHideSectionCubit firstTimeCategories;
  ShowHideSectionCubit firstTimeBrands;

  int pageNumber;

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  FToast fToast = FToast();

  late ShowHideSectionCubit _showHideCategories;
  late ShowHideSectionCubit _showHideBrands;
  late ShowHideSectionCubit _showHideSort;

  late CategoriesBloc categoriesBloc = CategoriesBloc();
  late BrandsCubit brandsCubit = BrandsCubit();

  @override
  void initState() {
    _showHideCategories = ShowHideSectionCubit(false);
    _showHideBrands = ShowHideSectionCubit(true);
    _showHideSort = ShowHideSectionCubit(true);
    fToast.init(context);

    // if (widget.categories.isEmpty) {
    //   print("empty");
    //   widget.categoriesBloc.add(FetchCategoriesWithAll());
    // }
    if (widget.firstTimeCategories.state) {
      // widget.firstTimeCategories.save(false);
      categoriesBloc.add(FetchCategoriesWithAll());
    }
    if (widget.firstTimeBrands.state) {
      // widget.firstTimeCategories.save(false);
      brandsCubit.getBrands();
    }

    super.initState();
  }

  Future<bool> _willPopCallback() async {
    Navigator.pop(context, true);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    // List<BoxShadow> boxShadowDetails = [
    //   BoxShadow(
    //       color: Theme.of(context).colorScheme.shadow400,
    //       offset: const Offset(4, 4),
    //       blurRadius: 10,
    //       spreadRadius: 1),
    //   BoxShadow(
    //       color: Theme.of(context).colorScheme.shadow200,
    //       offset: const Offset(3, 3),
    //       blurRadius: 10,
    //       spreadRadius: 1),
    //   BoxShadow(
    //       color: Theme.of(context).colorScheme.shadow100,
    //       offset: const Offset(-4, -4),
    //       blurRadius: 10,
    //       spreadRadius: 1),
    // ];
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.7,
                child: ListView(
                  children: [
                    CustomText(
                      content: context.resources.strings.price,
                      color: Theme.of(context).colorScheme.primaryTextColor,
                      titletype: TitleType.subtitle,
                      language: context.read<LocalizationCubit>().state ==
                              const Locale('en', '')
                          ? Language.ltr
                          : Language.rtl,
                    ).customMargins(),
                    const FixedHieght(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: SizedBox(
                          // height: 55,
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: CustomTextField(
                            enableAllReg: false,
                            limit: 5,
                            controller: widget.minimumPrice,
                            enableGrayShade: false,
                            isAddress: true,
                            titleState: false,
                            hint: context.resources.strings.minimum,
                            textInputType: TextInputType.number,
                            onChange: (val) {},
                            label: "",
                          ),
                        )),
                        Expanded(
                            child: SizedBox(
                          // height: 55,
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: CustomTextField(
                            enableAllReg: false,
                            limit: 5,
                            controller: widget.maximumPrice,
                            isAddress: true,
                            enableGrayShade: false,
                            titleState: false,
                            textInputType: TextInputType.number,
                            hint: context.resources.strings.maximum,
                            onChange: (val) {},
                            label: '',
                          ),
                        )),
                      ],
                    ),
                    const FixedHieght(
                      extra: true,
                    ),
                    BlocBuilder(
                        bloc: categoriesBloc,
                        builder: (context, categoryState) {
                          if (categoryState is CategoriesDone) {
                            if (widget.firstTimeCategories.state) {
                              widget.firstTimeCategories.save(false);

                              widget.categories
                                  .addAll(categoryState.value.categories);
                            }
                            widget.categories = categoryState.value.categories;
                          }

                          return BlocBuilder(
                            bloc: _showHideCategories,
                            builder: (context, state) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.heavyImpact();
                                      _showHideCategories
                                          .save(!_showHideCategories.state);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          content: context
                                              .resources.strings.category,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryTextColor,
                                          titletype: TitleType.subtitle,
                                        ),
                                        _showHideCategories.state
                                            ? const Icon(
                                                Icons.arrow_forward_rounded)
                                            : const Icon(
                                                Icons.arrow_downward_rounded),
                                      ],
                                    ),
                                  ),
                                  const FixedHieght(),
                                  SizedBox(
                                    child: Center(
                                        child: Container(
                                      height: 2,
                                      width: MediaQuery.of(context).size.width *
                                          0.62,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .lamisColor,
                                    )),
                                  ),
                                  BlocBuilder(
                                    bloc: widget.selectedCategoriesCubit,
                                    builder: (context, state) {
                                      return AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        height: _showHideCategories.state
                                            ? 0
                                            : (50 * widget.categories.length)
                                                .toDouble(),
                                        color: Colors.transparent,
                                        child: _showHideCategories.state
                                            ? Container()
                                            : categoriesList(widget.categories,
                                                categoryState),
                                      );
                                    },
                                  ),
                                ],
                              ).customMargins();
                            },
                          );
                        }),
                    const FixedHieght(),
                    BlocBuilder(
                        bloc: brandsCubit,
                        builder: (context, brandState) {
                          if (brandState is BrandsDone) {
                            if (widget.firstTimeBrands.state) {
                              widget.firstTimeBrands.save(false);

                              widget.brands.addAll(brandState.response.brands);
                            }
                          }
                          return BlocBuilder(
                            bloc: _showHideBrands,
                            builder: (context, state) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.heavyImpact();
                                      _showHideBrands
                                          .save(!_showHideBrands.state);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          content:
                                              context.resources.strings.brands,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryTextColor,
                                          titletype: TitleType.subtitle,
                                        ),
                                        _showHideBrands.state
                                            ? const Icon(
                                                Icons.arrow_forward_rounded)
                                            : const Icon(
                                                Icons.arrow_downward_rounded),
                                      ],
                                    ),
                                  ),
                                  const FixedHieght(),
                                  SizedBox(
                                    child: Center(
                                        child: Container(
                                      height: 2,
                                      width: MediaQuery.of(context).size.width *
                                          0.62,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .lamisColor,
                                    )),
                                  ),
                                  BlocBuilder(
                                    bloc: widget.selectedBrandsCubit,
                                    builder: (context, state) {
                                      return AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        height: _showHideBrands.state
                                            ? 0
                                            : (50 * widget.brands.length)
                                                .toDouble(),
                                        color: Colors.transparent,
                                        child: _showHideBrands.state
                                            ? Container()
                                            : brandsList(
                                                widget.brands, brandState),
                                      );
                                    },
                                  ),
                                ],
                              ).customMargins();
                            },
                          );
                        }),
                    const FixedHieght(),
                    BlocBuilder(
                      bloc: _showHideSort,
                      builder: (context, state) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.heavyImpact();
                                _showHideSort.save(!_showHideSort.state);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    content: context.resources.strings.sort,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryTextColor,
                                    titletype: TitleType.subtitle,
                                  ),
                                  _showHideSort.state
                                      ? const Icon(Icons.arrow_forward_rounded)
                                      : const Icon(
                                          Icons.arrow_downward_rounded),
                                ],
                              ),
                            ),
                            const FixedHieght(),
                            SizedBox(
                              child: Center(
                                  child: Container(
                                height: 2,
                                width: MediaQuery.of(context).size.width * 0.62,
                                color: Theme.of(context).colorScheme.lamisColor,
                              )),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              height: _showHideSort.state
                                  ? 0
                                  : (50 * widget.resultCubit.sortResult.length)
                                      .toDouble(),
                              color: Colors.transparent,
                              child: _showHideSort.state
                                  ? Container()
                                  : BlocBuilder(
                                      bloc: widget.resultCubit,
                                      builder: (BuildContext context, state) {
                                        return sortResultList(
                                            widget.resultCubit.sortResult);
                                      },
                                    ),
                            ),
                          ],
                        ).customMargins();
                      },
                    ),
                    const FixedHieght(),
                  ],
                ),
              ),
              Center(
                child: Container(
                  height: context.resources.dimension.priceContainer,
                  width: MediaQuery.of(context).size.width / 1.5,
                  decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //     begin: Alignment.topLeft,
                    //     end: Alignment.bottomRight,
                    //     colors: Theme.of(context).colorScheme.blueShadeLiner),
                    color: Theme.of(context).colorScheme.scaffoldColor,
                    // boxShadow: boxShadowDetails,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.lamisColor),
                    borderRadius: BorderRadius.circular(
                        context.resources.dimension.veryHighElevation),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.heavyImpact();
                          //Navigator.pop(context, widget.categories);
                          if (widget.minimumPrice.text.isNotEmpty &&
                              widget.maximumPrice.text.isNotEmpty) {
                            if (int.parse(widget.minimumPrice.text) >
                                int.parse(widget.maximumPrice.text)) {
                              fToast.showToast(
                                child: ToastBody(
                                  text: context
                                      .resources.strings.minBiggerThenMax,
                                  bgColor: Theme.of(context)
                                      .colorScheme
                                      .toastBackGround,
                                ),
                                gravity: ToastGravity.BOTTOM,
                                toastDuration: const Duration(seconds: 2),
                              );
                            } else {
                              widget.searchFiltersCubit.addBrands(
                                  widget.selectedBrandsCubit.state,
                                  widget.brands);
                              widget.resultCubit.state.key ==
                                      "price_low_to_high"
                                  ? widget.searchFiltersCubit.addSort(
                                      Filter(
                                          name: widget.resultCubit.state.name,
                                          key: 0,
                                          isDeletable: true),
                                      true)
                                  : widget.searchFiltersCubit.addSort(
                                      Filter(
                                          name: widget.resultCubit.state.name,
                                          key: 0,
                                          isDeletable: true),
                                      false);

                              widget.pageNumber = 1;
                              widget.products.clear();
                              if (widget.minimumPrice.text.isNotEmpty ||
                                  widget.maximumPrice.text.isNotEmpty) {
                                widget.searchFiltersCubit.addPrice(
                                    widget.minimumPrice.text,
                                    widget.maximumPrice.text);
                              }

                              widget.searchKeyWordCubit.searchTheKeyWord(
                                  widget.searchTextController.text,
                                  widget.pageNumber,
                                  sortKey: widget.resultCubit.state.key,
                                  brands: widget.selectedBrandsCubit.state
                                      .join(",")
                                      .toString(),
                                  categories: widget
                                      .selectedCategoriesCubit.state
                                      .toString(),
                                  min: widget.minimumPrice.text,
                                  max: widget.maximumPrice.text);

                              Navigator.pop(context, widget.categories);
                            }
                          } else {
                            widget.searchFiltersCubit.addBrands(
                                widget.selectedBrandsCubit.state,
                                widget.brands);
                            widget.resultCubit.state.key == "price_low_to_high"
                                ? widget.searchFiltersCubit.addSort(
                                    Filter(
                                        name: widget.resultCubit.state.name,
                                        key: 0,
                                        isDeletable: true),
                                    true)
                                : widget.searchFiltersCubit.addSort(
                                    Filter(
                                        name: widget.resultCubit.state.name,
                                        key: 0,
                                        isDeletable: true),
                                    false);

                            widget.pageNumber = 1;
                            widget.products.clear();
                            if (widget.minimumPrice.text.isNotEmpty ||
                                widget.maximumPrice.text.isNotEmpty) {
                              widget.searchFiltersCubit.addPrice(
                                  widget.minimumPrice.text,
                                  widget.maximumPrice.text);
                            }

                            widget.searchKeyWordCubit.searchTheKeyWord(
                                widget.searchTextController.text,
                                widget.pageNumber,
                                sortKey: widget.resultCubit.state.key,
                                brands: widget.selectedBrandsCubit.state
                                    .join(",")
                                    .toString(),
                                categories: widget.selectedCategoriesCubit.state
                                    .toString(),
                                min: widget.minimumPrice.text,
                                max: widget.maximumPrice.text);

                            Navigator.pop(context, widget.categories);
                          }
                          // onPressAddToCart(context, _addedToCartSnackbar);
                          // widget.selectedCategoriesCubit.save(0);
                          // widget.selectedBrandsCubit.defaultBrands();
                          // widget.minimumPrice.text = "";
                          // widget.maximumPrice.text = "";
                          // widget.selectedBrandsCubit.removeAll(widget.brands);
                          // widget.resultCubit.init();
                          // widget.resultCubit
                          //     .save(widget.resultCubit.sortResult[0]);
                        },
                        child: Center(
                          child: CustomText(
                            content: context.resources.strings.close,
                            titletype: TitleType.bottoms,
                            color:
                                Theme.of(context).colorScheme.primaryTextColor,
                            language: Language.center,
                          ),
                        ),
                      ),
                      Container(
                        width: context.resources.dimension.selectedBorder,
                        color: Theme.of(context).colorScheme.lamisColor,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.heavyImpact();
                            //onPressBuyNow(context);

                            if (widget.minimumPrice.text.isNotEmpty &&
                                widget.maximumPrice.text.isNotEmpty) {
                              if (int.parse(widget.minimumPrice.text) >
                                  int.parse(widget.maximumPrice.text)) {
                                fToast.showToast(
                                  child: ToastBody(
                                    text: context
                                        .resources.strings.minBiggerThenMax,
                                    bgColor: Theme.of(context)
                                        .colorScheme
                                        .toastBackGround,
                                  ),
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: const Duration(seconds: 2),
                                );
                              } else {
                                widget.searchFiltersCubit.addBrands(
                                    widget.selectedBrandsCubit.state,
                                    widget.brands);
                                widget.resultCubit.state.key ==
                                        "price_low_to_high"
                                    ? widget.searchFiltersCubit.addSort(
                                        Filter(
                                            name: widget.resultCubit.state.name,
                                            key: 0,
                                            isDeletable: true),
                                        true)
                                    : widget.searchFiltersCubit.addSort(
                                        Filter(
                                            name: widget.resultCubit.state.name,
                                            key: 0,
                                            isDeletable: true),
                                        false);

                                widget.pageNumber = 1;
                                widget.products.clear();
                                if (widget.minimumPrice.text.isNotEmpty ||
                                    widget.maximumPrice.text.isNotEmpty) {
                                  widget.searchFiltersCubit.addPrice(
                                      widget.minimumPrice.text,
                                      widget.maximumPrice.text);
                                }

                                widget.searchKeyWordCubit.searchTheKeyWord(
                                    widget.searchTextController.text,
                                    widget.pageNumber,
                                    sortKey: widget.resultCubit.state.key,
                                    brands: widget.selectedBrandsCubit.state
                                        .join(",")
                                        .toString(),
                                    categories: widget
                                        .selectedCategoriesCubit.state
                                        .toString(),
                                    min: widget.minimumPrice.text,
                                    max: widget.maximumPrice.text);

                                Navigator.pop(context, widget.categories);
                              }
                            } else {
                              widget.searchFiltersCubit.addBrands(
                                  widget.selectedBrandsCubit.state,
                                  widget.brands);
                              widget.resultCubit.state.key ==
                                      "price_low_to_high"
                                  ? widget.searchFiltersCubit.addSort(
                                      Filter(
                                          name: widget.resultCubit.state.name,
                                          key: 0,
                                          isDeletable: true),
                                      true)
                                  : widget.searchFiltersCubit.addSort(
                                      Filter(
                                          name: widget.resultCubit.state.name,
                                          key: 0,
                                          isDeletable: true),
                                      false);

                              widget.pageNumber = 1;
                              widget.products.clear();
                              if (widget.minimumPrice.text.isNotEmpty ||
                                  widget.maximumPrice.text.isNotEmpty) {
                                widget.searchFiltersCubit.addPrice(
                                    widget.minimumPrice.text,
                                    widget.maximumPrice.text);
                              }

                              widget.searchKeyWordCubit.searchTheKeyWord(
                                  widget.searchTextController.text,
                                  widget.pageNumber,
                                  sortKey: widget.resultCubit.state.key,
                                  brands: widget.selectedBrandsCubit.state
                                      .join(",")
                                      .toString(),
                                  categories: widget
                                      .selectedCategoriesCubit.state
                                      .toString(),
                                  min: widget.minimumPrice.text,
                                  max: widget.maximumPrice.text);

                              Navigator.pop(context, widget.categories);
                            }
                          },
                          child: CustomText(
                            content: context.resources.strings.apply,
                            // AppLocalizations.of(context).product_details_screen_button_buy_now,
                            titletype: TitleType.bottoms,
                            color:
                                Theme.of(context).colorScheme.primaryTextColor,
                            language: Language.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sortResultList(List<SortResult> sortResult) {
    return Container(
        color: Colors.transparent,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: sortResult.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return DelayedAnimation(
              fromSide: FromSide.right,
              delay: 200 * index,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.heavyImpact();
                  widget.resultCubit.save(sortResult[index]);
                },
                child: Row(
                  children: [
                    SizedBox(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 35,
                            height: 50,
                            child: NeumorphismContainer(
                                child: widget.resultCubit.state.key ==
                                        sortResult[index].key
                                    ? Icon(
                                        Icons.check_outlined,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .lamisColor,
                                      )
                                    : const SizedBox(
                                        height: 25,
                                        width: 25,
                                      )),
                          ),
                          SizedBox(
                            width: context.resources.dimension.mediumMargin,
                          ),
                          CustomText(content: sortResult[index].name)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }

  Widget brandsList(List<Brands> brands, state) {
    return Container(
        height: 200,
        color: Colors.transparent,
        child: state is BrandsError
            ? errorState(false)
            : ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: brands.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return DelayedAnimation(
                    fromSide: FromSide.right,
                    delay: 200 * index,
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        if (widget.selectedBrandsCubit
                            .check(brands[index].id)) {
                          widget.selectedBrandsCubit
                              .remove(brands[index].id, widget.brands);
                        } else {
                          widget.selectedBrandsCubit
                              .add(brands[index].id, widget.brands);
                        }
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 35,
                                  height: 50,
                                  child: NeumorphismContainer(
                                      child: widget.selectedBrandsCubit.state
                                              .contains(brands[index].id)
                                          ? Icon(
                                              Icons.check_outlined,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .lamisColor,
                                            )
                                          : const SizedBox(
                                              height: 25,
                                              width: 25,
                                            )),
                                ),
                                SizedBox(
                                  width:
                                      context.resources.dimension.mediumMargin,
                                ),
                                CustomText(content: brands[index].name)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ));
  }

  Widget categoriesList(List<Category> categories, state) {
    return Container(
        height: 250,
        color: Colors.transparent,
        child: state is CategoriesError
            ? errorState(true)
            : ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: categories.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return DelayedAnimation(
                    fromSide: FromSide.right,
                    delay: 200 * index,
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        if (categories[index].id == 0) {
                          widget.searchFiltersCubit.addCategory(
                              Filter(
                                  name: categories[index].name,
                                  key: 1,
                                  isDeletable: true),
                              true);
                        } else {
                          widget.searchFiltersCubit.addCategory(
                              Filter(
                                  name: categories[index].name,
                                  key: 1,
                                  isDeletable: true),
                              false);
                        }
                        widget.selectedCategoriesCubit
                            .updateList(categories, categories[index].id);
                        //_selectedCategoriesCubit.save(categories[index].id);
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 35,
                                  height: 50,
                                  child: NeumorphismContainer(
                                      child: widget.selectedCategoriesCubit
                                                  .state ==
                                              categories[index].id
                                          ? Icon(
                                              Icons.check_outlined,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .lamisColor,
                                            )
                                          : const SizedBox(
                                              height: 25,
                                              width: 25,
                                            )),
                                ),
                                SizedBox(
                                  width:
                                      context.resources.dimension.mediumMargin,
                                ),
                                CustomText(content: categories[index].name)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ));
  }

  Widget errorState(bool isCategories) {
    return SizedBox(
      width: 500,
      child: CustomErrorWidget(onTap: () {
        if (isCategories) {
          categoriesBloc.add(FetchCategoriesWithAll());
        } else {
          brandsCubit.getBrands();
        }
      }),
    );
  }

  @override
  void dispose() {
    fToast.removeCustomToast();
    fToast.removeQueuedCustomToasts();
    super.dispose();
  }

  // Widget categoryError() {
  //   return GestureDetector(
  //       onTap: () {
  //         categoriesBloc = CategoriesBloc()..add(FetchCategoriesWithAll());
  //       },
  //       child: CustomText(
  //         content: context.resources.strings.pleaseReload,
  //         color: Theme.of(context).colorScheme.redColor,
  //         titletype: TitleType.subtitle,
  //       ));
  // }
}
