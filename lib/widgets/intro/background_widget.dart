import 'dart:math';

import 'package:flutter/material.dart';

import 'package:lamis/res/resources_export.dart';
import 'package:lamis/widgets/general/custom_appbar.dart';

class BackgroundWidget extends StatefulWidget {
  const BackgroundWidget(
      {Key? key,
      required this.children,
      required this.title,
      this.isFirst = false})
      : super(key: key);

  final Widget children;
  final String title;
  final bool isFirst;

  @override
  State<BackgroundWidget> createState() => _BackgroundWidgetState();
}

class _BackgroundWidgetState extends State<BackgroundWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // late List<Bubble> bubbles;
  // final int numberOfBubbles = 90;
  // final double maxBubbleSize = 40.0;
  // final Color color = Theme.of(MyApp.context).colorScheme.colorForBubbles;
  // const Color(0xFFE7EDF0);
  bool start = false;

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  void initState() {
    // bubbles = [];
    // int i = numberOfBubbles;
    // while (i > 0) {
    //   bubbles.add(Bubble(color, maxBubbleSize));
    //   i--;
    // }

    // Init animation controller
    // _controller = AnimationController(
    //     duration: const Duration(seconds: 2000), vsync: this);
    // _controller.addListener(() {
    //   updateBubblePosition();
    // });
    // _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      //widget.title

      appBar: CustomAppBar(
        title: widget.title,
        isFirst: widget.isFirst,
        activeTransparent: true,
      ),
      resizeToAvoidBottomInset: true,

      backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(context.resources.images.introBackGround),
            fit: BoxFit.cover,
          ),
        ),
        child: widget.children /* add child content here */,
      ),

      // Stack(
      //   children: <Widget>[
      //     Container(
      //         height: MediaQuery.of(context).size.height,
      //         width: MediaQuery.of(context).size.width,
      //         decoration: BoxDecoration(
      //             gradient: LinearGradient(
      //           begin: Alignment.topLeft,
      //           end: Alignment.bottomRight,
      //           colors: <Color>[
      //             Theme.of(context).colorScheme.scaffoldColor,
      //             Theme.of(context).colorScheme.scaffoldColor,
      //             Theme.of(context).colorScheme.scaffoldColor,
      //             Theme.of(context).colorScheme.lightBlue.withOpacity(0.8),
      //           ],
      //         ))),
      //     Positioned(
      //       top: -MediaQuery.of(context).size.width / 1.7,
      //       left: -15.0,
      //       right: -15.0,
      //       child: Container(
      //           height: MediaQuery.of(context).size.height / 2,
      //           width: MediaQuery.of(context).size.width * 2,
      //           decoration: BoxDecoration(
      //             shape: BoxShape.circle,
      //             gradient: LinearGradient(
      //               begin: Alignment.bottomLeft,
      //               end: Alignment.topRight,
      //               colors: <Color>[
      //                 Theme.of(context).colorScheme.scaffoldColor,
      //                 Theme.of(context).colorScheme.darkBlue,
      //                 Theme.of(context).colorScheme.scaffoldColor,
      //                 Theme.of(context).colorScheme.darkBlue,
      //                 Theme.of(context).colorScheme.scaffoldColor,
      //               ],
      //             ),
      //           )),
      //     ),
      //     Positioned(
      //       top: -MediaQuery.of(context).size.width / 1.7 - 15,
      //       left: 0.0,
      //       right: 0.0,
      //       child: Container(
      //           height: MediaQuery.of(context).size.height / 2,
      //           width: MediaQuery.of(context).size.width * 2,
      //           decoration: BoxDecoration(
      //             shape: BoxShape.circle,
      //             gradient: LinearGradient(
      //               begin: Alignment.topLeft,
      //               end: Alignment.bottomRight,
      //               colors: <Color>[
      //                 Theme.of(context).colorScheme.scaffoldColor,
      //                 Theme.of(context).colorScheme.darkBlue,
      //                 Theme.of(context).colorScheme.darkBlue,
      //               ],
      //             ),
      //           )),
      //     ),
      //
      //     Positioned(
      //       top: MediaQuery.of(context).size.height / 7,
      //       right: MediaQuery.of(context).size.width / 2 -
      //           context.resources.dimension.smallContainerSize / 2,
      //       child: SizedBox(
      //         height: context.resources.dimension.smallContainerSize,
      //         width: context.resources.dimension.smallContainerSize,
      //         child: Image(
      //           image: AssetImage(
      //             context.resources.images.logoImage,
      //           ),
      //           fit: BoxFit.fitWidth,
      //         ),
      //       ),
      //     ),
      //     // BlocBuilder(
      //     //   bloc: context.read<CurrentThemeCubit>(),
      //     //   builder: (context, state) {
      //     //     return Container(
      //     //       height: MediaQuery.of(context).size.height,
      //     //       decoration: BoxDecoration(
      //     //         borderRadius: BorderRadius.only(
      //     //             bottomLeft: Radius.circular(
      //     //                 context.resources.dimension.extraHighElevation),
      //     //             bottomRight: Radius.circular(
      //     //                 context.resources.dimension.extraHighElevation)),
      //     //         // color: Theme.of(context).colorScheme.scaffoldColor,
      //     //       ),
      //     //       child: CustomPaint(
      //     //         foregroundPainter:
      //     //             BubblePainter(bubbles: bubbles, controller: _controller),
      //     //         size: Size(MediaQuery.of(context).size.width,
      //     //             context.resources.dimension.listImageSize),
      //     //         // child: SizedBox(
      //     //         //   width: MediaQuery.of(context).size.width,
      //     //         //   height: context.resources.dimension.listImageSize,
      //     //         // ),
      //     //       ),
      //     //     );
      //     //   },
      //     // ),
      //     // PositionedWidget(
      //     //   getDiameter: getSmallDiameter(context),
      //     //   number: context.resources.dimension.verySmallMargin,
      //     //   showTitle: false,
      //     //   left: null,
      //     //   top: 10,
      //     //   bottom: null,
      //     //   right: controller.value
      //     //   // >
      //     //   //     context.resources.dimension.middleContainerSize / 2
      //     //   // ? controller.value - 50
      //     //   // : controller.value + 50
      //     //   ,
      //     //   styleRefluction: true,
      //     // ),
      //     // PositionedWidget(
      //     //   getDiameter: getBiglDiameter(context),
      //     //   number: context.resources.dimension.verySmallMargin,
      //     //   showTitle: false,
      //     //   left: -getBiglDiameter(context) /
      //     //       context.resources.dimension.verySmallMargin,
      //     //   top: -getBiglDiameter(context) /
      //     //       context.resources.dimension.verySmallMargin,
      //     //   bottom: null,
      //     //   right: null,
      //     //   styleRefluction: true,
      //     // ),
      //     // PositionedWidget(
      //     //   getDiameter: getBiglDiameter(context),
      //     //   number: context.resources.dimension.juniorElevation,
      //     //   showTitle: false,
      //     //   right: context.resources.dimension.mediumMargin,
      //     //   bottom: null,
      //     //   left: null,
      //     //   top: context.resources.dimension.mediumMargin,
      //     //   styleRefluction: true,
      //     // ),
      //     Positioned(
      //         top: MediaQuery.of(context).size.height / 4,
      //         right: 0.0,
      //         left: 0.0,
      //         child: widget.children),
      //   ],
      // ),
    );
  }
  //
  // void updateBubblePosition() {
  //   for (var it in bubbles) {
  //     it.updatePosition();
  //   }
  //   setState(() {});
  // }
}

class BubblePainter extends CustomPainter {
  List<Bubble> bubbles;
  AnimationController controller;

  BubblePainter({required this.bubbles, required this.controller});

  @override
  // ignore: avoid_renaming_method_parameters
  void paint(Canvas canvas, Size canvasSize) {
    for (var it in bubbles) {
      it.draw(canvas, canvasSize);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Bubble {
  Color colour = Colors.white30;
  double direction = 1;
  double speed = 0.0;
  double radius = 0.0;
  double x = 0;
  double y = 0;

  Bubble(Color colour, double maxBubbleSize) {
    this.colour = colour.withOpacity(Random().nextDouble());
    direction = Random().nextDouble() * 360;
    speed = 0.0009;
    radius = Random().nextDouble() * maxBubbleSize;
  }

  draw(Canvas canvas, Size canvasSize) {
    Paint paint = Paint()
      ..color = colour
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    assignRandomPositionIfUninitialized(canvasSize);

    randomlyChangeDirectionIfEdgeReached(canvasSize);

    canvas.drawCircle(Offset(x, y), radius, paint);
  }

  void assignRandomPositionIfUninitialized(Size canvasSize) {
    // ignore:  prefer_conditional_assignment, unnecessary_null_comparison
    if (x == null) {
      x = Random().nextDouble() * canvasSize.width;
    }

    // ignore: unnecessary_null_comparison, prefer_conditional_assignment
    if (y == null) {
      y = Random().nextDouble() * canvasSize.height - 35;
    }
  }

  updatePosition() {
    var a = 180 - (direction + 90);
    direction > 0 && direction < 180
        ? x += speed * sin(direction) / sin(speed)
        : x -= speed * sin(direction) / sin(speed);
    direction > 90 && direction < 270
        ? y += speed * sin(a) / sin(speed)
        : y -= speed * sin(a) / sin(speed);
  }

  randomlyChangeDirectionIfEdgeReached(Size canvasSize) {
    if (x > canvasSize.width || x < 0 || y > canvasSize.height - 42 || y < 0) {
      direction = Random().nextDouble() * 360;
    }
  }
}
