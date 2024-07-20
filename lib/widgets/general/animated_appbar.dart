import 'package:animations/animations.dart';
import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/screens/cart/cart_screen.dart';
import 'package:lamis/widgets/widgets.dart';

import '../../cubits/cubits.dart';
import '../../main/search_screen.dart';
import '../../res/resources_export.dart';

class AnimatedAppBar extends StatefulWidget implements PreferredSizeWidget {
  const AnimatedAppBar({Key? key}) : super(key: key);

  @override
  State<AnimatedAppBar> createState() => _AnimatedAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AnimatedAppBarState extends State<AnimatedAppBar> {
  AnimatedAppbarCubit animatedAppbarCubit = AnimatedAppbarCubit(false);

  @override
  void initState() {
    context.read<MainPageCartCubit>().fetchRemoteData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimatedAppbarCubit, bool>(
      bloc: animatedAppbarCubit,
      builder: (context, state) {
        return AppBar(
          elevation: 0,
          key: context.read<UserGuideCubit>().slider,
          backgroundColor: Colors.transparent,
          leading: Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: NeumorphismContainer(
                  child: IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Theme.of(context).colorScheme.lamisColor,
                    ),
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  ),
                ),
              );
            },
          ),
          actions: [
            OpenContainer(
              openBuilder: (BuildContext _, VoidCallback openContainer) {
                return const SearchPage();
              },
              tappable: false,
              transitionDuration: const Duration(seconds: 1),
              closedColor: Colors.transparent,
              closedElevation: 0.0,
              onClosed: (value) async {
                Future.delayed(const Duration(seconds: 1)).then((value) {
                  animatedAppbarCubit.changeState();
                });
              },
              closedBuilder: (BuildContext _, VoidCallback openContainer) {
                return AnimatedContainer(
                  padding: const EdgeInsets.only(right: 0.0),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        BlocConsumer<MainPageCartCubit, MainPageCartState>(
                          bloc: context.read<MainPageCartCubit>(),
                          listener: (context, state) {},
                          builder: (context, state) {
                            if (state is MainPageCartDone) {
                              return context.watch<IsLoggedInCubit>().state
                                  ? NeumorphismContainer(
                                      child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: badge.Badge(
                                        position: badge.BadgePosition.topEnd(
                                          top: -3.0,
                                          end: -3.5,
                                        ),
                                        //
                                        // alignment: Alignment.bottomLeft,
                                        badgeStyle: badge.BadgeStyle(
                                            badgeColor: Theme.of(context)
                                                .colorScheme
                                                .shadow100),
                                        badgeContent: Text(
                                          state.number.toString(),
                                          style: const TextStyle(fontSize: 12),
                                          // style: TextStyle(
                                          //     fontSize: 12 *
                                          //         MediaQuery.of(context)
                                          //             .size
                                          //             .height *
                                          //         0.0013),
                                        ),
                                        child: IconButton(
                                          key: context
                                              .read<UserGuideCubit>()
                                              .searchButton,
                                          icon: Icon(
                                            Icons.shopping_cart_outlined,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .lamisColor,
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
                                    ))
                                  : Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: NeumorphismContainer(
                                          child: IconButton(
                                        icon: Icon(
                                          Icons.shopping_cart_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .lamisColor,
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
                                      )),
                                    );
                            }
                            return Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: NeumorphismContainer(
                                  child: IconButton(
                                icon: Icon(
                                  Icons.shopping_cart_outlined,
                                  color:
                                      Theme.of(context).colorScheme.lamisColor,
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
                              )),
                            );
                          },
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        NeumorphismContainer(
                          child: IconButton(
                              onPressed: () async {
                                HapticFeedback.heavyImpact();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const SearchPage();
                                    },
                                  ),
                                );
                                // animatedAppbarCubit.changeState();
                                // if (animatedAppbarCubit.state) {
                                //   Future.delayed(
                                //           const Duration(milliseconds: 500))
                                //       .then((value) {
                                //     openContainer();
                                //   });
                                // }
                              },
                              icon: Icon(
                                Icons.search,
                                color: Theme.of(context).colorScheme.lamisColor,
                              )),
                        ),
                        AnimatedContainer(
                          color: Theme.of(context).colorScheme.background,
                          width: animatedAppbarCubit.state
                              ? MediaQuery.of(context).size.width * 0.86
                              : 0,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 450),
                        )
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }
}
