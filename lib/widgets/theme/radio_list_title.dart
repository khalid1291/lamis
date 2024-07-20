import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/main/themes/theme_cubit.dart';

class RadioListTitleWidget extends StatefulWidget {
  final String name;
  final int value;

  const RadioListTitleWidget(
      {Key? key, required this.name, required this.value})
      : super(key: key);

  @override
  State<RadioListTitleWidget> createState() => _RadioListTitleWidgetState();
}

class _RadioListTitleWidgetState extends State<RadioListTitleWidget> {
  int curr = 0;

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      title: Text(widget.name),
      value: widget.value,
      groupValue: curr,
      onChanged: (int? value) {
        if (value != null) {
          setState(() {
            curr = value;
          });
          context.read<CurrentThemeCubit>().changeTheme(ThemeType.auto);
        }
      },
    );
  }
}
