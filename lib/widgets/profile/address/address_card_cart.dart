import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lamis/cubits/cubits.dart';
import 'package:lamis/screens/cart/addresses_options_screen.dart';

import '../../../../models/models.dart';
import '../../../../res/resources_export.dart';
import '../../../../widgets/widgets.dart';

class AddressCard extends StatefulWidget {
  const AddressCard(
      {Key? key,
      required this.address,
      this.selected = false,
      this.small = false,
      required this.willPop,
      required this.mapTapped})
      : super(key: key);

  final Address address;
  final bool selected;
  final bool small;
  final Function willPop;
  final Function mapTapped;
  @override
  State<AddressCard> createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 250,
        width: 240,
        margin: EdgeInsets.symmetric(
            vertical: context.resources.dimension.mediumMargin),
        padding: EdgeInsets.symmetric(
            vertical: context.resources.dimension.mediumMargin),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(context.resources.dimension.mediumMargin),
            ),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).colorScheme.shadow400,
                  offset: const Offset(4, 4),
                  blurRadius: 5,
                  spreadRadius: 1),
              BoxShadow(
                  color: Theme.of(context).colorScheme.shadow200,
                  offset: const Offset(3, 3),
                  blurRadius: 5,
                  spreadRadius: 1),
              BoxShadow(
                  color: Theme.of(context).colorScheme.shadow200,
                  offset: const Offset(-3, -3),
                  blurRadius: 5,
                  spreadRadius: 1),
              BoxShadow(
                  color: Theme.of(context).colorScheme.shadow100,
                  offset: const Offset(-4, -4),
                  blurRadius: 5,
                  spreadRadius: 1),
            ],
            color: Theme.of(context).colorScheme.scaffoldColor),
        child: Container(
          padding: EdgeInsets.all(context.resources.dimension.verySmallMargin),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    right: widget.small ? 0.0 : 5,
                    left: widget.small ? 0.0 : 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: context.resources.dimension.bigMargin,
                      width: 200,
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              content:
                                  "${context.resources.strings.addressTitle} :",
                              titletype: TitleType.bottoms,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryTextColor,
                              language:
                                  context.read<LocalizationCubit>().state ==
                                          const Locale('ar', '')
                                      ? Language.rtl
                                      : Language.ltr,
                            ),
                          ),
                          Expanded(
                            child: CustomText(
                              content: widget.address.address ?? '',
                              titletype: TitleType.bottoms,
                              color: Theme.of(context).colorScheme.subText,
                              language:
                                  context.read<LocalizationCubit>().state ==
                                          const Locale('ar', '')
                                      ? Language.rtl
                                      : Language.ltr,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: context.resources.dimension.bigMargin,
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomText(
                              content: "${context.resources.strings.zipCode} :",
                              titletype: TitleType.bottoms,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryTextColor,
                              language:
                                  context.read<LocalizationCubit>().state ==
                                          const Locale('ar', '')
                                      ? Language.rtl
                                      : Language.ltr,
                            ),
                          ),
                          Expanded(
                            child: CustomText(
                              content: widget.address.postalCode ?? '',
                              titletype: TitleType.bottoms,
                              color: Theme.of(context).colorScheme.subText,
                              language:
                                  context.read<LocalizationCubit>().state ==
                                          const Locale('ar', '')
                                      ? Language.rtl
                                      : Language.ltr,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: context.resources.dimension.bigMargin,
                      width: 200,
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              content: "${context.resources.strings.city} :",
                              titletype: TitleType.bottoms,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryTextColor,
                              language:
                                  context.read<LocalizationCubit>().state ==
                                          const Locale('ar', '')
                                      ? Language.rtl
                                      : Language.ltr,
                            ),
                          ),
                          Expanded(
                            child: CustomText(
                              content: widget.address.cityName ?? '',
                              titletype: TitleType.bottoms,
                              color: Theme.of(context).colorScheme.subText,
                              language:
                                  context.read<LocalizationCubit>().state ==
                                          const Locale('ar', '')
                                      ? Language.rtl
                                      : Language.ltr,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: context.resources.dimension.bigMargin,
                      width: 200,
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              content: "${context.resources.strings.state} :",
                              titletype: TitleType.bottoms,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryTextColor,
                              language:
                                  context.read<LocalizationCubit>().state ==
                                          const Locale('ar', '')
                                      ? Language.rtl
                                      : Language.ltr,
                            ),
                          ),
                          Expanded(
                            child: CustomText(
                              content: widget.address.stateName ?? '',
                              titletype: TitleType.bottoms,
                              color: Theme.of(context).colorScheme.subText,
                              language:
                                  context.read<LocalizationCubit>().state ==
                                          const Locale('ar', '')
                                      ? Language.rtl
                                      : Language.ltr,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: context.resources.dimension.bigMargin,
                      width: 200,
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              content: "${context.resources.strings.country} :",
                              titletype: TitleType.bottoms,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryTextColor,
                              language:
                                  context.read<LocalizationCubit>().state ==
                                          const Locale('ar', '')
                                      ? Language.rtl
                                      : Language.ltr,
                            ),
                          ),
                          Expanded(
                            child: CustomText(
                              content: widget.address.countryName ?? '',
                              titletype: TitleType.bottoms,
                              color: Theme.of(context).colorScheme.subText,
                              language:
                                  context.read<LocalizationCubit>().state ==
                                          const Locale('ar', '')
                                      ? Language.rtl
                                      : Language.ltr,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: context.resources.dimension.bigMargin,
                      width: 200,
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              content:
                                  "${context.resources.strings.phoneNumber} :",
                              titletype: TitleType.bottoms,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryTextColor,
                              language:
                                  context.read<LocalizationCubit>().state ==
                                          const Locale('ar', '')
                                      ? Language.rtl
                                      : Language.ltr,
                            ),
                          ),
                          Expanded(
                            child: CustomText(
                              content: widget.address.phone ?? '',
                              titletype: TitleType.body,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryTextColor,
                              language:
                                  context.read<LocalizationCubit>().state ==
                                          const Locale('ar', '')
                                      ? Language.rtl
                                      : Language.ltr,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      HapticFeedback.heavyImpact();
                      var res = await BottomSheets.showModal(context,
                          type: BottomSheetType.small,
                          hasBorderMargin: true,
                          child: AddressesOptionsScreen(
                            address: widget.address,
                          ));
                      if (res) {
                        widget.willPop();
                      }
                    },
                    child: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).colorScheme.lamisColor,
                    ),
                  ),
                  Column(
                    children: [
                      GestureDetector(
                          onTap: () async {
                            widget.mapTapped();
                          },
                          child: Icon(
                            Icons.add_location,
                            color: Theme.of(context).colorScheme.lamisColor,
                          )),
                      NeumorphismContainer(
                        active: widget.selected,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.check,
                            color: widget.selected
                                ? Theme.of(context).colorScheme.lamisColor
                                : Theme.of(context).colorScheme.scaffoldColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
