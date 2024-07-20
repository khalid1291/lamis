import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/cubits/cubits.dart';
import 'package:lamis/main.dart';
import '../../res/resources_export.dart';

import '../custom_text.dart';

class ToastBody extends StatelessWidget {
  const ToastBody(
      {Key? key,
      required this.text,
      required this.bgColor,
      this.icon = Icons.error,
      this.textColor,
      this.iconColor})
      : super(key: key);

  final IconData icon;
  final Color bgColor;
  final String text;
  final Color? textColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0), color: bgColor),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: CustomText(
              content: text,
              color: textColor,
              titletype: TitleType.bottoms,
              language: MyApp.context.read<LocalizationCubit>().state ==
                      const Locale('ar', '')
                  ? Language.rtl
                  : Language.ltr,
            ),
          ),
          const SizedBox(
            width: 12.0,
          ),
          Icon(
            icon,
            color: iconColor ?? Theme.of(context).colorScheme.primaryTextColor,
          ),
        ],
      ),
    );
  }
}
