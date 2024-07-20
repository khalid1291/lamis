import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/cubits/cubits.dart';
import 'package:lamis/screens/home/home_screen.dart';

import '../../blocs/blocs.dart';
import '../../models/models.dart';
import '../../res/resources_export.dart';
import '../../widgets/widgets.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen(
      {Key? key, this.id = 0, this.isSubCategory = false, this.title = ""})
      : super(key: key);

  final int id;
  final bool isSubCategory;
  final String title;
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  CategoriesBloc categoriesBloc = CategoriesBloc();
  ProductsBloc productsBloc = ProductsBloc();
  final ScrollController _featuredProductScrollController = ScrollController();
  String first = "";
  String last = "";
  @override
  void initState() {
    super.initState();
    if (widget.isSubCategory) {
      categoriesBloc.add(FetchSubCategories(id: widget.id));
      productsBloc.add(FetchCategoryProducts(id: widget.id, name: ""));
    } else {
      categoriesBloc.add(FetchCategories(id: widget.id));
    }
  }

  bool getIsTablet() {
    bool isTablet;
    double ratio =
        MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;
    if ((ratio >= 0.74) && (ratio < 1.5)) {
      isTablet = true;
    } else {
      isTablet = false;
    }
    return isTablet;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSubCategory) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        appBar: const CustomAppBar(
          title: "",
          rightIcon: true,
          iconData: Icons.grid_view,
        ),
        body: screenBody(),
      );
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
      body: screenBody(),
    );
  }

  Widget screenBody() {
    if (widget.isSubCategory) {
      return ListView(
        children: [
          Container(
            height: 40,
            padding: EdgeInsets.symmetric(
                horizontal: context.resources.dimension.bigMargin),
            alignment: context.read<LocalizationCubit>().state ==
                    const Locale('ar', '')
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: CustomText(
              content: widget.title,
              titletype: TitleType.subtitle,
              color: Theme.of(context).colorScheme.primaryTextColor,
            ),
          ),
          BlocBuilder<CategoriesBloc, CategoriesState>(
            bloc: categoriesBloc,
            builder: (context, state) {
              if (state is CategoriesLoading) {
                return SizedBox(
                    height: context.resources.dimension.middleContainerSize,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        itemCount: 2,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, index) {
                          return Padding(
                            padding: EdgeInsets.all(
                                context.resources.dimension.defaultMargin),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2.5,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      context.resources.dimension.bigMargin),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .shadow400,
                                        offset: const Offset(4, 4),
                                        blurRadius: 10,
                                        spreadRadius: 1),
                                    BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .shadow400,
                                        offset: const Offset(3, 3),
                                        blurRadius: 10,
                                        spreadRadius: 1),
                                    BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .shadow100,
                                        offset: const Offset(-4, -4),
                                        blurRadius: 15,
                                        spreadRadius: 1),
                                  ]),
                            ),
                          );
                        }));
              }
              if (state is CategoriesDone) {
                if (state.value.categories.isEmpty) {
                  return Container();
                } else {
                  return SizedBox(
                    height: context.resources.dimension.middleContainerSize,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        itemCount: state.value.categories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, index) {
                          return CategoryCard(
                              category: state.value.categories[index],
                              onTap: () {
                                HapticFeedback.heavyImpact();
                                first = widget.title.split("..").first;
                                last = state.value.categories[index].name;
                                String title = "$first..$last";
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return CategoriesScreen(
                                    id: state.value.categories[index].id,
                                    isSubCategory: true,
                                    title: title,
                                  );
                                }));
                              });
                        }),
                  );
                }
              }
              if (state is CategoriesError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: CustomErrorWidget(onTap: () {
                    HapticFeedback.heavyImpact();
                    if (widget.isSubCategory) {
                      categoriesBloc.add(FetchSubCategories(id: widget.id));
                      productsBloc
                          .add(FetchCategoryProducts(id: widget.id, name: ""));
                    } else {
                      categoriesBloc.add(FetchCategories(id: widget.id));
                    }
                  }),
                );
              }
              return Container();
            },
          ),
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
                    height:
                        context.resources.dimension.largeContainerSize * 1.5,
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.center,
                      child: Image(
                        image: AssetImage(
                          context.resources.images.noDataImage,
                        ),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  );
                } else {
                  return GridView.builder(
                      // 2
                      //addAutomaticKeepAlives: true,
                      itemCount: state.value.products.length,
                      controller: _featuredProductScrollController,
                      gridDelegate: getIsTablet()
                          ? const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1.0,
                            )
                          : const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.64),
                      padding: EdgeInsets.all(
                          context.resources.dimension.mediumMargin),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        // 3
                        return DelayedAnimation(
                          delay: index * 150,
                          child: ProductCard(
                              willPop: () {
                                if (widget.isSubCategory) {
                                  categoriesBloc
                                      .add(FetchSubCategories(id: widget.id));
                                  productsBloc.add(FetchCategoryProducts(
                                      id: widget.id, name: ""));
                                } else {
                                  categoriesBloc
                                      .add(FetchCategories(id: widget.id));
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
                                  state.value.products[index].hasDiscount),
                        );
                      });
                }
              }
              if (state is CategoriesError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: CustomErrorWidget(
                    onTap: () {
                      if (widget.isSubCategory) {
                        categoriesBloc.add(FetchSubCategories(id: widget.id));
                        productsBloc.add(
                            FetchCategoryProducts(id: widget.id, name: ""));
                      } else {
                        categoriesBloc.add(FetchCategories(id: widget.id));
                      }
                    },
                  ),
                );
              }
              return Container();
            },
          ),
        ],
      );
    } else {
      return ListView(
        children: [
          Container(
            height: 40,
            padding: EdgeInsets.symmetric(
                horizontal: context.resources.dimension.bigMargin),
            alignment: context.read<LocalizationCubit>().state ==
                    const Locale('ar', '')
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: CustomText(
              content: context.resources.strings.titleCategories,
              titletype: TitleType.subtitle,
              color: Theme.of(context).colorScheme.primaryTextColor,
            ),
          ),
          BlocBuilder<CategoriesBloc, CategoriesState>(
            bloc: categoriesBloc,
            builder: (context, state) {
              if (state is CategoriesLoading) {
                return CategoriesShimmer(
                  isTablet: getIsTablet(),
                );
              }
              if (state is CategoriesDone) {
                if (state.value.categories.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FixedHieght(
                        extra: true,
                      ),
                      SizedBox(
                        height: context.resources.dimension.largeContainerSize *
                            1.5,
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.center,
                          child: Image(
                            image: AssetImage(
                              context.resources.images.noDataImage,
                            ),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  return GridView.builder(
                      itemCount: state.value.categories.length,
                      gridDelegate: getIsTablet()
                          ? const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1.0,
                            )
                          : const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 7.3 / 5,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0),
                      // to disable GridView's scrolling
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return DelayedAnimation(
                          delay: index * 150,
                          child: CategoryCard(
                              category: state.value.categories[index],
                              onTap: () {
                                HapticFeedback.heavyImpact();
                                first = state.value.categories[index].name;
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return CategoriesScreen(
                                    id: state.value.categories[index].id,
                                    isSubCategory: true,
                                    title: first,
                                  );
                                }));
                              }),
                        );
                      }).customMargins();
                }
              }
              if (state is CategoriesError) {
                return CustomErrorWidget(onTap: () {
                  categoriesBloc.add(FetchCategories(id: widget.id));
                });
              }
              return Container();
            },
          ),
        ],
      );
    }
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.onTap,
    required this.category,
  }) : super(key: key);

  final Function onTap;
  final Category category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        onTap();
      },
      child: Padding(
        padding: EdgeInsets.all(context.resources.dimension.defaultMargin),
        child: Container(
          width: MediaQuery.of(context).size.width / 2.5,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius:
                  BorderRadius.circular(context.resources.dimension.bigMargin),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).colorScheme.shadow400,
                    offset: const Offset(4, 4),
                    blurRadius: 10,
                    spreadRadius: 1),
                BoxShadow(
                    color: Theme.of(context).colorScheme.shadow400,
                    offset: const Offset(3, 3),
                    blurRadius: 10,
                    spreadRadius: 1),
                BoxShadow(
                    color: Theme.of(context).colorScheme.shadow100,
                    offset: const Offset(-4, -4),
                    blurRadius: 15,
                    spreadRadius: 1),
              ]),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: CachedNetworkImage(
                    height: context.resources.dimension.middleContainerSize,
                    width: double.infinity,
                    // imageUrl: "https://via.placeholder.com/350x200",
                    imageUrl: category.icon,
                    fit: BoxFit.fitWidth,
                    fadeOutDuration: const Duration(seconds: 1),
                    fadeInDuration: const Duration(seconds: 3),
                    errorWidget: (context, url, error) => Image(
                          image: AssetImage(
                            context.resources.images.noProduct,
                          ),
                          height: 100,
                          width: 100,
                          fit: BoxFit.contain,
                        )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesShimmer extends StatelessWidget {
  const CategoriesShimmer({Key? key, required this.isTablet}) : super(key: key);

  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: 6,
        gridDelegate: isTablet
            ? const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.4,
              )
            : const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 7.3 / 5,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0),
        // to disable GridView's scrolling
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return DelayedAnimation(
            delay: index * 100,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color:
                      Theme.of(context).colorScheme.lamisColor.withOpacity(0.3),
                ),
              ),
            ),
          );
        }).customMargins();
  }
}
