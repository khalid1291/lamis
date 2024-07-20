import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../res/resources_export.dart';
import '../../widgets/widgets.dart';
import '../home/home_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen(
      {Key? key, required this.id, this.flashDeal = false, this.title = ""})
      : super(key: key);

  final int id;
  final String title;
  final bool flashDeal;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  ProductsBloc productsBloc = ProductsBloc();
  final ScrollController _featuredProductScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.flashDeal) {
      productsBloc.add(FetchFlashDealProducts(
        id: widget.id,
      ));
    } else {
      productsBloc.add(FetchCategoryProducts(id: widget.id, name: ""));
    }
  }

  Future<bool> _willPopCallback() async {
    Navigator.of(context).pop(true);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        appBar: CustomAppBar(
          title: widget.title,
          rightIcon: widget.flashDeal ? false : true,
          iconData: Icons.home_outlined,
        ),
        body: ListView(
          children: [
            const FixedHieght(),
            BlocBuilder<ProductsBloc, ProductsState>(
              bloc: productsBloc,
              builder: (context, state) {
                if (state is ProductsLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.lamisColor,
                    ),
                  );
                }
                if (state is CategoryProductsDone) {
                  if (state.value.products.isEmpty) {
                    return SizedBox(
                      height: context.resources.dimension.largeContainerSize,
                      width: double.infinity,
                      child: Image(
                        image: AssetImage(
                          context.resources.images.offlineImage,
                        ),
                        fit: BoxFit.fitWidth,
                      ),
                    );
                  } else {
                    return GridView.builder(
                        // 2
                        //addAutomaticKeepAlives: true,
                        itemCount: state.value.products.length,
                        controller: _featuredProductScrollController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.618),
                        padding: EdgeInsets.all(
                            context.resources.dimension.mediumMargin),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          // 3

                          return ProductCard(
                              willPop: () {
                                if (widget.flashDeal) {
                                  productsBloc.add(FetchFlashDealProducts(
                                    id: widget.id,
                                  ));
                                } else {
                                  productsBloc.add(FetchCategoryProducts(
                                      id: widget.id, name: ""));
                                }
                              },
                              wishListed:
                                  state.value.products[index].wishlisted!,
                              id: state.value.products[index].id,
                              image: state.value.products[index].thumbnailImage,
                              name: state.value.products[index].name,
                              mainPrice: state.value.products[index].mainPrice,
                              strokedPrice:
                                  state.value.products[index].strokedPrice,
                              hasDiscount:
                                  state.value.products[index].hasDiscount);
                        });
                  }
                }
                if (state is CategoriesError) {
                  return CustomErrorWidget(
                    onTap: () {
                      if (widget.flashDeal) {
                        productsBloc.add(FetchFlashDealProducts(
                          id: widget.id,
                        ));
                      } else {
                        productsBloc.add(
                            FetchCategoryProducts(id: widget.id, name: ""));
                      }
                    },
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
