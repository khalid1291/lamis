import 'package:flutter/material.dart';
import 'package:lamis/res/resources_export.dart';

class BackgroundLeave extends StatelessWidget {
  final Widget child;
  const BackgroundLeave({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              top: 30,
              left: 0,
              child: Container(
                height: 140,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Theme.of(context).colorScheme.mainGradientFirst,
                          Theme.of(context).colorScheme.mainGradientSecond,
                          Theme.of(context).colorScheme.mainGradientFirst,
                          Theme.of(context).colorScheme.mainGradientSecond,
                        ])),
              ),
            ),
            // Positioned(
            //   top: 30,
            //   right: 40,
            //   child: Container(
            //     height: 140,
            //     width: 140,
            //     decoration: BoxDecoration(
            //         borderRadius: const BorderRadius.all(Radius.circular(25)),
            //         gradient: LinearGradient(
            //             begin: Alignment.topRight,
            //             end: Alignment.bottomLeft,
            //             colors: [
            //               Theme.of(context).colorScheme.mainGradientFirst,
            //               Theme.of(context).colorScheme.mainGradientSecond,
            //             ])),
            //   ),
            // ),
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(
                      context.resources.dimension.extraHighElevation),
                  bottomLeft: Radius.circular(
                      context.resources.dimension.extraHighElevation),
                ),
                //  color: Theme.of(context).colorScheme.lamisColor.withOpacity(0.4),
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
