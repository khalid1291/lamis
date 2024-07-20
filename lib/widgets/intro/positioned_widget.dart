import 'package:flutter/material.dart';
import '../../res/resources_export.dart';

class PositionedWidget extends StatelessWidget {
  const PositionedWidget(
      {Key? key,
      required this.getDiameter,
      required this.number,
      required this.showTitle,
      required this.right,
      required this.top,
      required this.left,
      required this.bottom,
      this.styleRefluction = true})
      : super(key: key);
  final double? getDiameter;
  final double? number;
  final bool showTitle;
  final double? right;
  final double? top;
  final double? left;
  final double? bottom;
  final bool styleRefluction;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: right,
      top: top,
      left: left,
      bottom: bottom,
      child: Container(
          width: getDiameter,
          height: getDiameter,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.lamisColor.withOpacity(0.5),
                    Theme.of(context).colorScheme.colorForBubbles
                  ],
                  begin: styleRefluction
                      ? Alignment.topCenter
                      : Alignment.bottomCenter,
                  end: styleRefluction
                      ? Alignment.bottomCenter
                      : Alignment.topCenter)),
          child: showTitle
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "    Lamis   ",
                      style: TextStyle(
                          fontFamily: "Pacifico",
                          fontSize: 40,
                          color: Colors.white),
                    ),
                  ),
                )
              : Container()),
    );
  }
}
