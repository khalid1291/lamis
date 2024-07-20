import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/cubits/cubits.dart';
import 'package:lamis/main.dart';
import 'package:lamis/res/resources_export.dart';

import '../widgets.dart';

class CustomDropDown extends StatelessWidget {
  final List<DropDownValueModel> list;
  final Function(dynamic) onChange;
  final dynamic val;
  final bool isAddress;
  final bool clearOption;
  final bool selected;
  final bool shadow;
  final bool search;
  final String placeHolder;
  final SingleValueDropDownController? singleValueDropDownController;

  const CustomDropDown(
      {Key? key,
      required this.list,
      required this.onChange,
      this.val,
      this.clearOption = true,
      this.shadow = false,
      this.isAddress = false,
      this.singleValueDropDownController,
      this.selected = true,
      this.placeHolder = "",
      this.search = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: context.resources.dimension.buttonBorderRadius,
          right: context.resources.dimension.mediumMargin,
          left: context.resources.dimension.mediumMargin),
      child: Container(
          height: context.resources.dimension.textFieldHeight,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  context.resources.dimension.mediumMargin),
              // boxShadow: shadow
              //     ? [
              //         BoxShadow(
              //             color: Theme.of(context).colorScheme.shadow400,
              //             offset: const Offset(4, 4),
              //             blurRadius: 10,
              //             spreadRadius: 1),
              //         BoxShadow(
              //             color: Theme.of(context).colorScheme.shadow400,
              //             offset: const Offset(3, 3),
              //             blurRadius: 10,
              //             spreadRadius: 1),
              //         BoxShadow(
              //             color: Theme.of(context).colorScheme.shadow100,
              //             offset: const Offset(-4, -4),
              //             blurRadius: 15,
              //             spreadRadius: 1),
              //       ]
              //     : [],
              // gradient: LinearGradient(
              //     colors: Theme.of(context).colorScheme.blueShadeLiner,
              //     begin: Alignment.bottomLeft,
              //     end: Alignment.centerRight)
              border:
                  Border.all(color: Theme.of(context).colorScheme.lamisColor)),
          padding: EdgeInsets.symmetric(
              horizontal: context.resources.dimension.mediumMargin),
          child: Stack(
            children: [
              DropDownTextField(
                singleController: singleValueDropDownController,
                clearOption: clearOption,
                initialValue: val,
                textStyle:
                    TextStyle(color: Theme.of(context).colorScheme.lamisColor),
                textFieldDecoration: InputDecoration(
                        hintText: "",
                        hintStyle: TextStyle(
                            fontSize: 12.0,
                            color: Theme.of(context).colorScheme.lamisColor),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 1.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                                context.resources.dimension.lightElevation),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 1.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                                context.resources.dimension.lightElevation),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal:
                                context.resources.dimension.smallMargin))
                    .copyWith(
                        iconColor: Theme.of(context).colorScheme.lamisColor),
                padding: EdgeInsets.symmetric(
                    horizontal: context.resources.dimension.mediumMargin),
                dropDownList: list,
                enableSearch: search,
                onChanged: (val) {
                  onChange(val);
                },
              ),
              if (selected)
                Align(
                  alignment: MyApp.context.read<LocalizationCubit>().state ==
                          const Locale('ar', '')
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: CustomText(
                    content: placeHolder,
                    titletype: TitleType.bottoms,
                    color: Theme.of(context).colorScheme.subText,
                  ),
                )
            ],
          )),
    );
  }
}
