import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/blocs/blocs.dart';
import 'package:lamis/res/resources_export.dart';
import 'package:lamis/screens/home/home_screen.dart';
import 'package:lamis/widgets/widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../cubits/cubits.dart';
import '../../repos/repos.dart';
import '../screens.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  final String? email;
  final bool? isRegister;
  final bool isFirst;
  final String? prevCountry;
  final bool? fromProducts;

  const PinCodeVerificationScreen(
      {Key? key,
      this.email,
      this.isRegister,
      this.isFirst = false,
      this.prevCountry,
      this.fromProducts = false})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  final TextEditingController _codeController = TextEditingController();

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  final formKey = GlobalKey<FormState>();
  late ValidationCubit _validationCubitCode;
  late AuthCubit authCubit;
  // late TextEditingController _passwordController;
  late String _codeErrorMessage;
  late ForgetPasswordCubit forgetPasswordCubit;
  late ForgetPasswordCubit verifyPasswordCubit;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    _validationCubitCode = ValidationCubit(true);
    // _passwordController = TextEditingController();
    forgetPasswordCubit = ForgetPasswordCubit();
    verifyPasswordCubit = ForgetPasswordCubit();
    _codeErrorMessage = WordsHelper.getLang(ValidationMessage.codeNotValid);
    authCubit = AuthCubit();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        content: CustomText(
            color: Theme.of(context).colorScheme.primaryTextColor,
            content: message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(
        title: "",
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
      body: GestureDetector(
        onTap: () {},
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              // SizedBox(height: context.resources.dimension.extraHighElevation),
              SizedBox(
                height: context.resources.dimension.largeContainerSize,
                width: context.resources.dimension.drawerBorderRadios,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      context.resources.dimension.imageBorderRadius),
                  child: Image.asset(context.resources.images.verificationLogo),
                ),
              ),
              // SizedBox(height: context.resources.dimension.smallMargin),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: context.resources.dimension.smallMargin),
                child: CustomText(
                  content: context.resources.strings.phoneVerification,
                  language: Language.center,
                  color: Theme.of(context).colorScheme.primaryTextColor,
                  titletype: TitleType.headline,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: context.resources.dimension.bigMargin,
                    vertical: context.resources.dimension.smallMargin),
                child: Column(
                  children: [
                    CustomText(
                        content: context.resources.strings.enterTheCodeSent),
                    const FixedHieght(),
                    Directionality(
                        textDirection: TextDirection.ltr,
                        child: CustomText(content: widget.email ?? '')),
                  ],
                ),
              ),
              SizedBox(
                height: context.resources.dimension.buttonHeight,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: context.resources.dimension.smallMargin,
                        horizontal: context.resources.dimension.containerSize),
                    child: BlocBuilder(
                      bloc: _validationCubitCode,
                      builder: (context, state) {
                        return Column(
                          children: [
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: PinCodeTextField(
                                errorTextDirection: TextDirection.ltr,
                                appContext: context,
                                pastedTextStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.greenColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                length: 6,
                                animationType: AnimationType.fade,
                                validator: (v) {
                                  if (v!.length < 3) {
                                    return "";
                                  } else {
                                    return null;
                                  }
                                },
                                pinTheme: PinTheme(
                                  selectedColor: Colors.transparent,
                                  activeColor: Colors.transparent,
                                  selectedFillColor: Theme.of(context)
                                      .colorScheme
                                      .scaffoldColor,
                                  inactiveColor:
                                      Theme.of(context).colorScheme.cardColor,
                                  inactiveFillColor:
                                      Theme.of(context).colorScheme.cardColor,
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(5),
                                  fieldHeight: 50,
                                  fieldWidth: 40,
                                  activeFillColor: Theme.of(context)
                                      .colorScheme
                                      .scaffoldColor,
                                ),
                                cursorColor: Theme.of(context)
                                    .colorScheme
                                    .primaryTextColor,
                                animationDuration:
                                    const Duration(milliseconds: 300),
                                enableActiveFill: true,
                                errorAnimationController: errorController,
                                controller: _codeController,
                                keyboardType: TextInputType.number,
                                boxShadows: [
                                  BoxShadow(
                                    color:
                                        Theme.of(context).colorScheme.shadow400,
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(
                                        -4, 6), // changes position of shadow
                                  ),
                                ],
                                onCompleted: (v) {
                                  debugPrint("Completed");
                                },
                                onChanged: (value) {
                                  debugPrint(value);
                                  // setState(() {
                                  //   currentText = value;
                                  // });
                                },
                                beforeTextPaste: (text) {
                                  debugPrint("Allowing to paste $text");
                                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                  return true;
                                },
                              ),
                            ),
                            state == false || state == null
                                ? CustomText(
                                    content: _codeErrorMessage,
                                    color:
                                        Theme.of(context).colorScheme.redColor,
                                    language: Language.rtl,
                                    titletype: TitleType.body,
                                  )
                                : Container()
                          ],
                        );
                      },
                    )),
              ),

              // SizedBox(
              //   height: context.resources.dimension.buttonHeight,
              // ),

              BlocBuilder(
                bloc: forgetPasswordCubit,
                builder: (context, state) {
                  if (state is VerificationLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.lamisColor,
                      ),
                    );
                  }

                  return BlocListener<AuthCubit, AuthState>(
                    bloc: authCubit,
                    listener: (context, state) {
                      if (state is AuthDoneBeforeVerification) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor:
                                Theme.of(context).colorScheme.toastBackGround,
                            content: CustomText(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryTextColor,
                              content: state.loginResponse.message,
                              language:
                                  context.read<LocalizationCubit>().state ==
                                          const Locale("ar", "")
                                      ? Language.rtl
                                      : Language.ltr,
                            )));
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          content: context.resources.strings.didntReceive,
                          titletype: TitleType.subtitle,
                          color: Theme.of(context).colorScheme.subText,
                        ),
                        TextButton(
                          onPressed: () {
                            _codeController.clear();
                            // clear forgetPasswordCubit.sendForgetPassword(
                            //      email: widget.email, sendBy: "email");
                            authCubit.login(
                              phone: widget.email ?? '',
                            );
                          },
                          child: CustomText(
                            content: context.resources.strings.resend,
                            titletype: TitleType.subtitle,
                            color: Theme.of(context).colorScheme.lamisColor,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                height: context.resources.dimension.smallMargin,
              ),
              BlocConsumer(
                bloc: verifyPasswordCubit,
                listener: (context, state) {
                  if (state is VerificationError) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor:
                            Theme.of(context).colorScheme.scaffoldColor,
                        content: CustomText(
                            color:
                                Theme.of(context).colorScheme.primaryTextColor,
                            content: state.message)));
                  }
                  if (state is VerifyRegisterDone) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor:
                            Theme.of(context).colorScheme.scaffoldColor,
                        content: CustomText(
                            color:
                                Theme.of(context).colorScheme.primaryTextColor,
                            content: state.generalResponse.message)));
                    if (state.generalResponse.result) {
                      context
                          .read<IsLoggedInCubit>()
                          .changeUserState(isLoggedIn: true);
                      context.read<UserRepo>().setUserData(
                          user: state.generalResponse.user!,
                          token: state.generalResponse.accessToken!);
                      UserRepo().setUserData(
                          user: state.generalResponse.user!,
                          token: state.generalResponse.accessToken!);
                      Authentication.registerNotification();
                      context.read<AppBloc>().add(EndDemo());
                      if (!widget.isFirst) {
                        if (widget.prevCountry == UserRepo().country) {
                          if (UserRepo().deletedAccount) {

                            Navigator.of(
                              context,
                            ).popUntil((route) => route.isFirst);
                          } else {

                            if (widget.isRegister ?? false) {
                              int count = 0;
                              Navigator.of(context)
                                  .popUntil((_) => count++ >= 1);
                            } else {
                              int count = 0;
                              Navigator.of(context)
                                  .popUntil((_) => count++ >= 2);
                            }
                          }
                        } else {
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);

                          if (context.read<CurrentScreenCubit>().state == 0) {
                            context.read<CurrentScreenCubit>().change(1);
                          }

                          context.read<CurrentScreenCubit>().change(0);
                        }
                      } else {

                        Navigator.of(context, rootNavigator: true).pop(context);
                        // Navigator.of(context).maybePop(true);
                      }
                    }
                  }
                  // if (state is VerificationDone) {
                  //   context
                  //       .read<IsLoggedInCubit>()
                  //       .changeUserState(isLoggedIn: true);
                  //   context.read<UserRepo>().setUserData(
                  //       user: state.loginResponse.user!,
                  //       token: state.loginResponse.accessToken!);
                  //   UserRepo().setUserData(
                  //       user: state.loginResponse.user!,
                  //       token: state.loginResponse.accessToken!);
                  //
                  //   if (context.read<AppBloc>().state is AppReady) {
                  //     Navigator.maybePop(context);
                  //   } else {
                  //     context.read<AppBloc>().add(EndDemo());
                  //   }
                  //   // state.forgetPasswordResponse.result
                  //   //     ? Navigator.of(context).pop(context)
                  //   //     // (Route<dynamic> route) => false)
                  //   //     : errorController!.add(ErrorAnimationType.shake);
                  // }
                },
                builder: (context, state) {
                  if (state is VerificationLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.lamisColor,
                      ),
                    );
                  }
                  return CustomButton(
                      onPress: () {
                        formKey.currentState!.validate();
                        // conditions for validating
                        _codeErrorMessage =
                            _validationCubitCode.validationVerificationCode(
                                _codeController.text, errorController);
                        if (_validationCubitCode.state == true) {
                          verifyPasswordCubit.sendVerifyCode(
                              phone: widget.email ?? '',
                              verifyCode: _codeController.text,
                              isRegister: widget.isRegister ?? false);
                        }
                      },
                      content: context.resources.strings.verify);
                },
              ),
              SizedBox(
                height: context.resources.dimension.defaultMargin,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     Flexible(
              //         child: TextButton(
              //       child: const Text("Clear"),
              //       onPressed: () {
              //         textEditingController.clear();
              //       },
              //     )),
              //     Flexible(
              //         child: TextButton(
              //       child: const Text("Set Text"),
              //       onPressed: () {
              //         setState(() {
              //           textEditingController.text = "123456";
              //         });
              //       },
              //     )),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
