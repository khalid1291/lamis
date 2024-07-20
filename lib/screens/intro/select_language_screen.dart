import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/cubits/address/selected_country_cubit.dart';
import 'package:lamis/cubits/cubits.dart';
import 'package:lamis/repos/repos.dart';
import 'package:lamis/res/resources_export.dart';
import 'package:lamis/screens/home/home_screen.dart';
import 'package:lamis/screens/intro/walkthrough_screen.dart';
import 'package:lamis/widgets/widgets.dart';

import '../../models/address/country_model.dart';

class SelectlanguageScreen extends StatefulWidget {
  final List<Country> countries;

  const SelectlanguageScreen({Key? key, required this.countries})
      : super(key: key);

  @override
  State<SelectlanguageScreen> createState() => _SelectlanguageScreenState();
}

class _SelectlanguageScreenState extends State<SelectlanguageScreen>
    with SingleTickerProviderStateMixin {
  // late AnimationController _controller;
  // late List<Bubble> bubbles;
  // final int numberOfBubbles = 75;
  // final Color color = const Color(0xFF8DB5C9);
  // final double maxBubbleSize = 50.0;

  String country = "";
  String arabicCountry = "";

  List<DropDownValueModel> list = [];

  // late GetCountriesCubit _getCountriesCubit;
  late SelectedCountryCubit _selectedCountryCubit;
  SingleValueDropDownController singleValueDropDownController =
      SingleValueDropDownController();
  @override
  void initState() {
    // _getCountriesCubit = GetCountriesCubit()..getCountries();
    _selectedCountryCubit = SelectedCountryCubit("Jordan");
    // bubbles = [];
    for (var element in widget.countries) {
      if (element.code == "JO") {
        _selectedCountryCubit.save(
            context.read<LocalizationCubit>().state == const Locale('ar', '')
                ? element.arabicName!
                : element.name!);
        country = element.name!;
        arabicCountry = element.arabicName!;
      }
    }
    //
    // int i = numberOfBubbles;
    // while (i > 0) {
    //   bubbles.add(Bubble(color, maxBubbleSize));
    //   i--;
    // }
    makeList('ar');
    // Init animation controller
    // _controller = AnimationController(
    //     duration: const Duration(seconds: 2000), vsync: this);
    // _controller.addListener(() {
    //   updateBubblePosition();
    // });
    // _controller.forward();
    super.initState();
  }

  List<DropDownValueModel> langList = [
    DropDownValueModel(name: "عربي", value: "ar"),
    DropDownValueModel(name: "English", value: "en")
  ];

  void makeList(lan) {
    for (var element in widget.countries) {
      list.add(DropDownValueModel(
          name: lan == 'ar' ? element.arabicName! : element.name!,
          value: element.code));
    }
  }

  dynamic langVal;
  dynamic countryVal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
      body: BackgroundWidget(
        title: '',
        isFirst: true,
        children:
            // CustomPaint(
            //   foregroundPainter:
            //       BubblePainter(bubbles: bubbles, controller: _controller),
            //   size: Size(MediaQuery.of(context).size.width,
            //       MediaQuery.of(context).size.height),
            // ),
            Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              Center(
                child: SizedBox(
                  height: context.resources.dimension.middleContainerSize,
                  width: context.resources.dimension.middleContainerSize,
                  // child: Image(
                  //   image: AssetImage(
                  //     context.resources.images.logoImage,
                  //   ),
                  //   fit: BoxFit.fitWidth,
                  // ),
                ),
              ),

              ///languages
              CustomText(
                content: context.resources.strings.languages,
                titletype: TitleType.subtitle,
                color: Theme.of(context).colorScheme.primaryTextColor,
              ).customMargins(),
              const FixedHieght(),
              CustomDropDown(
                  clearOption: false,
                  search: false,
                  shadow: true,
                  selected: langVal == null,
                  placeHolder:
                      context.read<LocalizationCubit>().state.languageCode ==
                              'ar'
                          ? "عربي"
                          : "English",
                  list: langList,
                  onChange: (val) {
                    for (var element in langList) {
                      if (element == val) {
                        list.clear();
                        makeList(element.value);

                        setState(() {});
                        langVal = element.name;
                        context
                            .read<LocalizationCubit>()
                            .changeLanguage(element.value);

                        for (var element in widget.countries) {
                          if (singleValueDropDownController
                                  .dropDownValue?.value ==
                              element.code) {
                            context
                                        .read<LocalizationCubit>()
                                        .state
                                        .languageCode ==
                                    'ar'
                                ? singleValueDropDownController
                                    .dropDownValue!.name = element.name!
                                : singleValueDropDownController
                                    .dropDownValue!.name = element.arabicName!;
                          }
                        }
                      }
                    }
                  }).customMargins(),

              ///countries
              CustomText(
                content: context.resources.strings.country,
                titletype: TitleType.subtitle,
                color: Theme.of(context).colorScheme.primaryTextColor,
              ).customMargins(),
              const FixedHieght(),

              BlocBuilder(
                bloc: context.read<LocalizationCubit>(),
                builder: (context, state) {
                  // print(countryVal);
                  return CustomDropDown(
                      singleValueDropDownController:
                          singleValueDropDownController,
                      clearOption: false,
                      shadow: true,
                      selected: countryVal == null,
                      placeHolder: context
                                  .read<LocalizationCubit>()
                                  .state
                                  .languageCode ==
                              'ar'
                          ? arabicCountry
                          : country,
                      list: list,
                      onChange: (val) {
                        for (var element in list) {
                          if (element == val) {
                            countryVal = element.name;
                            _selectedCountryCubit.save(element.name);
                            _selectedCountryCubit.arabicName =
                                element.value.toString();
                            setState(() {});
                            UserRepo().country = element.value.toString();
                          }
                        }
                      });
                },
              ).customMargins(),

              const FixedHieght(),

              ///submit
              Center(
                child: CustomButton(
                    onPress: () {
                      Navigator.maybePop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const WalkThroughScreen();
                      }));
                    },
                    content: context.resources.strings.continues),
              ),
              const SizedBox(
                height: 150,
              ),
              // const FixedHieght(),
              // BlocBuilder(
              //   bloc: _getCountriesCubit,
              //   builder: (context, state) {
              //     // print(state);
              //     if (state is GetCountriesDone) {
              //       List<String> countries = [];
              //       for (int i = 0;
              //           i < state.countryResponse.countries!.length;
              //           i++) {
              //         countries.add(
              //             state.countryResponse.countries![i].code ?? '');
              //       }
              //       return SizedBox(
              //         height:
              //             context.resources.dimension.textFieldHeight + 12,
              //         child: AppButton(
              //           key: const Key("Select_country"),
              //           onTap: () {
              //             showCountryPicker(
              //               context: context,
              //               showWorldWide: false,
              //               countryFilter: countries,
              //               showPhoneCode: true,
              //               onSelect: (Country country) {
              //                 UserRepo().country = country.countryCode;
              //                 _selectedCountryCubit.save(country.name);
              //                 _selectedCountryCubit
              //                     .saveFlag(country.flagEmoji);
              //               },
              //               // Optional. Sets the theme for the country list picker.
              //               countryListTheme: CountryListThemeData(
              //                 bottomSheetHeight:
              //                     MediaQuery.of(context).size.height / 3,
              //
              //                 // Optional. Sets the border radius for the bottomsheet.
              //                 borderRadius: const BorderRadius.only(
              //                   topLeft: Radius.circular(0.0),
              //                   topRight: Radius.circular(40.0),
              //                 ),
              //               ),
              //             );
              //           },
              //           widget: BlocListener(
              //             bloc: _selectedCountryCubit,
              //             listener: (context, state) {
              //               // if (kDebugMode) {
              //               // }
              //             },
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 Icon(
              //                   Icons.arrow_drop_down,
              //                   color: context.resources.color.colorWhite,
              //                 ),
              //                 _selectedCountryCubit.flag!.isEmpty
              //                     ? Icon(
              //                         Icons.flag_outlined,
              //                         color:
              //                             context.resources.color.colorWhite,
              //                       )
              //                     : Expanded(
              //                         child: CustomText(
              //                           minTextSize: 2,
              //                           content:
              //                               _selectedCountryCubit.flag ?? '',
              //                           color: context
              //                               .resources.color.colorWhite,
              //                           titletype: TitleType.bottoms,
              //                         ),
              //                       ),
              //                 const SizedBox(
              //                   width: 8,
              //                 ),
              //                 Expanded(
              //                   child: CustomText(
              //                     minTextSize: 2,
              //                     content: _selectedCountryCubit.state,
              //                     color: context.resources.color.colorWhite,
              //                     titletype: TitleType.bottoms,
              //                   ),
              //                 )
              //               ],
              //             ),
              //           ),
              //           isCountry: true,
              //           buttonText: context.resources.strings.country,
              //         ),
              //       );
              //     } else if (state is GetCountriesError) {
              //       return GestureDetector(
              //           onTap: () {
              //             _getCountriesCubit.getCountries();
              //           },
              //           child: CustomText(
              //             content: context.resources.strings.pleaseReload,
              //             color: Theme.of(context).colorScheme.redColor,
              //             titletype: TitleType.subtitle,
              //             language: Language.center,
              //           ));
              //     }
              //     return Container(
              //       height: context.resources.dimension.textFieldHeight,
              //       width: 150,
              //       decoration: BoxDecoration(
              //           color: Theme.of(context).colorScheme.cardColor,
              //           borderRadius: BorderRadius.circular(
              //               context.resources.dimension.mediumMargin)),
              //     );
              //   },
              // ),
              // const FixedHieght(),
              // BlocListener(
              //   bloc: _selectedCountryCubit,
              //   listener: (context, state) {},
              //   child: AppButton(
              //     isEnabled: _selectedCountryCubit.flag!.isNotEmpty,
              //     buttonSize: ButtonSize.big,
              //     onTap: () {
              //       context.read<LocalizationCubit>().changeLanguage('en');
              //       Navigator.maybePop(context);
              //       Navigator.push(context,
              //           MaterialPageRoute(builder: (context) {
              //         return const WalkThroughScreen();
              //       }));
              //     },
              //     buttonText: "English",
              //     color: _selectedCountryCubit.flag!.isEmpty
              //         ? Theme.of(context)
              //             .colorScheme
              //             .lamisColor
              //             .withOpacity(0.7)
              //         : Theme.of(context).colorScheme.lamisColor,
              //   ),
              // ),
              // const FixedHieght(),
              // AppButton(
              //   key: const Key("عربي"),
              //   isEnabled: _selectedCountryCubit.flag!.isNotEmpty,
              //   buttonSize: ButtonSize.big,
              //   onTap: () {
              //     context.read<LocalizationCubit>().changeLanguage('ar');
              //     Navigator.maybePop(context);
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) {
              //       return const WalkThroughScreen();
              //     }));
              //   },
              //   buttonText: "عربي",
              //   color: _selectedCountryCubit.flag!.isEmpty
              //       ? Theme.of(context)
              //           .colorScheme
              //           .lamisColor
              //           .withOpacity(0.7)
              //       : Theme.of(context).colorScheme.lamisColor,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  // void updateBubblePosition() {
  //   for (var it in bubbles) {
  //     it.updatePosition();
  //   }
  //   setState(() {});
  // }
}
