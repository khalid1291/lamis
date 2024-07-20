import 'package:flutter/material.dart';
import 'package:lamis/res/resources_export.dart';

class LeaveContainerWithShadow extends StatelessWidget {
  final Widget widget;
  final double height;
  final Color? bgc;
  const LeaveContainerWithShadow(
      {Key? key, required this.widget, required this.height, this.bgc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.resources.dimension.extraHighElevation),
      child: Container(
        margin: EdgeInsets.all(context.resources.dimension.mediumElevation),
        height: height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(
            bottom: context.resources.dimension.extraHighElevation),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight:
                Radius.circular(context.resources.dimension.extraHighElevation),
            bottomLeft:
                Radius.circular(context.resources.dimension.extraHighElevation),
          ),
          color: bgc ?? Theme.of(context).colorScheme.background,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(2, 7), // changes position of shadow
            ),
          ],
        ),
        child: widget,
      ),
    );
  }
}
