import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lamis/widgets/general/extensions.dart';

import '../../res/resources_export.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      required this.label,
      required this.onChange,
      this.textInputType = TextInputType.text,
      this.limit = 50,
      this.enabled = true,
      this.enableAllReg = true,
      this.titleState = true,
      this.icon,
      this.transparentBackground = false,
      this.controller,
      this.hint,
      this.enableGrayShade = false,
      this.secure = false,
      this.isAddress = false,
      this.isCheckout = false})
      : super(key: key);

  final String label;
  final Function(String) onChange;
  final TextInputType? textInputType;
  final int? limit;
  final bool enabled;
  final Widget? icon;
  final TextEditingController? controller;
  final bool secure;
  final bool titleState;
  final bool isCheckout;
  final bool isAddress;
  final bool transparentBackground;
  final bool enableGrayShade;
  final String? hint;
  final bool enableAllReg;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
          isCheckout ? 0.0 : context.resources.dimension.mediumElevation),
      child: Center(
        child: Container(
          width: isCheckout ? 170 : double.infinity,
          padding: EdgeInsets.symmetric(
              horizontal: context.resources.dimension.lightElevation),
          height: context.resources.dimension.textFieldHeight,
          decoration: BoxDecoration(
              // color:
              //     isCheckout ? Theme.of(context).colorScheme.cardColor : null,
              border:
                  Border.all(color: Theme.of(context).colorScheme.lamisColor),
              // boxShadow:
              // isCheckout || isAddress
              //     ? []
              //     : [
              //         BoxShadow(
              //             color: Theme.of(context).colorScheme.shadow200,
              //             offset: const Offset(10, 10),
              //             blurRadius: 5,
              //             spreadRadius: 1),
              //         BoxShadow(
              //             color: Theme.of(context).colorScheme.shadow200,
              //             offset: const Offset(10, -5),
              //             blurRadius: 5,
              //             spreadRadius: 1),
              //         // const BoxShadow(
              //         //     color: Colors.white,
              //         //     offset: Offset(-10, 0),
              //         //     blurRadius: 5,
              //         //     spreadRadius: 1),
              //       ],
              // gradient: isCheckout
              //     ? null
              //     : LinearGradient(
              //         begin: Alignment.centerLeft,
              //         end: Alignment.centerRight,
              //         colors: transparentBackground
              //             ? [Colors.transparent, Colors.transparent]
              //             : enableGrayShade
              //                 ? Theme.of(context).colorScheme.grayShadeLiner
              //                 : Theme.of(context).colorScheme.blueShadeLiner,
              //       ),
              borderRadius: isCheckout
                  ? BorderRadius.all(
                      Radius.circular(context.resources.dimension.mediumMargin),
                      // bottomLeft: Radius.circular(
                      //     context.resources.dimension.mediumMargin)
                    )
                  : BorderRadius.circular(
                      context.resources.dimension.mediumMargin)),
          child: TextFormField(
            obscureText: secure,
            controller: controller,
            enabled: enabled,
            textAlignVertical: TextAlignVertical.center,
            inputFormatters: enableAllReg
                ? [
                    LengthLimitingTextInputFormatter(limit),
                  ]
                : [
                    LengthLimitingTextInputFormatter(limit),
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
            keyboardType: textInputType,
            onChanged: (value) {
              onChange(value);
            },
            decoration: InputDecoration(
                hintText: !titleState ? hint : null,
                hintStyle: const TextStyle(
                  fontSize: 12,
                ),
                fillColor: Theme.of(context).colorScheme.colorForBubbles,
                prefixIcon: icon,
                prefixIconColor: Theme.of(context).colorScheme.lamisColor,
                // enabledBorder: OutlineInputBorder(
                //   borderSide: BorderSide(
                //       color: Theme.of(context).colorScheme.lamisColor, width: 1),
                // ),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                labelText: enabled && titleState ? label : null,
                labelStyle: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.subText)),
            cursorColor: Theme.of(context).colorScheme.lamisColor,
          ).customMargins(),
        ),
      ),
    );
  }
}
