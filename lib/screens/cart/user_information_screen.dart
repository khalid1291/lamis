import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lamis/repos/repos.dart';
import 'package:lamis/res/resources_export.dart';
import 'package:lamis/screens/home/home_screen.dart';
import 'package:lamis/widgets/intro/phone_textfield.dart';
import 'package:lamis/widgets/widgets.dart';

import '../../cubits/cubits.dart';
import '../../models/address/address_response.dart';

class UserInformationScreen extends StatefulWidget {
  final Address? address;
  final bool update;

  const UserInformationScreen({Key? key, this.address, this.update = false})
      : super(key: key);

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  late AddAddressCubit _addAddressCubit;
  late AddressAddressNameCubit _addressAddressNameCubit;
  late AddressCityNameCubit _addressCityNameCubit;
  late AddressCountryNameCubit _addressCountryNameCubit;
  late AddressPhoneNumberCubit _addressPhoneNumberCubit;
  late AddressZipCodeCubit _addressZipCodeCubit;
  late AddressStateNameCubit _addressStateNameCubit;
  late GetCountriesCubit _getCountriesCubit;
  late GetStatesCubit _getStatesCubit;
  late GetCitiesCubit _getCitiesCubit;
  FToast fToast = FToast();
  late List<String> countries;
  late TextEditingController _phoneController;
  late ValidationCubit _validationCubitPhone;
  late TextEditingController zipCode;
  late TextEditingController _addressController;

  bool shouldUpdate = false;

  @override
  void initState() {
    _addAddressCubit = AddAddressCubit();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    zipCode = TextEditingController();
    if (widget.update) {
      shouldUpdate = true;
      _addressAddressNameCubit =
          AddressAddressNameCubit(widget.address!.address ?? '');
      _addressCityNameCubit =
          AddressCityNameCubit(widget.address!.cityId ?? -1);
      _addressCountryNameCubit =
          AddressCountryNameCubit(widget.address!.countryId ?? -1);
      _addressPhoneNumberCubit =
          AddressPhoneNumberCubit(widget.address?.phone ?? "");
      _addressZipCodeCubit =
          AddressZipCodeCubit(widget.address?.postalCode ?? '');
      _addressStateNameCubit =
          AddressStateNameCubit(widget.address?.stateId ?? -1);
      _getStatesCubit = GetStatesCubit()
        ..getStates(widget.address?.countryId ?? 0);
      _getCitiesCubit = GetCitiesCubit();

      _phoneController.text = widget.address?.phone ?? '';
      zipCode.text = widget.address?.postalCode ?? '';
      _addressController.text = widget.address?.address ?? '';
    } else {
      _addressAddressNameCubit = AddressAddressNameCubit("");
      _addressCityNameCubit = AddressCityNameCubit(-1);
      _addressCountryNameCubit = AddressCountryNameCubit(-1);
      _addressPhoneNumberCubit = AddressPhoneNumberCubit("");
      _addressZipCodeCubit = AddressZipCodeCubit("");
      _addressStateNameCubit = AddressStateNameCubit(-1);
      _getStatesCubit = GetStatesCubit();
      _getCitiesCubit = GetCitiesCubit();
    }

    _getCountriesCubit = GetCountriesCubit()..getCountries();

    fToast.init(context);
    countries = [];

    _validationCubitPhone = ValidationCubit(true);
    super.initState();
  }

  Future<bool> _willPopCallback() async {
    Navigator.pop(context, true);
    return Future.value(false);
  }

  bool enabled = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: BlocListener<AddAddressCubit, AddAddressState>(
          bloc: _addAddressCubit,
          listener: (context, state) {
            if (state is AddAddressLoading) {
              fToast.showToast(
                  child: ToastBody(
                text: context.resources.strings.loading,
                bgColor: Theme.of(context).colorScheme.toastBackGround,
              ));
            }
            if (state is AddAddressDone) {
              fToast.showToast(
                  child: ToastBody(
                      bgColor: Theme.of(context).colorScheme.toastBackGround,
                      icon: Icons.done_all,
                      text: state.response.message));
              enabled = true;
              Navigator.pop(context, true);
            }
            if (state is AddAddressError) {
              fToast.showToast(
                  child: ToastBody(
                      bgColor: Theme.of(context).colorScheme.toastBackGround,
                      iconColor: Theme.of(context).colorScheme.redColor,
                      text: state.message));
            }
          },
          child: Padding(
            padding: EdgeInsets.all(context.resources.dimension.mediumMargin),
            child: ListView(
              children: [
                Center(
                  child: CustomText(
                    content: widget.update
                        ? context.resources.strings.update
                        : context.resources.strings.addAddress,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                    titletype: TitleType.subtitle,
                  ),
                ),
                const FixedHieght(),

                BlocListener(
                    bloc: _getCountriesCubit,
                    listener: (context, state) {
                      if (state is GetCountriesDone) {
                        if (!widget.update) {
                          for (int i = 0;
                              i < state.countryResponse.countries!.length;
                              i++) {
                            if (state.countryResponse.countries![i].code ==
                                UserRepo().country) {
                              _addressCountryNameCubit
                                  .save(state.countryResponse.countries![i].id);

                              _getStatesCubit
                                  .getStates(_addressCountryNameCubit.state);
                            }
                          }
                        }

                        // List<DropDownValueModel> list = [];
                        // countries.addAll(_getCountriesCubit.countries);
                        // for (var element in state.countryResponse.countries!) {
                        //   list.add(DropDownValueModel(
                        //       name: element.name!, value: element.id));
                        // }
                        //  CustomDropDown(
                        //   list: list,
                        //   onChange: (val) {
                        //     if (val == "") {
                        //       _addressCountryNameCubit.save(-1);
                        //     } else {
                        //       for (var element in list) {
                        //         if (element == val) {
                        //           _addressCountryNameCubit.save(element.value);
                        //           _getStatesCubit
                        //               .getStates(_addressCountryNameCubit.state);
                        //         }
                        //       }
                        //     }
                        //   },
                        // );
                      }
                    },
                    child: Container()),
                //state
                BlocBuilder(
                    bloc: _getStatesCubit,
                    builder: (context, state) {
                      if (state is GetStatesLoading) {
                        return const _CustomShimmer();
                      }
                      if (state is GetStatesDone) {
                        List<DropDownValueModel> list = [];

                        for (var element in state.response.states!) {
                          list.add(DropDownValueModel(
                              name: element.name!, value: element.id));
                        }

                        if (widget.update) {
                          _addressStateNameCubit
                              .save(widget.address?.stateId ?? -1);
                          _getCitiesCubit
                              .getCities(_addressStateNameCubit.state);
                        }
                        return BlocBuilder(
                          bloc: _addressStateNameCubit,
                          builder: (context, state) {
                            if (list.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: context
                                      .resources.strings.cannotUseAppInCountry,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .toastBackGround,
                                  textColor: Theme.of(context)
                                      .colorScheme
                                      .primaryTextColor);

                              Navigator.maybePop(context, true);
                            } else {
                              return CustomDropDown(
                                  list: list,
                                  selected: widget.update
                                      ? widget.address?.stateId ==
                                          _addressStateNameCubit.state
                                      : _addressStateNameCubit.state == -1,
                                  placeHolder: widget.update
                                      ? widget.address!.stateName!
                                      : context.resources.strings.state,
                                  onChange: (val) {
                                    if (val == "") {
                                      _addressStateNameCubit.save(-1);
                                    } else {
                                      for (var element in list) {
                                        if (element == val) {
                                          shouldUpdate = false;
                                          _addressCityNameCubit.save(-1);
                                          _addressStateNameCubit
                                              .save(element.value);
                                          _getCitiesCubit.getCities(
                                              _addressStateNameCubit.state);
                                        }
                                      }
                                    }
                                  });
                            }
                            return Container();
                          },
                        );
                      }
                      if (state is GetStatesError) {
                        return CustomErrorWidget(
                          onTap: () {
                            _getStatesCubit
                                .getStates(_addressCountryNameCubit.state);
                          },
                        );
                      }
                      return CustomTextField(
                          isAddress: true,
                          label: context.resources.strings.state,
                          onChange: (vale) {});
                    }),
                //cities
                BlocBuilder(
                    bloc: _getCitiesCubit,
                    builder: (context, state) {
                      if (state is GetCitiesLoading) {
                        return const _CustomShimmer();
                      }
                      if (state is GetCitiesDone) {
                        List<DropDownValueModel> list = [];

                        for (var element in state.cityResponse.cities!) {
                          list.add(DropDownValueModel(
                              name: element.name!, value: element.id));
                        }
                        if (widget.update) {
                          _addressCityNameCubit
                              .save(widget.address?.cityId ?? -1);
                        }
                        return BlocBuilder(
                          bloc: _addressCityNameCubit,
                          builder: (context, state) {
                            return CustomDropDown(
                              list: list,
                              selected: widget.update
                                  ? widget.address?.cityId ==
                                      _addressCityNameCubit.state
                                  : _addressCityNameCubit.state == -1,
                              placeHolder: widget.update && shouldUpdate
                                  ? widget.address!.cityName!
                                  : context.resources.strings.city,
                              onChange: (val) {
                                if (val == "") {
                                  _addressCityNameCubit.save(-1);
                                } else {
                                  for (var element in list) {
                                    if (element == val) {
                                      _addressCityNameCubit.save(element.value);
                                    }
                                  }
                                }
                              },
                            );
                          },
                        );
                      }
                      if (state is GetCitiesError) {
                        return CustomErrorWidget(
                          onTap: () {
                            _getCitiesCubit
                                .getCities(_addressStateNameCubit.state);
                          },
                        );
                      }
                      return CustomTextField(
                          isAddress: true,
                          label: context.resources.strings.city,
                          onChange: (vale) {});
                    }),

                const FixedHieght(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.resources.dimension.lightElevation),
                  child: CustomTextField(
                    controller: zipCode,
                    isAddress: true,
                    onChange: (val) {
                      _addressZipCodeCubit.save(val);
                    },
                    label: context.resources.strings.zipCode,
                    textInputType: TextInputType.multiline,
                  ),
                ),
                const FixedHieght(),

                BlocBuilder(
                  bloc: _getCountriesCubit,
                  builder: (context, state) {
                    if (state is GetCountriesDone) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                context.resources.dimension.mediumMargin),
                        child: SizedBox(
                          height:
                              context.resources.dimension.textFieldHeight + 12,
                          child: PhoneTextField(
                            countries: [UserRepo().country],
                            textEditingController: _phoneController,
                            onInputChanged: (phone) {
                              // for (int i = 0;
                              //     i < state.countryResponse.countries!.length;
                              //     i++) {
                              //   // if (state.countryResponse.countries![i].code ==
                              //   //     phone.isoCode) {
                              //   //   _addressCountryNameCubit.save(
                              //   //       state.countryResponse.countries![i].id);
                              //   //   _getStatesCubit.getStates(
                              //   //       _addressCountryNameCubit.state);
                              //   // }
                              // }
                              _addressPhoneNumberCubit.save(
                                  phone.phoneNumber != null
                                      ? phone.phoneNumber!
                                      : "");
                            },
                            onInputValidated: (phone) {
                              _validationCubitPhone.save(phone);
                            },
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
                const FixedHieght(),

                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.resources.dimension.lightElevation),
                  child: CustomTextField(
                    controller: _addressController,
                    isAddress: true,
                    onChange: (value) {
                      _addressAddressNameCubit.save(value);
                    },
                    label: context.resources.strings.addressTitle,
                  ),
                ),
                // SizedBox(
                //   height: 600,
                //   child: GoogleMap(
                //     onMapCreated: _onMapCreated,
                //     mapType: _currentMapType,
                //     myLocationEnabled: true,
                //     markers: markers,
                //     onCameraMove: _onCameraMove,
                //     initialCameraPosition: CameraPosition(
                //       target: _center,
                //       zoom: 11.0,
                //     ),
                //     zoomControlsEnabled: false,
                //     zoomGesturesEnabled: false,
                //     scrollGesturesEnabled: false,
                //     compassEnabled: false,
                //     rotateGesturesEnabled: false,
                //     mapToolbarEnabled: false,
                //     tiltGesturesEnabled: false,
                //   ),
                // ),
                CustomButton(
                    onPress: enabled
                        ? () {
                            if (widget.update) {
                              if (_addressCityNameCubit.state == -1) {
                                fToast.showToast(
                                    child: ToastBody(
                                        icon: Icons.warning,
                                        text: context
                                            .resources.strings.chooseCity,
                                        iconColor: Theme.of(context)
                                            .colorScheme
                                            .redColor,
                                        bgColor: Theme.of(context)
                                            .colorScheme
                                            .toastBackGround,
                                        textColor: Theme.of(context)
                                            .colorScheme
                                            .primaryTextColor),
                                    gravity: ToastGravity.BOTTOM);
                              } else {
                                _addAddressCubit.updateAddress(
                                    id: widget.address?.id ?? -1,
                                    city: _addressCityNameCubit.state,
                                    country: _addressCountryNameCubit.state,
                                    address: _addressAddressNameCubit.state,
                                    state: _addressStateNameCubit.state,
                                    zipCode: _addressZipCodeCubit.state,
                                    phoneNumber:
                                        _addressPhoneNumberCubit.state);
                              }
                            } else {
                              if (_addressCountryNameCubit.state == -1) {
                                fToast.showToast(
                                    child: ToastBody(
                                        icon: Icons.warning,
                                        iconColor: Theme.of(context)
                                            .colorScheme
                                            .redColor,
                                        text: context
                                            .resources.strings.chooseCountry,
                                        bgColor: Theme.of(context)
                                            .colorScheme
                                            .toastBackGround,
                                        textColor: Theme.of(context)
                                            .colorScheme
                                            .primaryTextColor),
                                    gravity: ToastGravity.BOTTOM);
                              } else if (_addressStateNameCubit.state == -1) {
                                fToast.showToast(
                                    child: ToastBody(
                                        iconColor: Theme.of(context)
                                            .colorScheme
                                            .redColor,
                                        icon: Icons.warning,
                                        text: context
                                            .resources.strings.chooseState,
                                        bgColor: Theme.of(context)
                                            .colorScheme
                                            .toastBackGround,
                                        textColor: Theme.of(context)
                                            .colorScheme
                                            .primaryTextColor),
                                    gravity: ToastGravity.BOTTOM);
                              } else if (_addressCityNameCubit.state == -1) {
                                fToast.showToast(
                                    child: ToastBody(
                                        icon: Icons.warning,
                                        text: context
                                            .resources.strings.chooseCity,
                                        iconColor: Theme.of(context)
                                            .colorScheme
                                            .redColor,
                                        bgColor: Theme.of(context)
                                            .colorScheme
                                            .toastBackGround,
                                        textColor: Theme.of(context)
                                            .colorScheme
                                            .primaryTextColor),
                                    gravity: ToastGravity.BOTTOM);
                              } else if (_validationCubitPhone.state == false) {
                                fToast.showToast(
                                    child: ToastBody(
                                        icon: Icons.warning,
                                        text: context.resources.strings
                                            .pleaseEnterYourPhone,
                                        bgColor: Theme.of(context)
                                            .colorScheme
                                            .toastBackGround,
                                        iconColor: Theme.of(context)
                                            .colorScheme
                                            .redColor,
                                        textColor: Theme.of(context)
                                            .colorScheme
                                            .primaryTextColor),
                                    gravity: ToastGravity.BOTTOM);
                              } else {
                                setState(() {
                                  enabled = false;
                                });

                                _addAddressCubit.addAddress(
                                    city: _addressCityNameCubit.state,
                                    country: _addressCountryNameCubit.state,
                                    address: _addressAddressNameCubit.state,
                                    state: _addressStateNameCubit.state,
                                    zipCode: _addressZipCodeCubit.state,
                                    phoneNumber:
                                        _addressPhoneNumberCubit.state);
                              }
                            }
                          }
                        : () {
                            fToast.showToast(
                                child: ToastBody(
                                    text: context.resources.strings.loading,
                                    bgColor: Theme.of(context)
                                        .colorScheme
                                        .toastBackGround));
                          },
                    content: widget.update
                        ? context.resources.strings.update
                        : context.resources.strings.add)
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    fToast.removeCustomToast();
    fToast.removeQueuedCustomToasts();
    super.dispose();
  }
}

class _CustomShimmer extends StatelessWidget {
  const _CustomShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.resources.dimension.mediumMargin,
      ),
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.lamisColor.withOpacity(0.3),
        borderRadius: BorderRadius.all(
          Radius.circular(context.resources.dimension.lightElevation),
        ),
      ),
    );
  }
}
