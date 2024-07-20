import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:lamis/res/app_context_extension.dart';
import 'package:lamis/res/colors/app_colors.dart';

import '../../screens/home/home_screen.dart';
import '../../screens/products/products_screen.dart';
import '../custom_text.dart';

class FlashDealWidget extends StatelessWidget {
  const FlashDealWidget({
    Key? key,
    required List<CountdownTimerController> timerControllerList,
    required this.index,
    this.response,
    required this.willPop,
  })  : _timerControllerList = timerControllerList,
        super(key: key);

  final List<CountdownTimerController> _timerControllerList;
  final int index;
  final dynamic response;
  final Function willPop;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: GestureDetector(
        onTap: () async {
          HapticFeedback.heavyImpact();
          var res = await Navigator.push(context,
              MaterialPageRoute(builder: (context) {
            return ProductsScreen(
              title: response.flashDeals[index].title,
              id: response.flashDeals[index].id,
              flashDeal: true,
            );
          }));

          if (res) {
            willPop();
          }
        },
        child: Container(
          margin: EdgeInsets.only(
              top: context.resources.dimension.bigMargin,
              bottom: context.resources.dimension.bigMargin),
          height: 140,
          width: MediaQuery.of(context).size.width - 40,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    // Theme.of(context).colorScheme.mainGradientFirst,
                    // Theme.of(context).colorScheme.mainGradientSecond,
                    Theme.of(context).colorScheme.redColor,
                    Theme.of(context).colorScheme.redColor.withOpacity(0.4),
                    Theme.of(context).colorScheme.redColor.withOpacity(1),
                  ])),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: CountdownTimer(
              controller: _timerControllerList[index],
              widgetBuilder: (_, CurrentRemainingTime? time) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        color: Colors.transparent,
                        // elevation: 0.0,
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            // width: 165,
                            // height: 140,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Stack(
                                children: [
                                  CachedNetworkImage(
                                      width: 170,
                                      height: 160,
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          response.flashDeals[index].banner,
                                      fadeOutDuration:
                                          const Duration(seconds: 1),
                                      fadeInDuration:
                                          const Duration(seconds: 1),
                                      errorWidget: (context, url, error) =>
                                          Image(
                                            image: AssetImage(
                                              context
                                                  .resources.images.noProduct,
                                            ),
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          )),
                                ],
                              ),
                            )),
                      ),
                      Center(
                        child: Container(
                          // height: 100,
                          padding: const EdgeInsets.all(10.0),
                          child: Stack(
                            children: [
                              // Positioned(
                              //   // child: ImageIcon(
                              //   //   AssetImage(
                              //   //       context.resources.images.flashImage),
                              //   //   size: 140,
                              //   //   color: Theme.of(context)
                              //   //       .colorScheme
                              //   //       .yellowColor
                              //   //       .withOpacity(1),
                              //   // ),
                              //   child: Image.asset(
                              //     context.resources.images.flashImage,
                              //     height: 150,
                              //     width: 80,
                              //   ),
                              // ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,

                                        // height: 70,
                                        child: CustomText(
                                          content:
                                              response.flashDeals[index].title,
                                          color: Colors.white,
                                          titletype: TitleType.subtitle,
                                          language: Language.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const FixedHieght(),
                                  SizedBox(
                                    width: 103,
                                    child: Center(
                                        child: time == null
                                            ? Text(
                                                "end",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .scaffoldColor,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            : BuildTimerRowRow(
                                                time: time,
                                              )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

///op2
// Colors.white,
// Theme.of(context).colorScheme.mainGradientFirst,
// Theme.of(context).colorScheme.redColor,
// Theme.of(context).colorScheme.mainGradientFirst,
// Colors.white,
// Theme.of(context).colorScheme.mainGradientFirst,
// Theme.of(context).colorScheme.mainGradientSecond,
