import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/screens/home/home_screen.dart';

import '../cubits/cubits.dart';
import '../cubits/search/selected_brands/selected_brands_cubit.dart';
import '../models/models.dart';
import '../res/resources_export.dart';
import '../widgets/widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ScrollController _productScrollController = ScrollController();
  late SearchKeyWordCubit _searchKeyWordCubit;
  // late CategoriesBloc categoriesBloc;
  late SelectedCategoriesCubit _selectedCategoriesCubit;
  late TextEditingController searchTextController;
  // final BrandsCubit _brandsCubit = BrandsCubit();
  late SelectedBrandsCubit selectedBrandsCubit;
  late SortResultCubit _resultCubit;
  late SearchFiltersCubit searchFiltersCubit;

  TextEditingController minimumPrice = TextEditingController();
  TextEditingController maximumPrice = TextEditingController();

  Set<MiniProduct> products = {};
  List<Brands> brands = [];
  List<Category> categories = [];
  Timer? _debounce;
  int pageNumber = 1;
  ShowHideSectionCubit firstLoadCategories = ShowHideSectionCubit(true);
  ShowHideSectionCubit firstLoadBrands = ShowHideSectionCubit(true);

  fetchAll() {
    _searchKeyWordCubit.searchTheKeyWord(searchTextController.text, pageNumber,
        sortKey: _resultCubit.state.key,
        brands: selectedBrandsCubit.state.join(",").toString(),
        categories: _selectedCategoriesCubit.state.toString(),
        min: minimumPrice.text,
        max: maximumPrice.text);
  }

  fetchAllInitial() {
    _searchKeyWordCubit.searchTheKeyWord(searchTextController.text, 1,
        sortKey: _resultCubit.state.key,
        brands: selectedBrandsCubit.state.join(",").toString(),
        categories: _selectedCategoriesCubit.state.toString(),
        min: minimumPrice.text,
        max: maximumPrice.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: CustomSearchAppBar(
          loadFirstCategories: firstLoadCategories,
          loadFirstBrands: firstLoadBrands,
          searchFiltersCubit: searchFiltersCubit,
          minimumPrice: minimumPrice,
          maximumPrice: maximumPrice,
          resultCubit: _resultCubit,
          selectedBrandsCubit: selectedBrandsCubit,
          products: products,
          pageNumber: pageNumber,
          searchTextController: searchTextController,
          searchKeyWordCubit: _searchKeyWordCubit,
          enableFilter: true,
          selectedCategoriesCubit: _selectedCategoriesCubit,
          categories: categories,
          brands: brands,
          onPressed: () {
            /* Clear the search field */
            if (searchTextController.text.isNotEmpty) {
              searchTextController.clear();
              pageNumber = 1;
              products.clear();
              fetchAll();
            }
            // _selectedCategoriesCubit.state == -1
            //     ? _searchKeyWordCubit.searchTheKeyWord(
            //         searchTextController.text, pageNumber)
            //     : _searchKeyWordCubit.searchCategoryProduct(
            //         _selectedCategoriesCubit.state,
            //         searchTextController.text,
            //         pageNumber);
          },
          onChanged: (value) {
            if (_debounce?.isActive ?? false) {
              _debounce?.cancel();
            }
            _debounce = Timer(const Duration(milliseconds: 500), () {
              pageNumber = 1;
              products.clear();
              _selectedCategoriesCubit.state == 0
                  ? _searchKeyWordCubit.searchTheKeyWord(
                      searchTextController.text, pageNumber)
                  : _searchKeyWordCubit.searchCategoryProduct(
                      _selectedCategoriesCubit.state,
                      searchTextController.text,
                      pageNumber);
            });
          },
          searchController: searchTextController,
        ),
      ),
      body: ListView(
        controller: _productScrollController,
        children: [
          // BlocBuilder(
          //     bloc: _brandsCubit,
          //     builder: (context, state) {
          //       if (state is BrandsDone) {
          //         brands = state.response.brands;
          //         selectedBrandsCubit.add(0, brands, addAll: true);
          //       }
          //       return Container();
          //     }),
          SizedBox(
            height: context.resources.dimension.mediumMargin,
          ),
          // BlocBuilder(
          //   bloc: categoriesBloc,
          //   builder: (BuildContext context, state) {
          //     if (state is CategoriesDone) {
          //       categories = state.value.categories;
          //     } else if (state is CategoriesError) {
          //       return categoryError();
          //     }
          //     return Container();
          //   },
          // ),
          BlocBuilder(
            bloc: searchFiltersCubit,
            builder: (BuildContext context, state) {
              return categorySection(searchFiltersCubit.state, false);
            },
          ),
          const FixedHieght(),
          SizedBox(
            child: Center(
                child: Container(
              height: context.resources.dimension.selectedBorder / 2,
              width: 170,
              color: Theme.of(context).colorScheme.primaryTextColor,
            )),
          ),
          const FixedHieght(),
          Center(
            child: CustomText(
              content: context.resources.strings.searchResult,
              titletype: TitleType.subtitle,
              language: Language.center,
            ),
          ),
          const FixedHieght(),
          BlocBuilder<SearchKeyWordCubit, SearchKeyWordState>(
            bloc: _searchKeyWordCubit,
            builder: (context, state) {
              if (state is SearchKeyWordLoading) {
                return const ProductCartShimmer();
              }
              if (state is SearchKeyWordDone ||
                  state is SearchKeyWordPagination) {
                if (state is SearchKeyWordDone) {
                  products.addAll(state.response.products);
                }
                if (products.isEmpty) {
                  return const NoDataFound();
                }
                return productsSection(state);
              }
              if (state is SearchKeyWordError) {
                return Center(
                  child: CustomErrorWidget(onTap: () {
                    fetchAll();
                  }),
                );
              }
              return Container();
            },
          )
        ],
      ).customMargins(),
    );
  }

  @override
  void initState() {
    searchTextController = TextEditingController();
    _selectedCategoriesCubit = SelectedCategoriesCubit(-1);
    _selectedCategoriesCubit.save(0);
    // _brandsCubit.getBrands();

    _searchKeyWordCubit = SearchKeyWordCubit();
    //   ..searchTheKeyWord("", pageNumber);
    _productScrollController.addListener(() {
      if (_productScrollController.position.pixels ==
          _productScrollController.position.maxScrollExtent) {
        // fetchAll();
        _searchKeyWordCubit.searchTheKeyWord(
            searchTextController.text, ++pageNumber,
            sortKey: _resultCubit.state.key,
            brands: selectedBrandsCubit.state.join(",").toString(),
            categories: _selectedCategoriesCubit.state.toString(),
            min: minimumPrice.text,
            max: maximumPrice.text);
      }
    });
    selectedBrandsCubit = SelectedBrandsCubit();
    _resultCubit = SortResultCubit();
    searchFiltersCubit = SearchFiltersCubit();
    searchFiltersCubit.init();
    _resultCubit.init();
    fetchAll();

    super.initState();
  }

  //widget section
  Widget titleAppBar() {
    return Container(
      width: double.infinity,
      height: context.resources.dimension.buttonHeight,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(
              context.resources.dimension.imageBorderRadius)),
      child: TextField(
        expands: true,
        controller: searchTextController,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            alignLabelWithHint: true,
            contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            prefixIcon: IconButton(
                onPressed: () {
                  pageNumber = 1;
                  products.clear();
                  fetchAll();
                },
                icon: const Icon(Icons.search)),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                /* Clear the search field */
                searchTextController.clear();
                pageNumber = 1;
                products.clear();
                fetchAll();
              },
            ),
            hintText: context.resources.strings.search,
            border: InputBorder.none),
        onChanged: (value) {
          if (_debounce?.isActive ?? false) {
            _debounce?.cancel();
          }
          _debounce = Timer(const Duration(milliseconds: 500), () {
            pageNumber = 1;
            products.clear();
            fetchAll();
          });
        },
      ),
    );
  }

  Widget productsSection(state) {
    bool getIsTablet() {
      bool isTablet;
      double ratio = MediaQuery.of(context).size.width /
          MediaQuery.of(context).size.height;
      if ((ratio >= 0.74) && (ratio < 1.5)) {
        isTablet = true;
      } else {
        isTablet = false;
      }

      return isTablet;
    }

    return Column(
      children: [
        GridView.builder(
            itemCount: products.length,
            gridDelegate: getIsTablet()
                ? const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.0,
                  )
                : const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.620),
            // padding: EdgeInsets.all(context.resources.dimension.mediumMargin),
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, int index) {
              return DelayedAnimation(
                  delay: index * 10,
                  fromSide: FromSide.bottom,
                  child: ProductCard(
                      willPop: () {
                        products.clear();
                        fetchAllInitial();
                      },
                      wishListed: products.elementAt(index).wishlisted!,
                      id: products.elementAt(index).id,
                      image: products.elementAt(index).thumbnailImage,
                      name: products.elementAt(index).name,
                      mainPrice: products.elementAt(index).mainPrice,
                      strokedPrice: products.elementAt(index).strokedPrice,
                      hasDiscount: products.elementAt(index).hasDiscount));
            }),
        Expanded(
            flex: 0,
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              color: Colors.grey,
              height: (state is ProductReviewPagination) ? 25 : 0,
              child: Center(
                child: CustomText(
                  content: context.resources.strings.loading,
                  titletype: TitleType.bottoms,
                  language: Language.center,
                ),
              ),
            ))
      ],
    );
  }

  Widget categorySection(List<Filter> state, bool wrap) {
    return Wrap(
      direction: Axis.horizontal,
      children: [
        ...state.map((dynamic filters) {
          Filter filter = filters;
          return Padding(
            padding: EdgeInsets.only(
                right: context.resources.dimension.smallMargin,
                bottom: context.resources.dimension.bigMargin),
            child: categoryInkWall(filter),
          );
        }).toList()
      ],
    );
  }

  Widget productError() {
    return GestureDetector(
        onTap: () {
          HapticFeedback.heavyImpact();
          fetchAll();
        },
        child: CustomText(
          content: context.resources.strings.pleaseReload,
          color: Theme.of(context).colorScheme.redColor,
          titletype: TitleType.subtitle,
        ));
  }

  Widget categoryError() {
    return GestureDetector(
        onTap: () {
          HapticFeedback.heavyImpact();
          fetchAll();
        },
        child: CustomText(
          content: context.resources.strings.pleaseReload,
          color: Theme.of(context).colorScheme.redColor,
          titletype: TitleType.subtitle,
        ));
  }

  Widget categoryInkWall(filter) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {},
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          // boxShadow: [
          //   BoxShadow(
          //     color: Theme.of(context).colorScheme.shadow200,
          //     offset: const Offset(3, 5),
          //     blurRadius: 5,
          //     spreadRadius: 1,
          //   ),
          //   BoxShadow(
          //     color: Theme.of(context).colorScheme.shadow100,
          //     offset: const Offset(-3, 5),
          //     blurRadius: 5,
          //     spreadRadius: 1,
          //   ),
          //   // const BoxShadow(
          //   //   color: Colors.white,
          //   //   offset: Offset(0, -5),
          //   //   blurRadius: 5,
          //   //   spreadRadius: 1,
          //   // ),
          // ],
          borderRadius: BorderRadius.circular(
              context.resources.dimension.circularImageContainer),
          border: Border.all(color: Theme.of(context).colorScheme.lamisColor),
          // gradient: LinearGradient(
          //     colors: Theme.of(context).colorScheme.blueShadeLiner)
        ),
        child: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          child: filter.isDeletable
              ? Chip(
                  deleteIcon: filter.isDeletable
                      ? const Icon(
                          Icons.close,
                          size: 18,
                        )
                      : Container(),
                  onDeleted: () {
                    products.clear();
                    pageNumber = 1;

                    if (filter.key == 1) {
                      searchFiltersCubit.remove(filter);
                      _selectedCategoriesCubit.save(0);
                    } else if (filter.key == 2) {
                      searchFiltersCubit.remove(filter);
                      selectedBrandsCubit.remove(filter.id, brands);
                    } else if (filter.key == 4) {
                      searchFiltersCubit.remove(filter);
                      minimumPrice.text = "";
                      maximumPrice.text = "";
                    } else {
                      searchFiltersCubit.remove(filter);
                      _resultCubit.init();
                    }

                    fetchAll();
                  },
                  backgroundColor: Colors.transparent,
                  label: CustomText(
                    content: filter.name,
                    titletype: TitleType.body,
                  ))
              : Chip(
                  backgroundColor: Colors.transparent,
                  label: CustomText(
                    content: filter.name,
                    titletype: TitleType.body,
                  )),
        ),
      ),
    );
  }
}
