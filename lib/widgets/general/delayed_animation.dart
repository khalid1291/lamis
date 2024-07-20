import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

enum FromSide {
  bottom,
  right,
}

class DelayedAnimation extends StatefulWidget {
  final Widget child;
  final int delay;
  final bool active;
  final FromSide fromSide;

  const DelayedAnimation({
    Key? key,
    required this.child,
    this.delay = 0,
    this.active = true,
    this.fromSide = FromSide.bottom,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DelayedAnimationState createState() => _DelayedAnimationState();
}

class _DelayedAnimationState extends State<DelayedAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();
    Offset offset;
    switch (widget.fromSide) {
      case FromSide.right:
        offset = const Offset(0.35, 0.0);
        break;
      case FromSide.bottom:
        offset = const Offset(0.0, 0.35);
        break;
    }
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    final curve =
        CurvedAnimation(curve: Curves.decelerate, parent: _controller);
    _animOffset = Tween<Offset>(begin: offset, end: Offset.zero).animate(curve);
    if (widget.active) {
      Timer(Duration(milliseconds: widget.delay), () {
        if (_controller != null) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    try {
      if (!_controller.isDismissed) {
        _controller.dispose();
      }
      super.dispose();
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
    );
  }
}
