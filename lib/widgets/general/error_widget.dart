import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/res/resources_export.dart';
import 'package:lamis/widgets/widgets.dart';

import '../../cubits/main/localization_cubit.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          HapticFeedback.heavyImpact();
          onTap();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CustomText(
                content: context.resources.strings.pleaseReload,
                titletype: TitleType.subtitle,
                color: Theme.of(context).colorScheme.primaryTextColor,
                language: context.read<LocalizationCubit>().state ==
                        const Locale('ar', '')
                    ? Language.rtl
                    : Language.ltr,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            NeumorphismContainer(
              child: Icon(
                Icons.loop,
                color: Theme.of(context).colorScheme.primaryTextColor,
              ),
            ),
          ],
        ));
  }
}
