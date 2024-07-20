import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/res/resources_export.dart';

import 'package:lamis/widgets/widgets.dart';

import '../../cubits/cubits.dart';

class BrandProducts extends StatefulWidget {
  const BrandProducts({Key? key, required this.id, required this.brandName})
      : super(key: key);
  final int id;
  final String brandName;

  @override
  // ignore: library_private_types_in_public_api
  _BrandProductsState createState() => _BrandProductsState();
}

class _BrandProductsState extends State<BrandProducts> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final BrandProductsCubit brandProductsCubit = BrandProductsCubit();
  final List<dynamic> _productList = [];
  Timer? _debounce;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    fetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        brandProductsCubit.getBrandProducts(
            brandId: widget.id, page: ++_page, name: _searchController.text);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  fetchData() async {
    _page = 1;
    brandProductsCubit.getBrandProducts(
        brandId: widget.id, page: _page, name: _searchController.text);
  }

  reset() {
    _productList.clear();
    _page = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        appBar: CustomSearchAppBar(
          onPressed: () {
            if (_searchController.text.isNotEmpty) {
              _productList.clear();
              _searchController.clear();
              fetchData();
            }
          },
          onChanged: (value) {
            if (_debounce?.isActive ?? false) {
              _debounce?.cancel();
            }
            _debounce = Timer(const Duration(milliseconds: 500), () {
              _productList.clear();
              fetchData();
            });
          },
          searchController: _searchController,
        ),
        body: ListView(
          children: [
            BlocBuilder(
              bloc: brandProductsCubit,
              builder: (context, state) {
                if (state is BrandProductLoading) {
                  return const ProductCartShimmer();
                } else if (state is BrandProductDone ||
                    state is BrandProductPagination) {
                  if (state is BrandProductDone) {
                    _productList.addAll(state.response.products);
                  }
                  if (_productList.isEmpty) {
                    return const NoDataFound();
                  }
                  return buildProductList(state);
                } else {
                  return brandProductError();
                }
              },
            ),
          ],
        ));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.lamisColor,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).colorScheme.colorForBubbles),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: titleAppBar(),
      elevation: context.resources.dimension.zeroElevation,
      titleSpacing: 0,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search,
              color: Theme.of(context).colorScheme.colorForBubbles),
          onPressed: () {
            reset();
            brandProductsCubit.getBrandProducts(
                brandId: widget.id, page: _page, name: _searchController.text);
          },
        ),
      ],
    );
  }

  brandProductError() {
    return CustomErrorWidget(onTap: () {
      brandProductsCubit.getBrandProducts(
          brandId: widget.id, page: _page, name: _searchController.text);
    });
  }

  buildProductList(state) {
    return Column(
      children: [
        GridView.builder(
            itemCount: _productList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.620),
            padding: EdgeInsets.all(context.resources.dimension.mediumMargin),
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, int index) {
              return DelayedAnimation(
                  delay: index * 10,
                  fromSide: FromSide.bottom,
                  child: ProductCard(
                      willPop: () {
                        fetchData();
                      },
                      wishListed:
                          _productList.elementAt(index).wishlisted ?? false,
                      id: _productList.elementAt(index).id,
                      image: _productList.elementAt(index).thumbnailImage,
                      name: _productList.elementAt(index).name,
                      mainPrice: _productList.elementAt(index).mainPrice,
                      strokedPrice: _productList.elementAt(index).strokedPrice,
                      hasDiscount: _productList.elementAt(index).hasDiscount));
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

  Widget titleAppBar() {
    return Container(
      width: double.infinity,
      height: context.resources.dimension.buttonHeight,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(
              context.resources.dimension.imageBorderRadius)),
      child: Center(
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
              prefixIcon: IconButton(
                  onPressed: () {
                    _productList.clear();
                    fetchData();
                  },
                  icon: const Icon(Icons.search)),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  /* Clear the search field */
                  _searchController.clear();
                  fetchData();
                },
              ),
              hintText: context.resources.strings.search,
              border: InputBorder.none),
          onChanged: (value) {
            if (_debounce?.isActive ?? false) {
              _debounce?.cancel();
            }
            _debounce = Timer(const Duration(milliseconds: 500), () {
              _productList.clear();
              fetchData();
            });
          },
        ),
      ),
    );
  }
}
