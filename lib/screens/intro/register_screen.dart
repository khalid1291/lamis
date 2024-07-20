import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/cubits/generalSettings/general_settings_cubit.dart';
import 'package:lamis/widgets/intro/phone_textfield.dart';

import '../../cubits/cubits.dart';
import '../../repos/repos.dart' show UserRepo;
import '../../res/resources_export.dart';
import '../../widgets/widgets.dart';
import '../home/home_screen.dart';
import 'verification_screen.dart';

class RegisterScreen extends StatefulWidget {
  final bool isFirst;
  final String prevCountry;
  const RegisterScreen(
      {Key? key, this.isFirst = false, required this.prevCountry})
      : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late ValidationCubit _validationCubitPhone;
  late ValidationCubit _validationCubitPhoneErrorMessage;

  late ValidationCubit _validationCubitFirstName;
  late ValidationCubit _validationCubitLastName;
  late AddressPhoneNumberCubit _addressPhoneNumberCubit;
  late GeneralSettingsCubit _getCountriesCubit;

  late TextEditingController _phoneController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _affiliateCode;

  late String _firstNameErrorMessage;
  late String _lastNameErrorMessage;
  late String _phoneErrorMessage;

  AuthCubit authCubit = AuthCubit();

  @override
  void initState() {
    _validationCubitPhone = ValidationCubit(true);
    _validationCubitFirstName = ValidationCubit(true);
    _validationCubitLastName = ValidationCubit(true);
    _validationCubitPhoneErrorMessage = ValidationCubit(true);
    _addressPhoneNumberCubit = AddressPhoneNumberCubit("");
    _phoneController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _affiliateCode = TextEditingController();
    _firstNameErrorMessage =
        WordsHelper.getLang(ValidationMessage.firstNameRequired);
    _lastNameErrorMessage =
        WordsHelper.getLang(ValidationMessage.lastNameRequired);
    _phoneErrorMessage =
        WordsHelper.getLang(ValidationMessage.phoneNumberRequired);
    _getCountriesCubit = GeneralSettingsCubit();
    _getCountriesCubit.getGeneralSettings();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
        title: "",
        children: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 0.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                SizedBox(
                  height: context.resources.dimension.middleContainerSize * 2.5,
                ),

                ///first name
                BlocBuilder(
                  bloc: _validationCubitFirstName,
                  builder: (BuildContext context, state) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            height:
                                context.resources.dimension.textFieldHeight +
                                    12,
                            child: CustomTextField(
                              label: context.resources.strings.firstName,
                              onChange: (val) {
                                _firstNameErrorMessage =
                                    _validationCubitFirstName
                                        .checkFirstName(val);
                              },
                              controller: _firstNameController,
                              icon: Transform(
                                alignment: Alignment.center,
                                transform: context
                                            .read<LocalizationCubit>()
                                            .state
                                            .languageCode ==
                                        'ar'
                                    ? Matrix4.rotationY(math.pi)
                                    : Matrix4.rotationY(0),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context
                                        .resources.dimension.mediumMargin,
                                  ),
                                  child: ImageIcon(
                                    AssetImage(
                                        context.resources.images.firstNameIcon),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryTextColor,
                                    size: context
                                        .resources.dimension.highElevation,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          state == false || state == null
                              ? CustomText(
                                  content: _firstNameErrorMessage,
                                  color: Theme.of(context).colorScheme.redColor,
                                  language: Language.rtl,
                                  titletype: TitleType.time,
                                )
                              : Container()
                        ]);
                  },
                ),

                ///last name
                BlocBuilder(
                  bloc: _validationCubitLastName,
                  builder: (BuildContext context, state) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          CustomTextField(
                            label: context.resources.strings.lastName,
                            onChange: (val) {
                              _lastNameErrorMessage =
                                  _validationCubitLastName.checkLastName(val);
                            },
                            controller: _lastNameController,
                            icon: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    context.resources.dimension.mediumMargin,
                              ),
                              child: Transform(
                                alignment: Alignment.center,
                                transform: context
                                            .read<LocalizationCubit>()
                                            .state
                                            .languageCode ==
                                        'ar'
                                    ? Matrix4.rotationY(math.pi)
                                    : Matrix4.rotationY(0),
                                child: ImageIcon(
                                  AssetImage(
                                      context.resources.images.lastNameIcon),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryTextColor,
                                  size:
                                      context.resources.dimension.highElevation,
                                ),
                              ),
                            ),
                          ),
                          state == false || state == null
                              ? CustomText(
                                  content: _lastNameErrorMessage,
                                  color: Theme.of(context).colorScheme.redColor,
                                  language: Language.rtl,
                                  titletype: TitleType.time,
                                )
                              : Container()
                        ]);
                  },
                ),
                const FixedHieght(),

                CustomTextField(
                    textInputType: TextInputType.number,
                    controller: _affiliateCode,
                    limit: 6,
                    icon: Icon(
                      Icons.discount_outlined,
                      color: Theme.of(context).colorScheme.primaryTextColor,
                      size: 20,
                    ),
                    label: context.resources.strings.inviteCode,
                    onChange: (val) {}),
                CustomText(
                  content: context.resources.strings.inviteToolTip,
                  color: Theme.of(context).colorScheme.subText,
                  titletype: TitleType.body,
                  language: context.read<LocalizationCubit>().state ==
                          const Locale("ar", "")
                      ? Language.rtl
                      : Language.ltr,
                ),
                const FixedHieght(),

                ///phone

                BlocBuilder(
                  bloc: _getCountriesCubit,
                  builder: (context, state) {
                    if (state is GeneralSettingsDone) {
                      return BlocBuilder(
                        bloc: _validationCubitPhoneErrorMessage,
                        builder: (context, state) {
                          return Container(
                            margin: EdgeInsets.only(
                                left: context.resources.dimension.smallMargin,
                                right: context.resources.dimension.smallMargin),
                            // height: context
                            //     .resources.dimension.smallContainerSize,
                            height:
                                context.resources.dimension.textFieldHeight +
                                    30,
                            width: MediaQuery.of(context).size.width * 0.75,

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: context
                                          .resources.dimension.textFieldHeight +
                                      15,
                                  child: PhoneTextField(
                                    countries: _getCountriesCubit.countries,
                                    textEditingController: _phoneController,
                                    onInputChanged: (phone) {
                                      UserRepo().country = phone.isoCode!;

                                      _addressPhoneNumberCubit.save(
                                          phone.phoneNumber != null
                                              ? phone.phoneNumber!
                                              : "");
                                      if (phone.phoneNumber != null) {
                                        // if (phone.phoneNumber == phone.dialCode!) {
                                        //   _validationCubitPhoneErrorMessage
                                        //       .save(false);
                                        // } else {
                                        //   _validationCubitPhoneErrorMessage
                                        //       .save(true);

                                        _validationCubitPhoneErrorMessage
                                            .save(true);
                                      } else {
                                        _validationCubitPhoneErrorMessage
                                            .save(false);
                                      }
                                    },
                                    onInputValidated: (phone) {
                                      _validationCubitPhone.save(phone);
                                      // if (_debounce?.isActive ?? false) {
                                      //   _debounce?.cancel();
                                      // }
                                      // _debounce = Timer(
                                      //     const Duration(milliseconds: 500), () {
                                      //   _phoneErrorMessage = _validationCubitPhone
                                      //       .validationPhoneNumber(
                                      //           _phoneController.text);
                                      // });
                                    },
                                  ),
                                ),
                                const FixedHieght(),
                                state == false || state == null
                                    ? Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: CustomText(
                                          content: _phoneErrorMessage,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .redColor,
                                          titletype: TitleType.time,
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          );
                        },
                      );
                    } else if (state is GeneralSettingsError) {
                      return Column(
                        children: [
                          const FixedHieght(),
                          CustomErrorWidget(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              _getCountriesCubit.getGeneralSettings();
                            },
                          ),
                        ],
                      );
                    }
                    return Container(
                      height: context.resources.dimension.textFieldHeight,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.cardColor,
                          borderRadius: BorderRadius.circular(
                              context.resources.dimension.mediumMargin)),
                    );
                  },
                ),

                const FixedHieght(
                  extra: true,
                ),
                BlocConsumer<AuthCubit, AuthState>(
                  bloc: authCubit,
                  listener: (context, state) {
                    if (state is AuthError) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor:
                              Theme.of(context).colorScheme.scaffoldColor,
                          content: CustomText(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryTextColor,
                              content: state.message)));
                    }
                    if (state is AuthDoneBeforeVerification) {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return PinCodeVerificationScreen(
                          email: _addressPhoneNumberCubit.state,
                          isRegister: true,
                          isFirst: widget.isFirst,
                          prevCountry: widget.prevCountry,
                        );
                      }));
                    }
                    if (state is RegisterSuccess) {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return PinCodeVerificationScreen(
                          email: _addressPhoneNumberCubit.state,
                          isRegister: true,
                          isFirst: widget.isFirst,
                          prevCountry: widget.prevCountry,
                        );
                      }));
                    }
                    if (state is AuthDone) {
                      context
                          .read<IsLoggedInCubit>()
                          .changeUserState(isLoggedIn: true);
                      UserRepo().setUserData(
                          user: state.loginResponse.user!,
                          token: state.loginResponse.accessToken!);
                      Navigator.maybePop(context);
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthInitial || state is AuthError) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButton(
                              onPress: () {
                                _firstNameErrorMessage =
                                    _validationCubitFirstName.checkFirstName(
                                        _firstNameController.text);

                                _lastNameErrorMessage = _validationCubitLastName
                                    .checkLastName(_lastNameController.text);

                                if (_phoneController.text.isEmpty) {
                                  if (_validationCubitPhone.state == true) {
                                    _validationCubitPhoneErrorMessage
                                        .save(false);
                                  }

                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //     SnackBar(
                                  //         backgroundColor: Theme.of(context)
                                  //             .colorScheme
                                  //             .scaffoldColor,
                                  //         content: CustomText(
                                  //             color: Theme.of(context)
                                  //                 .colorScheme
                                  //                 .primaryTextColor,
                                  //             content: context.resources.strings
                                  //                 .pleaseEnterYourPhone)));
                                } else {
                                  if (_validationCubitPhone.state == true &&
                                      _validationCubitFirstName.state == true &&
                                      _validationCubitLastName.state == true) {
                                    authCubit.signUp(
                                        name:
                                            "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}",
                                        phone: _addressPhoneNumberCubit.state
                                            .trim(),
                                        code: _affiliateCode.text.trim());
                                    // password: _phoneController.text.trim());
                                  }
                                }
                              },
                              content: context.resources.strings.signUp),
                          // AppButton(
                          //     onTap: () {
                          //
                          //       _firstNameErrorMessage = _validationCubitFirstName
                          //           .checkFirstName(_firstNameController.text);
                          //
                          //       _lastNameErrorMessage = _validationCubitLastName
                          //           .checkLastName(_lastNameController.text);
                          //
                          //       if (_phoneController.text.isEmpty) {
                          //         ScaffoldMessenger.of(context).showSnackBar(
                          //             SnackBar(
                          //                 content: Text(context.resources.strings
                          //                     .pleaseEnterYourPhone)));
                          //       } else {
                          //         if (_validationCubitPhone.state == true &&
                          //             _validationCubitFirstName.state == true &&
                          //             _validationCubitLastName.state == true) {
                          //           print(_validationCubitPhone.state);
                          //           authCubit.signUp(
                          //               name: _firstNameController.text.trim() +
                          //                   " " +
                          //                   _lastNameController.text.trim(),
                          //               phone: _addressPhoneNumberCubit.state
                          //                   .trim());
                          //           // password: _phoneController.text.trim());
                          //         }
                          //       }
                          //     },
                          //     buttonText: context.resources.strings.signUp),
                        ],
                      );
                    }
                    if (state is AuthLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.lamisColor,
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                // ListView(
                //   // padding: EdgeInsets.only(top: 0.0),
                //   children: [
                //
                //   ],
                // ),
              ],
            ).customMargins(),
          ),
        ));
  }
}
