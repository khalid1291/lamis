import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:lamis/cubits/cubits.dart';
import 'package:lamis/res/resources_export.dart';

// ignore: must_be_immutable
class PhoneTextField extends StatelessWidget {
  PhoneTextField(
      {Key? key,
      required this.textEditingController,
      required this.onInputChanged,
      required this.onInputValidated,
      this.isEnable = true,
      this.countries = const ['JO', 'SY', 'SA', 'IQ']})
      : super(key: key);

  final TextEditingController textEditingController;
  final ValueChanged<PhoneNumber> onInputChanged;
  final ValueChanged<bool> onInputValidated;
  final List<String> countries;
  final bool isEnable;

  String initialCountry = 'JO';
  //PhoneNumber number = PhoneNumber(isoCode: 'JO');

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: context.resources.dimension.smallMargin),
        height: context.resources.dimension.textFieldHeight + 10,
        decoration: BoxDecoration(
            // color: isEnable
            //     ? Theme.of(context).colorScheme.cardColor
            //     : Colors.transparent,
            // boxShadow: [
            //   BoxShadow(
            //       color: Theme.of(context).colorScheme.shadow200,
            //       offset: const Offset(10, 10),
            //       blurRadius: 5,
            //       spreadRadius: 1),
            //   BoxShadow(
            //       color: Theme.of(context).colorScheme.shadow200,
            //       offset: const Offset(10, -5),
            //       blurRadius: 5,
            //       spreadRadius: 1),
            // const BoxShadow(
            //     color: Colors.white,
            //     offset: Offset(-10, 0),
            //     blurRadius: 5,
            //     spreadRadius: 1),
            // ],
            // gradient: LinearGradient(
            //   begin: Alignment.centerLeft,
            //   end: Alignment.centerRight,
            //   colors: isEnable
            //       ? Theme.of(context).colorScheme.blueShadeLiner
            //       : [Colors.transparent, Colors.transparent],
            // ),
            border: Border.all(color: Theme.of(context).colorScheme.lamisColor),
            borderRadius: BorderRadius.circular(
                context.resources.dimension.mediumMargin)),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: InternationalPhoneNumberInput(
            // initialValue: number,
            isEnabled: isEnable ? true : false,
            hintText: context.resources.strings.phoneNumber,
            onInputChanged: onInputChanged,
            countries: countries,
            selectorConfig: const SelectorConfig(
                showFlags: true,
                useEmoji: false,
                setSelectorButtonAsPrefixIcon: false,
                selectorType: PhoneInputSelectorType.DROPDOWN),
            onInputValidated: onInputValidated,
            locale: context.read<LocalizationCubit>().state.languageCode,
            ignoreBlank: false,
            errorMessage: context.watch<LocalizationCubit>().state ==
                    const Locale('ar', '')
                ? "الرقم غير صحيح"
                : "Invalid phone number",
            textStyle: TextStyle(
              fontSize: 12,
              letterSpacing: 0.5,
              color: Theme.of(context).colorScheme.primaryTextColor,
              // fontWeight: hasBackground ? FontWeight.w700 : FontWeight.w900,
            ),
            inputDecoration: InputDecoration(
              errorStyle: context.watch<LocalizationCubit>().state ==
                      const Locale('ar', '')
                  ? GoogleFonts.tajawal(
                      textStyle: TextStyle(
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.normal,
                          fontSize: 9,
                          color: Theme.of(context).colorScheme.redColor,
                          // fontFamily: typefont == Typefont.raleway ? 'Raleway' : 'Amiri',
                          decoration: TextDecoration.none),
                    )
                  : GoogleFonts.ptSansNarrow(
                      textStyle: TextStyle(
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.normal,
                          fontSize: 9,
                          color: Theme.of(context).colorScheme.redColor,
                          // fontFamily: typefont == Typefont.raleway ? 'Raleway' : 'Amiri',
                          decoration: TextDecoration.none),
                    ),
              hintTextDirection: TextDirection.ltr,
              hintStyle: TextStyle(
                // fontSize: hasBackground ? 14 : 15,
                letterSpacing: 0.5,
                color: Theme.of(context).colorScheme.primaryTextColor,
                fontWeight: FontWeight.w700,
              ),
              focusedBorder:
                  const OutlineInputBorder(borderSide: BorderSide.none),
              focusedErrorBorder:
                  const OutlineInputBorder(borderSide: BorderSide.none),
              errorBorder:
                  const OutlineInputBorder(borderSide: BorderSide.none),
              enabledBorder:
                  const OutlineInputBorder(borderSide: BorderSide.none),
            ),
            autoValidateMode: AutovalidateMode.onUserInteraction,
            selectorTextStyle: TextStyle(
              fontSize: 10,
              letterSpacing: 0.5,
              color: Theme.of(context).colorScheme.subText,
              fontWeight: FontWeight.w700,
            ),
            textFieldController: textEditingController,
            formatInput: false,
            inputBorder: const OutlineInputBorder(),
          ),
        ));
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    // setState(() {
    //   this.number = number;
    // });
  }
}
