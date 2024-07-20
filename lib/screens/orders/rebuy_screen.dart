import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/models/models.dart';

import '../../blocs/blocs.dart';
import '../../res/resources_export.dart';
import '../../widgets/widgets.dart';
import '../home/home_screen.dart';

class RebuyScreen extends StatefulWidget {
  const RebuyScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<RebuyScreen> createState() => _RebuyScreenState();
}

class _RebuyScreenState extends State<RebuyScreen> {
  ProductsBloc productsBloc = ProductsBloc();
  final ScrollController _productScrollController = ScrollController();

  @override
  void initState() {
    productsBloc.add(FetchBuyAgainProducts(page: 1));
    _productScrollController.addListener(() {
      if (_productScrollController.offset ==
          _productScrollController.position.maxScrollExtent) {
        productsBloc.add(FetchBuyAgainProducts(page: ++page));
      }
    });
    super.initState();
  }

  Future<bool> _willPopCallback() async {
    Navigator.of(context).pop(true);
    return Future.value(true);
  }

  int page = 1;
  Set<MiniProduct> products = {};

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        appBar: CustomAppBar(
          title: context.resources.strings.myProducts,
          rightIcon: false,
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
                  products.addAll(state.value.products);
                  if (products.isEmpty) {
                    return SizedBox(
                      height: context.resources.dimension.largeContainerSize,
                      width: double.infinity,
                      child: Image(
                        image: AssetImage(
                          context.resources.images.noDataImage,
                        ),
                        fit: BoxFit.fitWidth,
                      ),
                    );
                  } else {
                    return GridView.builder(
                        // 2
                        //addAutomaticKeepAlives: true,
                        itemCount: products.length,
                        controller: _productScrollController,
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
                                products.clear();
                                productsBloc
                                    .add(FetchBuyAgainProducts(page: page));
                              },
                              wishListed: products.elementAt(index).wishlisted!,
                              id: products.elementAt(index).id,
                              image: products.elementAt(index).thumbnailImage,
                              name: products.elementAt(index).name,
                              mainPrice: products.elementAt(index).mainPrice,
                              strokedPrice:
                                  products.elementAt(index).strokedPrice,
                              hasDiscount:
                                  products.elementAt(index).hasDiscount);
                        });
                  }
                }
                if (state is CategoriesError) {
                  return CustomErrorWidget(
                    onTap: () {
                      productsBloc.add(FetchBuyAgainProducts(page: page));
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
