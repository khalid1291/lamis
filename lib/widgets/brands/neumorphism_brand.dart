import 'package:flutter/material.dart';
import 'package:lamis/res/colors/app_colors.dart';

/// if needed to change the shape  add boolean variable with default circle
enum NeumorphismType { brands, todayDeal, product, icon, buttons }

class NeumorphismBrands extends StatelessWidget {
  const NeumorphismBrands({
    Key? key,
    required this.child,
    this.neumorphismType = NeumorphismType.brands,
    this.boxShape = BoxShape.rectangle,
    this.blueLiner = false,
    this.active = true,
    this.activeTransparent = false,
    this.blurRadius = 5,
  }) : super(key: key);

  final Widget child;
  final bool active;
  final double blurRadius;
  final BoxShape boxShape;
  final NeumorphismType neumorphismType;
  final bool blueLiner;
  final bool activeTransparent;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.all(neumorphismType == NeumorphismType.icon ? 0 : 8),
      duration: const Duration(milliseconds: 400),
      decoration: BoxDecoration(
          shape: boxShape,
          borderRadius: neumorphismType == NeumorphismType.icon
              ? null
              : BorderRadius.all(Radius.circular(getRaduios())),
          gradient: getLiner(context),
          boxShadow: active ? shadowEffect(context) : []),
      child: child,
    );
  }

  double getRaduios() {
    switch (neumorphismType) {
      case NeumorphismType.brands:
        return 6.38;
      case NeumorphismType.todayDeal:
        return 17;
      case NeumorphismType.product:
        return 26;
      case NeumorphismType.icon:
        return 1;
      case NeumorphismType.buttons:
        return 11;
    }
  }

  List<BoxShadow> shadowEffect(BuildContext context) {
    switch (neumorphismType) {
      case NeumorphismType.brands:
        return [
          BoxShadow(
              color: Theme.of(context).colorScheme.shadow200,
              offset: const Offset(10, 0),
              blurRadius: blurRadius,
              spreadRadius: 1),
          BoxShadow(
              color: Theme.of(context).colorScheme.shadow200,
              offset: const Offset(10, 10),
              blurRadius: blurRadius,
              spreadRadius: 1),
          // BoxShadow(
          //     color: Colors.white,
          //     offset: const Offset(-10, -10),
          //     blurRadius: blurRadius,
          //     spreadRadius: 1),
          BoxShadow(
              color: Theme.of(context).colorScheme.shadow200,
              offset: const Offset(10, -10),
              blurRadius: blurRadius,
              spreadRadius: 1),
        ];
      case NeumorphismType.todayDeal:
        return [
          BoxShadow(
              color: Theme.of(context).colorScheme.shadow200,
              offset: const Offset(10, 10),
              blurRadius: blurRadius,
              spreadRadius: 1),
          // BoxShadow(
          //     color: Colors.white,
          //     offset: const Offset(-10, -10),
          //     blurRadius: blurRadius,
          //     spreadRadius: 1),
        ];
      case NeumorphismType.product:
        return [
          BoxShadow(
              color: Theme.of(context).colorScheme.shadow200,
              offset: const Offset(0, 2),
              blurRadius: 1,
              spreadRadius: 1),
          BoxShadow(
              color: Theme.of(context).colorScheme.homeScreen,
              offset: const Offset(0, -12),
              blurRadius: blurRadius,
              spreadRadius: 1),
        ];
      case NeumorphismType.icon:
        return [];
      case NeumorphismType.buttons:
        return [
          BoxShadow(
              color: Theme.of(context).colorScheme.shadow200,
              offset: const Offset(10, 10),
              blurRadius: blurRadius,
              spreadRadius: 1),
          BoxShadow(
              color: Theme.of(context).colorScheme.shadow200,
              offset: const Offset(10, -5),
              blurRadius: blurRadius,
              spreadRadius: 1),
          // BoxShadow(
          //     color: Colors.white,
          //     offset: const Offset(-10, 0),
          //     blurRadius: blurRadius,
          //     spreadRadius: 1),
        ];
    }
  }

  LinearGradient getLiner(BuildContext context) {
    if (neumorphismType == NeumorphismType.icon) {
      return blueLiner
          ? LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: activeTransparent
                  ? [Colors.transparent, Colors.transparent]
                  : Theme.of(context).colorScheme.blueShadeLiner)
          : LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: activeTransparent
                  ? [Colors.transparent, Colors.transparent]
                  : Theme.of(context).colorScheme.grayShadeLiner);
    } else {
      return blueLiner
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
              colors: activeTransparent
                  ? [Colors.transparent, Colors.transparent]
                  : Theme.of(context).colorScheme.blueShadeLiner)
          : LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
              colors: activeTransparent
                  ? [Colors.transparent, Colors.transparent]
                  : Theme.of(context).colorScheme.grayShadeLiner);
    }
  }
}
