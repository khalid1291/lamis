import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lamis/res/resources_export.dart';
import 'package:lamis/widgets/custom_text.dart';

import 'neumorphsim_container.dart';

class LamisButtomBar extends StatelessWidget {
  const LamisButtomBar({
    Key? key,
    required this.index,
    required this.onTap,
  }) : super(key: key);

  final int index;

  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: defaultTargetPlatform == TargetPlatform.iOS ? 116 : 81,
      child: BottomNavigationBar(
        unselectedIconTheme: const IconThemeData(color: Color(0xffABABAB)),
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        unselectedLabelStyle: TextStyle(
            color: Theme.of(context).colorScheme.shadowColor.withOpacity(0.5)),
        selectedLabelStyle:
            TextStyle(color: Theme.of(context).colorScheme.lamisColor),
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
            icon: NeumorphismContainer(
              blurRadius: 12,
              active: index == 0,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Icon(Icons.home_outlined, size: index == 0 ? 30 : 18),
                    index == 0
                        ? Container()
                        : CustomText(
                            content: context.resources.strings.homeScreen,
                            titletype: TitleType.time,
                            color: const Color(0xffABABAB),
                          )
                  ],
                ),
              ),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
              icon: NeumorphismContainer(
                active: index == 1,
                blurRadius: 12,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Icon(Icons.category_outlined, size: index == 1 ? 30 : 18),
                      index == 1
                          ? Container()
                          : CustomText(
                              content:
                                  context.resources.strings.titleCategories,
                              titletype: TitleType.time,
                              color: const Color(0xffABABAB),
                            )
                    ],
                  ),
                ),
              ),
              label: ""),
          // BottomNavigationBarItem(
          //     backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
          //     icon: NeumorphismContainer(
          //       active: index == 2,
          //       child: Padding(
          //         padding: const EdgeInsets.all(12.0),
          //         child: Column(
          //           children: [
          //             Icon(Icons.shopping_cart_outlined,
          //                 size: index == 2 ? 35 : 25),
          //             index == 2
          //                 ? Container()
          //                 : CustomText(
          //                     content: context.resources.strings.cart,
          //                     titletype: TitleType.time,
          //                     color:
          //                         Theme.of(context).shadowColor.withOpacity(0.5),
          //                   )
          //           ],
          //         ),
          //       ),
          //     ),
          //     label: ""),
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
              icon: NeumorphismContainer(
                blurRadius: 12,
                active: index == 2,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ImageIcon(
                          AssetImage(
                            context.resources.images.offers,
                          ),
                          size: index == 2 ? 30 : 14),
                      index == 2
                          ? Container()
                          : CustomText(
                              content: context.resources.strings.offers,
                              titletype: TitleType.time,
                              color: const Color(0xffABABAB),
                            )
                    ],
                  ),
                ),
              ),
              label: ""),
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
              icon: NeumorphismContainer(
                blurRadius: 12,
                active: index == 3,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: index == 3 ? 30 : 18,
                      ),
                      index == 3
                          ? Container()
                          : CustomText(
                              content: context.resources.strings.profile,
                              titletype: TitleType.time,
                              color: const Color(0xffABABAB),
                            )
                    ],
                  ),
                ),
              ),
              label: ""),
        ],
        currentIndex: index,
        selectedItemColor: Theme.of(context).colorScheme.lamisColor,
        unselectedItemColor: Theme.of(context).shadowColor.withOpacity(0.5),
        onTap: onTap,
      ),
    );
  }
}
