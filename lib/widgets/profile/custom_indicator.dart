import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration buildInputDecoration_1({hintText = ""}) {
    return InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey.shade400),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400, width: 0.5),
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0));
  }

  static InputDecoration buildInputDecorationPhone({hintText = ""}) {
    return InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey.shade400),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400, width: 0.5),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(5.0),
              bottomRight: Radius.circular(5.0)),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(5.0),
                bottomRight: Radius.circular(5.0))),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0));
  }
}
