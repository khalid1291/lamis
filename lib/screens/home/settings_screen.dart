import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lamis/cubits/address/change_country/change_country_cubit.dart';
import 'package:lamis/cubits/change_language/change_language_cubit.dart';
import 'package:lamis/cubits/generalSettings/general_settings_cubit.dart';
import 'package:lamis/main.dart';
import 'package:lamis/repos/repos.dart';
import 'package:lamis/res/app_context_extension.dart';
import 'package:lamis/res/colors/app_colors.dart';
import 'package:lamis/screens/home/home_screen.dart';

import '../../cubits/cubits.dart';
import '../../models/address/country_model.dart';
import '../../widgets/widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // final List<ThemeType> _dropDownStatusList = getThemeStatusList();
  // List<ThemeType> getThemeStatusList() {
  //   return <ThemeType>[
  //     PaymentStatus('', "All"),
  //     PaymentStatus('paid', "Paid"),
  //     PaymentStatus('unpaid', "Unpaid"),
  //   ];
  // }

  late GeneralSettingsCubit _getCountriesCubit;
  late SingleValueDropDownController singleValueDropDownController;
  late ChangeCountryCubit changeCountryCubit;
  late ChangeLanguageCubit changeLanguageCubit;
  List<Country> countries = [];

  @override
  void initState() {
    _getCountriesCubit = GeneralSettingsCubit()..getGeneralSettings();
    singleValueDropDownController = SingleValueDropDownController();
    changeCountryCubit = ChangeCountryCubit();
    changeLanguageCubit = ChangeLanguageCubit();
    // _themeTypeDropDown = buildDropdownThemeTypeItems(_paymentStatusList);
    super.initState();
  }

  List<DropDownValueModel> themeList = [
    DropDownValueModel(name: "Auto / تلقائي", value: ThemeType.auto),
    DropDownValueModel(name: "Light / وضع نهاري", value: ThemeType.light),
    DropDownValueModel(name: "Dark / وضع ليلي", value: ThemeType.dark)
  ];

  List<DropDownValueModel> langList = [
    DropDownValueModel(
      name: "عربي",
      value: "ar",
      icon: ImageIcon(
        const AssetImage("assets/images/Arabic.png"),
        color: Theme.of(context).colorScheme.iconColor,
      ),
    ),
    DropDownValueModel(
      name: "English",
      value: "en",
      icon: ImageIcon(
        const AssetImage("assets/images/English.png"),
        color: Theme.of(context).colorScheme.iconColor,
      ),
    )
  ];

  dynamic themeVal;
  dynamic langVal;
  dynamic countryVal;

  String getThemeName() {
    int num = context.read<CurrentThemeCubit>().state.themeType.index;
    if (num == 0) {
      return MyApp.context.resources.strings.themeAuto;
    } else if (num == 1) {
      return MyApp.context.resources.strings.themeDark;
    } else if (num == 2) {
      return MyApp.context.resources.strings.themeLight;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    Future<bool> _willPopCallback() async {
      Navigator.pop(context, true);
      return Future.value(false);
    }

    return WillPopScope(
        onWillPop: _willPopCallback,
        child: BackgroundWidget(
            title: "",
            children: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: context.resources.dimension.smallContainerSize,
                  ),
                  Column(
                    children: [
                      const FixedHieght(),
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width,
                      //   child: CustomText(
                      //     content: context.resources.strings.themes,
                      //     color: Theme.of(context).colorScheme.primaryTextColor,
                      //     titletype: TitleType.subtitle,
                      //     language: context.watch<LocalizationCubit>().state ==
                      //             const Locale('ar', '')
                      //         ? Language.rtl
                      //         : Language.ltr,
                      //   ).customMargins(),
                      // ),
                      // const FixedHieght(),
                      // BlocBuilder(
                      //   bloc: context.read<CurrentThemeCubit>(),
                      //   builder: (context, state) {
                      //     return ListTile(
                      //       title: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           CustomDropDown(
                      //               clearOption: false,
                      //               search: false,
                      //               shadow: true,
                      //               selected: themeVal == null,
                      //               placeHolder: getThemeName(),
                      //               list: themeList,
                      //               onChange: (val) {
                      //                 for (var element in themeList) {
                      //                   if (element == val) {
                      //                     themeVal = element.name;
                      //                     context
                      //                         .read<CurrentThemeCubit>()
                      //                         .changeTheme(element.value);
                      //                   }
                      //                 }
                      //               }),
                      //         ],
                      //       ),
                      //     );
                      //   },
                      // ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: CustomText(
                          content: context.resources.strings.languages,
                          color: Theme.of(context).colorScheme.primaryTextColor,
                          titletype: TitleType.subtitle,
                          language: context.watch<LocalizationCubit>().state ==
                                  const Locale('ar', '')
                              ? Language.rtl
                              : Language.ltr,
                        ),
                      ).customMargins(),
                      BlocListener(
                        bloc: changeLanguageCubit,
                        listener: (context, state) {
                          if (state is ChangeLanguageDone) {
                            if (kDebugMode) {
                              print(
                                  "the result is ${state.generalResponse.message}");
                            }
                          }
                        },
                        child: CustomDropDown(
                            clearOption: false,
                            search: false,
                            shadow: true,
                            selected: langVal == null,
                            placeHolder: context
                                        .read<LocalizationCubit>()
                                        .state
                                        .languageCode ==
                                    'ar'
                                ? "عربي"
                                : "English",
                            list: langList,
                            onChange: (val) {
                              for (var element in langList) {
                                if (element == val) {
                                  langVal = element.name;
                                  context
                                      .read<LocalizationCubit>()
                                      .changeLanguage(element.value);
                                  if (context.read<IsLoggedInCubit>().state) {
                                    changeLanguageCubit
                                        .changeLang(element.value);
                                  }
                                  for (var element in countries) {
                                    if (singleValueDropDownController
                                            .dropDownValue?.value ==
                                        element.code) {
                                      context
                                                  .read<LocalizationCubit>()
                                                  .state
                                                  .languageCode ==
                                              'ar'
                                          ? singleValueDropDownController
                                              .dropDownValue!
                                              .name = element.name!
                                          : singleValueDropDownController
                                              .dropDownValue!
                                              .name = element.arabicName!;
                                    }
                                  }
                                }
                              }
                              Phoenix.rebirth(context);
                            }),
                      ).customMargins(),
                      const FixedHieght(),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: CustomText(
                          content: context.resources.strings.country,
                          color: Theme.of(context).colorScheme.primaryTextColor,
                          titletype: TitleType.subtitle,
                          language: context.watch<LocalizationCubit>().state ==
                                  const Locale('ar', '')
                              ? Language.rtl
                              : Language.ltr,
                        ),
                      ).customMargins(),
                      BlocBuilder<GeneralSettingsCubit, GeneralSettingsState>(
                        bloc: _getCountriesCubit,
                        builder: (context, state) {
                          if (state is GeneralSettingsLoading) {
                            return SizedBox(
                                height: 65,
                                width: MediaQuery.of(context).size.width * 0.66,
                                child: NeumorphismBrands(
                                  child: Container(),
                                ));
                          } else if (state is GeneralSettingsDone) {
                            countries = state.generalSettings.countries!.data!;
                            String country = "";
// ignore: unused_local_variable
                            for (var val
                                in state.generalSettings.countries!.data!) {
                              if (val.code == UserRepo().country) {
                                country = context
                                            .read<LocalizationCubit>()
                                            .state
                                            .languageCode ==
                                        "ar"
                                    ? country = val.arabicName!
                                    : val.name!;
                              }
                            }
                            if (context.watch<IsLoggedInCubit>().state) {
                              return SizedBox(
                                height: 65,
                                width: MediaQuery.of(context).size.width * 0.66,
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .scaffoldColor,
                                        borderRadius: BorderRadius.circular(
                                            context.resources.dimension
                                                .defaultMargin),
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .lamisColor)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 70, vertical: 20),
                                      child: CustomText(
                                        content: country,
                                        titletype: TitleType.bottoms,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryTextColor,
                                        language: Language.center,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              List<DropDownValueModel> list = [];
                              for (var element
                                  in state.generalSettings.countries!.data!) {
                                list.add(DropDownValueModel(
                                    name: context
                                                .read<LocalizationCubit>()
                                                .state
                                                .languageCode ==
                                            "ar"
                                        ? element.arabicName!
                                        : element.name!,
                                    value: element.code));
                              }
                              return BlocListener<ChangeCountryCubit,
                                  ChangeCountryState>(
                                bloc: changeCountryCubit,
                                listener: (context, state) {
                                  if (state is ChangeCountryDone) {
                                    if (kDebugMode) {
                                      print(state.response.message);
                                    }
                                  }
                                },
                                child: CustomDropDown(
                                    singleValueDropDownController:
                                        singleValueDropDownController,
                                    clearOption: false,
                                    shadow: true,
                                    selected: countryVal == null,
                                    placeHolder: country,
                                    list: list,
                                    onChange: (val) {
                                      for (var element in list) {
                                        if (element == val) {
                                          countryVal = element.name;
                                          setState(() {});
                                          changeCountryCubit.changeCountry();
                                          UserRepo().country =
                                              element.value.toString();
                                          Phoenix.rebirth(context);
                                        }
                                      }
                                    }),
                              ).customMargins();
                            }
                          }
                          return SizedBox(
                            height: 65,
                            width: MediaQuery.of(context).size.width * 0.66,
                            child: NeumorphismBrands(
                              neumorphismType: NeumorphismType.buttons,
                              blueLiner: true,
                              child: Center(
                                child: CustomText(
                                  content: context.resources.strings.country,
                                  titletype: TitleType.bottoms,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryTextColor,
                                  language: Language.center,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ])));
  }
}
