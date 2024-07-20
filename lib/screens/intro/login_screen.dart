import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/blocs/blocs.dart';
import 'package:lamis/cubits/generalSettings/general_settings_cubit.dart';

import '../../cubits/cubits.dart';
import '../../repos/repos.dart' show UserRepo;
import '../../res/resources_export.dart';
import '../../widgets/intro/phone_textfield.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class LoginScreen extends StatefulWidget {
  final bool isFirst;
  final String prevCountry;
  const LoginScreen({Key? key, this.isFirst = false, required this.prevCountry})
      : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late ValidationCubit _validationCubitPhone;
  late GeneralSettingsCubit _getCountriesCubit;
  late AddressPhoneNumberCubit _addressPhoneNumberCubit;
  late TextEditingController _phoneController;
  AuthCubit authCubit = AuthCubit();

  @override
  void initState() {
    initApp();
    _validationCubitPhone = ValidationCubit(true);
    _validationCubitPhone.save(false);
    _addressPhoneNumberCubit = AddressPhoneNumberCubit("");
    _phoneController = TextEditingController();
    _getCountriesCubit = GeneralSettingsCubit()..getGeneralSettings();
    super.initState();
  }

  void initApp() async {
    await Authentication.initializeFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: BackgroundWidget(
          isFirst: widget.isFirst,
          title: "",
          children: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height:
                          context.resources.dimension.middleContainerSize * 2.2,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height -
                          context.resources.dimension.middleContainerSize * 2.5,
                      child: Column(
                        // padding: EdgeInsets.only(top: 0.0),
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(
                            height: context.resources.dimension.priceContainer,
                            child: CustomText(
                              content: context.resources.strings.welcomeToLamis,
                              titletype: TitleType.headline,
                              color: Theme.of(context).colorScheme.darkBlue,
                              language: Language.center,
                            ),
                          ),
                          // buildPhoneNumber(),
                          BlocBuilder(
                            bloc: _getCountriesCubit,
                            builder: (context, state) {
                              if (state is GeneralSettingsDone) {
                                return SizedBox(
                                  height: context
                                          .resources.dimension.textFieldHeight +
                                      12,
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: PhoneTextField(
                                        countries: _getCountriesCubit.countries,
                                        textEditingController: _phoneController,
                                        onInputChanged: (phone) {
                                          UserRepo().country = phone.isoCode!;

                                          _addressPhoneNumberCubit.save(
                                              phone.phoneNumber != null
                                                  ? phone.phoneNumber!
                                                  : "");
                                        },
                                        onInputValidated: (phone) {
                                          _validationCubitPhone.save(phone);
                                        },
                                      ).customMargins(),
                                    ),
                                  ),
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
                                // GestureDetector(
                                //     onTap: () {
                                //       HapticFeedback.heavyImpact();
                                //       _getCountriesCubit.getGeneralSettings();
                                //     },
                                //     child: CustomText(
                                //       content: context.resources.strings.pleaseReload,
                                //       color: Theme.of(context).colorScheme.redColor,
                                //       titletype: TitleType.subtitle,
                                //       language: Language.center,
                                //     ));
                              }
                              return Container(
                                height:
                                    context.resources.dimension.textFieldHeight,
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.cardColor,
                                    borderRadius: BorderRadius.circular(context
                                        .resources.dimension.mediumMargin)),
                              );
                            },
                          ),

                          const FixedHieght(),

                          ///login  button and its logic
                          BlocConsumer<AuthCubit, AuthState>(
                            bloc: authCubit,
                            listener: (context, state) async {
                              if (state is AuthError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor:
                                            Theme.of(context)
                                                .colorScheme
                                                .scaffoldColor,
                                        content: CustomText(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryTextColor,
                                            content: state.message)));
                              }

                              if (state is AuthDoneBeforeVerification) {
                                // authCubit.returnToInitial();
                                authCubit.save(AuthInitial());

                                var res = await Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return PinCodeVerificationScreen(
                                      prevCountry: widget.prevCountry,
                                      email: _addressPhoneNumberCubit.state,
                                      isRegister: false,
                                      isFirst: widget.isFirst);
                                }));
                                if (res != null && res == true) {
                                  authCubit.save(AuthInitial());
                                }
                              }
                              if (state is AuthDone) {
                                // ignore: use_build_context_synchronously
                                context
                                    .read<IsLoggedInCubit>()
                                    .changeUserState(isLoggedIn: true);
                                // ignore: use_build_context_synchronously
                                context.read<UserRepo>().setUserData(
                                    user: state.loginResponse.user!,
                                    token: state.loginResponse.accessToken!);
                                UserRepo().setUserData(
                                    user: state.loginResponse.user!,
                                    token: state.loginResponse.accessToken!);
                              }
                            },
                            builder: (context, state) {
                              if (state is AuthInitial || state is AuthError) {
                                return Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const FixedHieght(),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: CustomButton(
                                          onPress: () {
                                            if (_phoneController.text == "" ||
                                                _phoneController.text.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .scaffoldColor,
                                                      content: CustomText(
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .primaryTextColor,
                                                          content: context
                                                              .resources
                                                              .strings
                                                              .pleaseEnterYourPhone)));
                                            }
                                            if (_validationCubitPhone.state ==
                                                true) {
                                              authCubit.login(
                                                phone: _addressPhoneNumberCubit
                                                    .state,
                                              );
                                            }
                                          },
                                          content:
                                              context.resources.strings.signIn),
                                    ),
                                    SizedBox(
                                      height: context
                                          .resources.dimension.highElevation,
                                    ),
                                  ],
                                );
                              }
                              if (state is AuthLoading) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .lamisColor,
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),

                          const FixedHieght(),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              if (context.read<AppBloc>().state is AppReady) {
                                Navigator.maybePop(context);
                              } else {
                                context.read<AppBloc>().add(EndDemo());
                              }
                            },
                            child: CustomText(
                              content:
                                  context.resources.strings.continueAsGuest,
                              titletype: TitleType.subtitle,
                              color: Theme.of(context).colorScheme.darkBlue,
                              language: Language.center,
                            ),
                          ),
                          const FixedHieght(),
                          const FixedHieght(
                            extra: true,
                          ),

                          ///you don't have an account , register
                          Container(
                            height:
                                context.resources.dimension.extraHighElevation,
                            margin: EdgeInsets.only(
                              left: context.resources.dimension.bigMargin,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  content: context
                                      .resources.strings.doYouHaveAccount,
                                  color:
                                      Theme.of(context).colorScheme.lightBlue,
                                  language: Language.center,
                                  typefont: Typefont.amiri,
                                  titletype: TitleType.bottoms,
                                ),
                                SizedBox(
                                  width:
                                      context.resources.dimension.smallMargin,
                                ),
                                InkWell(
                                  onTap: () {
                                    HapticFeedback.heavyImpact();
                                    if (widget.isFirst) {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return RegisterScreen(
                                          isFirst: widget.isFirst,
                                          prevCountry: widget.prevCountry,
                                        );
                                      }));
                                    } else {
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return RegisterScreen(
                                          isFirst: widget.isFirst,
                                          prevCountry: widget.prevCountry,
                                        );
                                      }));
                                    }
                                  },
                                  child: CustomText(
                                    content: context.resources.strings.signUp,
                                    color:
                                        Theme.of(context).colorScheme.lightBlue,
                                    // language: Language.center,
                                    // typefont: Typefont.amiri,
                                    titletype: TitleType.subtitle,
                                    textDecore: TextDecoration.underline,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).customMargins(),
              ),
            ],
          )),
    );
  }

  Future<bool> _willPopCallback() async {
    if (widget.isFirst) {
      return false;
    } else {
      Navigator.pop(context, true);
      return Future.value(false);
    }
  }
}

class LoginMethodsWidget extends StatelessWidget {
  const LoginMethodsWidget({
    Key? key,
    required this.onTap,
    required this.imageName,
    required this.loginName,
  }) : super(key: key);

  final Function onTap;
  final String imageName;
  final String loginName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        onTap();
      },
      child: Container(
        width: context.resources.dimension.middleContainerSize + 10,
        padding:
            EdgeInsets.only(right: context.resources.dimension.mediumMargin),
        height: context.resources.dimension.listImageSize,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.cardColor,
            borderRadius: BorderRadius.circular(
                context.resources.dimension.mediumMargin)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                image: AssetImage(imageName),
              ),
            ),
            CustomText(
              content: loginName,
              titletype: TitleType.bottoms,
              color: Theme.of(context).colorScheme.primaryTextColor,
              language: Language.center,
            )
          ],
        ),
      ),
    );
  }
}
