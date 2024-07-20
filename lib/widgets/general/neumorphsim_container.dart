import 'package:flutter/material.dart';
import 'package:lamis/res/resources_export.dart';

/// if needed to change the shape  add boolean variable with default circle
class NeumorphismContainer extends StatelessWidget {
  const NeumorphismContainer({
    Key? key,
    required this.child,
    this.boxShape = BoxShape.circle,
    this.active = true,
    this.blurRadius = 5,
  }) : super(key: key);

  final Widget child;
  final bool active;
  final double blurRadius;
  final BoxShape boxShape;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      decoration: BoxDecoration(
        shape: boxShape,
        color: Theme.of(context).colorScheme.scaffoldColor,
        boxShadow: active
            ? [
                BoxShadow(
                    color: Theme.of(context).colorScheme.shadow400,
                    offset: const Offset(4, 4),
                    blurRadius: blurRadius,
                    spreadRadius: 1),
                BoxShadow(
                    color: Theme.of(context).colorScheme.shadow100,
                    offset: const Offset(-4, -4),
                    blurRadius: 7,
                    spreadRadius: 1),
              ]
            : [],
      ),
      child: child,
    );
  }
}
