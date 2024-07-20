import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:lamis/res/colors/app_colors.dart';
import 'package:lamis/widgets/widgets.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {Key? key,
      required this.title,
      this.rightIcon = false,
      this.activeTransparent = false,
      this.iconData,
      this.isFirst = false})
      : super(key: key);
  final String title;
  final bool? rightIcon;
  final IconData? iconData;
  final bool isFirst;
  final bool activeTransparent;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      iconTheme: IconThemeData(
        size: 15,
        color: Theme.of(context).colorScheme.lamisColor,
      ),
      leading: isFirst
          ? Container()
          : Padding(
              padding: const EdgeInsets.all(10.0),
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
                  Navigator.of(context).maybePop(true);
                },
              )),
            ),
      actions: [
        rightIcon!
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: NeumorphismContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          iconData,
                          size: 23,
                          color: Theme.of(context).colorScheme.lamisColor,
                        ),
                      ),
                    )),
              )
            : Container()
      ],
      title: title.isEmpty
          ? Container()
          : SizedBox(
              width: MediaQuery.of(context).size.width / 1.8,
              child: CustomText(
                maxlines: 1,
                content: title,
                titletype: TitleType.subtitle,
                language: Language.center,
                color: Theme.of(context).colorScheme.lightBlue,
                minTextSize: 6,
              ),
            ),
      backgroundColor: activeTransparent
          ? Colors.transparent
          : Theme.of(context).colorScheme.scaffoldColor,
      // backgroundColor: Theme.of(context).colorScheme.scaffoldColor,

      shadowColor: Colors.transparent,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
