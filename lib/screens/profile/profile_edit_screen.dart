import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lamis/blocs/main/app_bloc.dart';
import 'package:lamis/cubits/profile/delete_account/delete_account_cubit.dart';
import 'package:lamis/cubits/profile/delete_image/delete_image_cubit.dart';
import 'package:lamis/screens/home/home_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../cubits/cubits.dart';
import '../../data/remote/network/base_api_service.dart';
import '../../repos/repos.dart' show UserRepo;
import '../../res/resources_export.dart';
import '../../widgets/widgets.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final ScrollController _mainScrollController = ScrollController();
  late final TextEditingController _nameController;

  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late RemoveImageCubit removeImageCubit;
  //for image uploading
  final ImagePicker _picker = ImagePicker();
  late XFile _file;
  Timer? _debounce;

  static get userName => UserRepo().user.name;
  static get phoneNumber => UserRepo().user.phone;
  static get email => UserRepo().user.email;
  String _emailErrorMessage = "";
  String userImage = "";
  late ProfileEditCubit profileEditCubit;
  FToast fToast = FToast();
  late ValidationCubit _validationCubitEmail;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _nameController = TextEditingController(text: "$userName");
    _phoneController = TextEditingController(text: phoneNumber);
    _emailController = TextEditingController(text: email);
    _validationCubitEmail = ValidationCubit(true);
    profileEditCubit = ProfileEditCubit();
    userImage = UserRepo().user.avatarOriginal;
    removeImageCubit = RemoveImageCubit();
    fToast.init(context);
    _emailErrorMessage = WordsHelper.getLang(ValidationMessage.emailRequired);

    super.initState();
  }

  chooseAndUploadImage(context) async {
    var status = await Permission.photos.request();

    if (status.isPermanentlyDenied && Platform.isIOS) {
      openAppSettings();
    }
    if (status.isDenied && Platform.isIOS) {
      openAppSettings();
    } else if (status.isRestricted && Platform.isIOS) {
      openAppSettings();
    } else {
      // _file = (await ImagePicker.pickImage(source: ImageSource.camera))!;
      _file = (await _picker.pickImage(source: ImageSource.gallery))!;

      String base64Image = FileHelper.getBase64FormateFile(_file.path);
      String fileName = _file.path.split("/").last;
      profileEditCubit.editProfileImage(
          id: UserRepo().user.id, fileName: fileName, image: base64Image);
    }
  }

  Future<bool?> _checkPermission(BuildContext context) async {
    Map<Permission, PermissionStatus> statues = await [
      Permission.camera,
      Permission.storage,
      Permission.photos
    ].request();
    PermissionStatus? statusCamera = statues[Permission.camera];
    PermissionStatus? statusStorage = statues[Permission.storage];
    PermissionStatus? statusPhotos = statues[Permission.photos];
    bool isGranted = statusCamera == PermissionStatus.granted &&
        statusStorage == PermissionStatus.granted &&
        statusPhotos == PermissionStatus.granted;
    if (isGranted) {
      return true;
    }
    bool isPermanentlyDenied =
        statusCamera == PermissionStatus.permanentlyDenied ||
            statusStorage == PermissionStatus.permanentlyDenied ||
            statusPhotos == PermissionStatus.permanentlyDenied;
    if (isPermanentlyDenied) {
      return false;
    }
    return null;
  }

  removeImage() async {
    removeImageCubit.removeProfileImage();
  }

  Future<void> _onPageRefresh() async {}

  onPressUpdate() async {
    var name = _nameController.text.toString();
    var email = _emailController.text;
    // var passwordConfirm = _passwordConfirmController.text.toString();

    profileEditCubit.editProfileData(
      id: UserRepo().user.id,
      name: name,
      email: email,
    );
  }

  Future<bool> _willPopCallback() async {
    // _productQuantityCubit.save(1);
    Navigator.of(context).pop(true);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        appBar: CustomAppBar(
          title: context.resources.strings.updateProfile,
        ),
        body: buildBody(context),
      ),
    );
  }

  buildBody(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: RefreshIndicator(
        color: Theme.of(context).primaryColor,
        backgroundColor: Colors.white,
        onRefresh: _onPageRefresh,
        displacement: 10,
        child: ListView(
          controller: _mainScrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          children: [
            // CustomText(
            //   content: context.resources.strings.updateProfile,
            //   titletype: TitleType.subtitle,
            //   language: Language.center,
            // ),
            BlocListener(
              bloc: removeImageCubit,
              listener: (context, state) {
                if (state is RemoveImageDone) {
                  fToast.showToast(
                    child: ToastBody(
                      text: state.response.message,
                      bgColor: Theme.of(context).colorScheme.toastBackGround,
                    ),
                  );
                  Navigator.maybePop(context, [true]);
                } else if (state is RemoveImageError) {
                  fToast.showToast(
                    child: ToastBody(
                      text: state.errorMessage,
                      iconColor: Theme.of(context).colorScheme.redColor,
                      bgColor: Theme.of(context).colorScheme.toastBackGround,
                    ),
                  );
                } else {
                  fToast.showToast(
                    child: ToastBody(
                      text: context.resources.strings.loading,
                      bgColor: Theme.of(context).colorScheme.toastBackGround,
                    ),
                  );
                }
              },
              child: Container(),
            ),
            BlocBuilder(
              bloc: profileEditCubit,
              builder: (context, state) {
                if (state is UploadImageDone) {
                  userImage = state.profileUploadImageResponse.path;
                  return buildTopSection();
                }
                if (state is ProfileEditLoading) {
                  return buildTopSectionShimmer();
                }
                return buildTopSection();
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: context.resources.dimension.defaultMargin),
              child: Divider(
                height: context.resources.dimension.veryHighElevation,
              ),
            ),
            buildProfileForm(context),
          ],
        ),
      ),
    );
    //}
  }

  buildTopSection() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: context.resources.dimension.defaultMargin,
              bottom: context.resources.dimension.smallMargin),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: context.resources.dimension.defaultMargin,
                    bottom: context.resources.dimension.smallMargin),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    // border: Border.all(
                    //     color: Theme.of(context).colorScheme.border, width: 2),
                    //shape: BoxShape.rectangle,
                  ),
                  child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(100.0)),
                    child: userImage != BaseApiService.imagesRoute
                        ? FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: userImage,
                            fit: BoxFit.fill,
                            imageErrorBuilder: (context, object, stacktrace) {
                              return Container(
                                  height: context.resources.dimension.bigMargin,
                                  width: context.resources.dimension.bigMargin,
                                  color:
                                      Theme.of(context).colorScheme.cardColor);
                            },
                          )
                        : Image.asset(
                            'assets/images/user_image_place_holder.png'),
                  ),
                ),
              ),
              Positioned(
                right: context.resources.dimension.smallMargin,
                bottom: context.resources.dimension.smallMargin,
                child: GestureDetector(
                  onTap: () {
                    chooseAndUploadImage(context);
                  },
                  child: SizedBox(
                      width: context.resources.dimension.veryHighElevation,
                      height: context.resources.dimension.veryHighElevation,
                      child: Icon(
                        Icons.edit,
                        color: Theme.of(context).primaryColor,
                      )),
                ),
              ),
              Positioned(
                left: context.resources.dimension.smallMargin,
                bottom: context.resources.dimension.smallMargin,
                child: GestureDetector(
                  onTap: () {
                    userImage != BaseApiService.imagesRoute
                        ? removeImage()
                        : null;
                  },
                  child: SizedBox(
                    width: context.resources.dimension.veryHighElevation,
                    height: context.resources.dimension.veryHighElevation,
                    child: userImage != BaseApiService.imagesRoute
                        ? SizedBox(
                            width:
                                context.resources.dimension.veryHighElevation,
                            height:
                                context.resources.dimension.veryHighElevation,
                            child: Icon(
                              Icons.delete_forever,
                              color: Theme.of(context).primaryColor,
                            ))
                        : Container(),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  buildTopSectionShimmer() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: context.resources.dimension.defaultMargin,
              bottom: context.resources.dimension.smallMargin),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: context.resources.dimension.defaultMargin,
                    bottom: context.resources.dimension.smallMargin),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100.0)),
                      child: Container(
                          height: context.resources.dimension.bigMargin,
                          width: context.resources.dimension.bigMargin,
                          color: Theme.of(context).colorScheme.cardColor)),
                ),
              ),
              Positioned(
                right: context.resources.dimension.smallMargin,
                bottom: context.resources.dimension.smallMargin,
                child: SizedBox(
                    width: context.resources.dimension.veryHighElevation,
                    height: context.resources.dimension.veryHighElevation,
                    child: Icon(
                      Icons.edit,
                      color: Theme.of(context).disabledColor,
                    )),
              ),
              Positioned(
                left: context.resources.dimension.smallMargin,
                bottom: context.resources.dimension.smallMargin,
                child: SizedBox(
                  width: context.resources.dimension.veryHighElevation,
                  height: context.resources.dimension.veryHighElevation,
                  child: userImage != BaseApiService.imagesRoute
                      ? SizedBox(
                          width: context.resources.dimension.veryHighElevation,
                          height: context.resources.dimension.veryHighElevation,
                          child: Icon(
                            Icons.delete_forever,
                            color: Theme.of(context).disabledColor,
                          ))
                      : Container(),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  buildProfileForm(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(
            context.resources.dimension.bigMargin,
            context.resources.dimension.zeroElevation,
            context.resources.dimension.bigMargin,
            context.resources.dimension.containerSize),
        child: BlocConsumer<ProfileEditCubit, ProfileEditState>(
            bloc: profileEditCubit,
            listener: (context, state) {
              if (state is ProfileEditError) {
                fToast.showToast(
                  child: ToastBody(
                    text: state.errorMessage,
                    iconColor: Theme.of(context).colorScheme.redColor,
                    bgColor: Theme.of(context).colorScheme.toastBackGround,
                  ),
                );
              }
              if (state is ProfileEditDone) {
                fToast.showToast(
                  child: ToastBody(
                    text: state.profileEditResponse.message,
                    bgColor: Theme.of(context).colorScheme.toastBackGround,
                  ),
                );
                Navigator.maybePop(context, true);
              }
              if (state is UploadImageDone) {
                fToast.showToast(
                  child: ToastBody(
                    text: state.profileUploadImageResponse.message,
                    bgColor: Theme.of(context).colorScheme.toastBackGround,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is ProfileEditInitial ||
                  state is ProfileEditError ||
                  state is UploadImageDone) {
                if (state is UploadImageDone) {
                  userImage = state.profileUploadImageResponse.path;
                }
                return Padding(
                  padding: EdgeInsets.only(
                      top: context.resources.dimension.smallMargin,
                      bottom: context.resources.dimension.smallMargin,
                      left: context.resources.dimension.defaultMargin,
                      right: context.resources.dimension.defaultMargin),
                  child: Column(
                    crossAxisAlignment:
                        context.watch<LocalizationCubit>().state ==
                                const Locale("en", "")
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                    children: [
                      CustomText(
                        content: context.resources.strings.basicInformation,
                        titletype: TitleType.subtitle,
                      ),
                      const FixedHieght(),
                      CustomText(
                        content: context.resources.strings.name,
                        color: Theme.of(context).colorScheme.iconColor,
                      ),
                      const FixedHieght(),
                      SizedBox(
                        height: 65,
                        child: Directionality(
                          textDirection:
                              context.read<LocalizationCubit>().state ==
                                      const Locale('ar', '')
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                          child: CustomTextField(
                            controller: _nameController,
                            onChange: (String st) {},
                            label: "",
                            titleState: false,
                          ),
                        ),
                      ),
                      const FixedHieght(
                        extra: true,
                      ),
                      CustomText(
                        content: context.resources.strings.phoneNumber,
                        color: Theme.of(context).colorScheme.iconColor,
                      ),
                      const FixedHieght(),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: context.resources.dimension.textFieldHeight,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    Theme.of(context).colorScheme.lamisColor),
                            // color: Theme.of(context).colorScheme.cardColor,
                            borderRadius: BorderRadius.circular(
                                context.resources.dimension.mediumMargin)),
                        child: Align(
                          alignment: context.read<LocalizationCubit>().state ==
                                  const Locale('ar', "")
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: CustomText(
                            content: _phoneController.text,
                            titletype: TitleType.bottoms,
                            language: context.read<LocalizationCubit>().state ==
                                    const Locale("ar", "")
                                ? Language.rtl
                                : Language.ltr,
                            color: Theme.of(context).colorScheme.darkBlue,
                          ).customMargins(),
                        ),
                      ),
                      const FixedHieght(
                        extra: true,
                      ),
                      CustomText(
                        content: context.resources.strings.email,
                        color: Theme.of(context).colorScheme.iconColor,
                      ),
                      const FixedHieght(),
                      BlocBuilder(
                        bloc: _validationCubitEmail,
                        builder: (context, state) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height: 65,
                                  child: Directionality(
                                    textDirection: context
                                                .read<LocalizationCubit>()
                                                .state ==
                                            const Locale('ar', '')
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                                    child: CustomTextField(
                                      hint: _emailController.text,
                                      controller: _emailController,
                                      textInputType: TextInputType.emailAddress,
                                      onChange: (val) {
                                        if (_debounce?.isActive ?? false) {
                                          _debounce?.cancel();
                                        }
                                        _debounce = Timer(
                                            const Duration(milliseconds: 500),
                                            () {
                                          // do something with query
                                          _emailErrorMessage =
                                              _validationCubitEmail
                                                  .validateEmail(val, true);
                                        });
                                      },
                                      label: '',
                                    ),
                                  )),
                              state == false
                                  ? CustomText(
                                      content: _emailErrorMessage,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryTextColor,
                                      language: Language.rtl,
                                      titletype: TitleType.time,
                                    )
                                  : Container(),
                            ],
                          );
                        },
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          Padding(
                            padding: EdgeInsets.only(
                                top: context.resources.dimension.defaultMargin),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(context
                                          .resources.dimension.smallMargin))),
                              child: CustomButton(
                                content:
                                    context.resources.strings.updateProfile,
                                onPress: () {
                                  if (_validationCubitEmail.state!) {
                                    onPressUpdate();
                                  } else {
                                    fToast.showToast(
                                        child: ToastBody(
                                            text: context.resources.strings
                                                .emailIsNotValid,
                                            bgColor: Theme.of(context)
                                                .colorScheme
                                                .toastBackGround),
                                        gravity: ToastGravity.CENTER);
                                  }
                                },
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                context.resources.dimension.defaultMargin),
                        child: Divider(
                          height: context.resources.dimension.veryHighElevation,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: CustomButton(
                            onPress: () async {
                              var res = await BottomSheets.showModal(context,
                                  hasBorderMargin: false,
                                  child: DeleteAccountSheet());
                              if (res != null && res == true) {
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context, true);
                              }
                            },
                            content: context.resources.strings.deleteAccount,
                            red: true,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
              if (state is ProfileEditLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.lamisColor,
                  ),
                );
              } else {
                return Container();
              }
            }));
  }
}

// ignore: must_be_immutable
class DeleteAccountSheet extends StatelessWidget {
  DeleteAccountCubit deleteAccountCubit = DeleteAccountCubit();

  DeleteAccountSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                content: context.resources.strings.warningDeleteAccount,
                titletype: TitleType.subtitle,
                color: Theme.of(context).colorScheme.primaryTextColor,
                language:
                    context.read<LocalizationCubit>().state.languageCode == "en"
                        ? Language.ltr
                        : Language.rtl,
              ),
              CustomText(
                content: context.resources.strings.confirmDeleteAccount,
                titletype: TitleType.subtitle,
                color: Theme.of(context).colorScheme.primaryTextColor,
                language:
                    context.read<LocalizationCubit>().state.languageCode == "en"
                        ? Language.ltr
                        : Language.rtl,
              ),
            ],
          ),
        ),
        BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
          bloc: deleteAccountCubit,
          listener: (context, state) {
            if (state is DeleteAccountDone) {
              context.read<AppBloc>().add(FetchAppData());
              context.read<CurrentScreenCubit>().change(0);
              context
                  .read<IsLoggedInCubit>()
                  .changeUserState(isLoggedIn: false);
              Navigator.pop(context, true);
            }
          },
          builder: (context, state) {
            if (state is DeleteAccountLoading) {
              return const CircularProgressIndicator();
            }
            return Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: CustomButton(
                      onPress: () {
                        Navigator.maybePop(context);
                      },
                      content: context.resources.strings.cancel),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: CustomButton(
                      onPress: () {
                        HapticFeedback.heavyImpact();
                        deleteAccountCubit.deleteMyAccount();
                      },
                      content: context.resources.strings.continues),
                ),
              ],
            );
          },
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}

class FileHelper {
  static String getBase64FormateFile(String path) {
    File file = File(path);
    if (kDebugMode) {
      print('File is = $file');
    }
    List<int> fileInByte = file.readAsBytesSync();
    String fileInBase64 = base64Encode(fileInByte);
    return fileInBase64;
  }
}
