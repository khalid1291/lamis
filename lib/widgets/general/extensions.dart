import 'package:flutter/material.dart';

extension ExtendedWidget on Widget {
  Widget customMargins({
    bool allowLeftOverlap = false,
    bool allowRightOverlap = false,
  }) {
    return Container(
      margin: EdgeInsets.only(
        left: allowLeftOverlap ? 0 : 20,
        right: allowRightOverlap ? 0 : 20,
      ),
      child: this,
    );
  }

  Widget tabsMargins({
    bool allowLeftOverlap = false,
    bool allowRightOverlap = false,
  }) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80.0),
      child: Container(
        margin: EdgeInsets.only(
          left: allowLeftOverlap ? 0 : 0,
          right: allowRightOverlap ? 0 : 20,
        ),
        child: this,
      ),
    );
  }

  Widget testBanner() {
    return Banner(
      message: 'Temp',
      location: BannerLocation.topEnd,
      color: Colors.red,
      child: this,
    );
  }
}
