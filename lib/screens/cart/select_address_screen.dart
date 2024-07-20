import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:lamis/cubits/cart/cart_date_picker_cubit.dart';
import 'package:lamis/cubits/cart/show_loader_cubit.dart';
import 'package:lamis/cubits/cubits.dart';
import 'package:lamis/cubits/order/valid_time_cubit.dart';
import 'package:lamis/res/resources_export.dart';
import 'package:lamis/screens/screens.dart';
import 'package:lamis/widgets/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import '../../cubits/address/update_map_location/update_map_location_cubit.dart';
import '../../cubits/cart/show_map_cubit.dart';

class SelectAddressScreen extends StatefulWidget {
  const SelectAddressScreen({Key? key}) : super(key: key);

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen>
    with SingleTickerProviderStateMixin {
  late ShowLoaderCubit _showLoaderCubit;
  late GetUserAddressesCubit _getUserAddressesCubit;
  late SelectedAddressCubit _selectedAddressCubit;
  late PostSelectedAddresCubit _postSelectedAddresCubit;
  late DeliveryMethodsCubit _deliveryMethodsCubit;
  late SelectedCategoriesCubit selectedDeliveryCubit;
  late ShowHideSectionCubit showHideSectionCubit;
  late SaveDeliveryMethodsCubit _saveDeliveryMethodsCubit;
  late CartDatePickerCubit _cartDatePickerCubit;
  late UpdateMapLocationCubit _updateMapLocationCubit;
  late ValidTimeCubit _validTimeCubit;

  FToast fToast = FToast();

  late AnimationController _controller;
  late List<Bubble> bubbles;
  final int numberOfBubbles = 75;
  final Color color = const Color(0xFF8EC3DF);
  final double maxBubbleSize = 75.0;

  void updateBubblePosition() {
    for (var it in bubbles) {
      it.updatePosition();
    }
    setState(() {});
  }

  late ShowMapCubit showMapCubit;
  var kInitialPosition = const LatLng(-33.8567844, 151.213108);
  late PickResult selectedPlace;
  @override
  void initState() {
    showMapCubit = ShowMapCubit(false, -1);
    _showLoaderCubit = ShowLoaderCubit(false);
    _getUserAddressesCubit = GetUserAddressesCubit()..getAddresses();
    _selectedAddressCubit = SelectedAddressCubit(-1);
    _postSelectedAddresCubit = PostSelectedAddresCubit();
    _deliveryMethodsCubit = DeliveryMethodsCubit();
    _deliveryMethodsCubit.getDeliveryMethods();
    fToast.init(context);
    bubbles = [];
    selectedDeliveryCubit = SelectedCategoriesCubit(1);
    showHideSectionCubit = ShowHideSectionCubit(false);
    _saveDeliveryMethodsCubit = SaveDeliveryMethodsCubit();
    _cartDatePickerCubit = CartDatePickerCubit("");
    _validTimeCubit = ValidTimeCubit(true);
    _controller2.text = convertedDateTime;

    int i = numberOfBubbles;
    while (i > 0) {
      bubbles.add(Bubble(color, maxBubbleSize));
      i--;
    }
    _updateMapLocationCubit = UpdateMapLocationCubit();

    // Init animation controller

    super.initState();
  }

  Future<bool> _willPopCallback() async {
    Navigator.pop(context, true);
    return Future.value(false);
  }

  double myWalletBallance = 0.0;
  double grandTotalValue = 0.0;

  String convertedDateTime =
      "${(DateTime.now().day + 2).toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year.toString()}";

  final TextEditingController _controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: CustomAppBar(
          title: context.resources.strings.addressAndTime,
        ),
        resizeToAvoidBottomInset: true,
        body: BlocListener(
          bloc: _showLoaderCubit,
          listener: (context, state) {},
          child: BlocListener<UpdateMapLocationCubit, UpdateMapLocationState>(
            bloc: _updateMapLocationCubit,
            listener: (context, state) {
              if (state is UpdateMapLocationDone) {
                fToast.showToast(
                    child: ToastBody(
                  text: state.response.message,
                  bgColor: Theme.of(context).colorScheme.toastBackGround,
                ));
                _getUserAddressesCubit.getAddresses();
              }
              if (state is UpdateMapLocationError) {
                fToast.showToast(
                    child: ToastBody(
                  text: state.message,
                  bgColor: Theme.of(context).colorScheme.toastBackGround,
                  iconColor: Theme.of(context).colorScheme.redColor,
                ));
              }
            },
            child: BlocBuilder(
              bloc: showMapCubit,
              builder: (context, mapState) {
                return Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView(
                        children: [
                          const FixedHieght(),
                          // the container in background with primary color
                          addresses(),
                          const FixedHieght(
                            extra: true,
                          ),

                          const FixedHieght(
                            extra: true,
                          ),
                          // the main content of the page
                          BlocListener(
                            bloc: _saveDeliveryMethodsCubit,
                            listener: (context, state) {
                              if (state is SaveDeliveryMethodsDone) {
                                var res = Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return CheckoutScreen(
                                    postSelectedAddresCubit:
                                        _postSelectedAddresCubit,
                                  );
                                }));
                                // ignore: unnecessary_null_comparison
                                if (res != null) {}
                              } else if (state is SaveDeliveryMethodsError) {
                                fToast.showToast(
                                    child: ToastBody(
                                      text: state.message,
                                      bgColor: Theme.of(context)
                                          .colorScheme
                                          .toastBackGround,
                                      textColor: Theme.of(context)
                                          .colorScheme
                                          .primaryTextColor,
                                      iconColor: Theme.of(context)
                                          .colorScheme
                                          .redColor,
                                    ),
                                    gravity: ToastGravity.BOTTOM);
                              }
                            },
                            child: Container(),
                          ),
                          BlocBuilder(
                              bloc: _deliveryMethodsCubit,
                              builder: (context, state) {
                                if (state is DeliveryMethodsDone) {
                                  return Column(
                                    children: [
                                      CustomText(
                                        content: context
                                            .resources.strings.deliveryMethod,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .lamisColor,
                                        titletype: TitleType.subtitle,
                                      ),
                                      const FixedHieght(),
                                      BlocBuilder(
                                        bloc: selectedDeliveryCubit,
                                        builder: (context, states) {
                                          return Container(
                                              height: 160,
                                              color: Colors.transparent,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount:
                                                    state.response.data.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return DelayedAnimation(
                                                    fromSide: FromSide.right,
                                                    delay: 200 * index,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        HapticFeedback
                                                            .heavyImpact();
                                                        selectedDeliveryCubit
                                                            .save(state
                                                                .response
                                                                .data[index]
                                                                .id);
                                                        if (selectedDeliveryCubit
                                                                .state ==
                                                            2) {
                                                          showHideSectionCubit
                                                              .save(true);
                                                          _validTimeCubit
                                                              .save(false);
                                                        } else {
                                                          showHideSectionCubit
                                                              .save(false);
                                                          _validTimeCubit
                                                              .save(true);
                                                        }
                                                      },
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 30,
                                                            height: 45,
                                                            child: NeumorphismContainer(
                                                                child: selectedDeliveryCubit.state == state.response.data[index].id
                                                                    ? Icon(
                                                                        Icons
                                                                            .check_outlined,
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .lamisColor,
                                                                      )
                                                                    : const SizedBox(
                                                                        height:
                                                                            25,
                                                                        width:
                                                                            25,
                                                                      )),
                                                          ),
                                                          SizedBox(
                                                            width: context
                                                                .resources
                                                                .dimension
                                                                .smallMargin,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              CustomText(
                                                                content: state
                                                                    .response
                                                                    .data[index]
                                                                    .name,
                                                                titletype:
                                                                    TitleType
                                                                        .bottoms,
                                                              ),
                                                              CustomText(
                                                                content:
                                                                    deliveryTime(
                                                                        index),
                                                                titletype:
                                                                    TitleType
                                                                        .time,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ));
                                        },
                                      ).customMargins(),
                                      BlocBuilder(
                                        bloc: _cartDatePickerCubit,
                                        builder: (context, state) {
                                          return BlocBuilder(
                                            bloc: showHideSectionCubit,
                                            builder: (context, state) {
                                              if (state == true) {
                                                return SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                  child: Column(
                                                    children: [
                                                      CustomText(
                                                        content: context
                                                            .resources
                                                            .strings
                                                            .deliveryDate,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .lamisColor,
                                                        titletype:
                                                            TitleType.subtitle,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 20),
                                                        child: GestureDetector(
                                                            onTap: () async {
                                                              DateTime? date =
                                                                  await showDatePicker(
                                                                      context:
                                                                          context,
                                                                      initialDate: DateTime.now().add(const Duration(
                                                                          days:
                                                                              2)),
                                                                      firstDate: DateTime.now().add(const Duration(
                                                                          days:
                                                                              2)),
                                                                      lastDate: DateTime(
                                                                          DateTime.now()
                                                                              .year,
                                                                          DateTime.now().month +
                                                                              2),
                                                                      currentDate: DateTime.now().add(const Duration(
                                                                          days:
                                                                              2)),
                                                                      initialEntryMode:
                                                                          DatePickerEntryMode
                                                                              .calendarOnly,
                                                                      initialDatePickerMode:
                                                                          DatePickerMode
                                                                              .day,
                                                                      builder:
                                                                          (context,
                                                                              child) {
                                                                        return Theme(
                                                                          data:
                                                                              ThemeData(
                                                                            textButtonTheme:
                                                                                TextButtonThemeData(
                                                                              style: TextButton.styleFrom(
                                                                                foregroundColor: Theme.of(context).colorScheme.primary,
                                                                              ),
                                                                            ),
                                                                            dialogTheme:
                                                                                DialogTheme(
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(
                                                                                  14,
                                                                                ), // this is the border radius of the picker
                                                                              ),
                                                                            ),
                                                                            splashColor:
                                                                                Theme.of(context).colorScheme.primary,
                                                                            colorScheme:
                                                                                ColorScheme.light(
                                                                              primary: Theme.of(context).colorScheme.primary,
                                                                              // onPrimary: ColorManager.white,
                                                                              inverseSurface: Theme.of(context).colorScheme.productColor,
                                                                            ),

                                                                            // inputDecorationTheme: const InputDecorationTheme(
                                                                            //   filled: true,
                                                                            //   fillColor: Colors.white,
                                                                            // ),
                                                                            dialogBackgroundColor:
                                                                                Theme.of(context).colorScheme.productColor,
                                                                          ),
                                                                          child:
                                                                              child!,
                                                                        );
                                                                      });

                                                              // if (date!.isBefore(DateTime(
                                                              //     DateTime.now().year,
                                                              //     DateTime.now().month,
                                                              //     DateTime.now().day - 1))) {
                                                              //   errorToast(AppStrings
                                                              //       .cantChoosePastDate
                                                              //       .tr());
                                                              //   validTimeCubit.save(false);
                                                              // } else {
                                                              String
                                                                  formattedDate =
                                                                  DateFormat(
                                                                          'dd/MM/yy',
                                                                          "en")
                                                                      .format(
                                                                          date!);

                                                              _validTimeCubit
                                                                  .save(true);

                                                              _cartDatePickerCubit
                                                                  .save(
                                                                      formattedDate);

                                                              // }
                                                              _controller2
                                                                      .text =
                                                                  "${date.year}-${date.month}-${date.day}";
                                                            },
                                                            child:
                                                                CustomTextField(
                                                              controller:
                                                                  _controller2,
                                                              label:
                                                                  _controller2
                                                                      .text,
                                                              onChange:
                                                                  (value) {},
                                                              enabled: false,
                                                            )
                                                            // H2allTextField(
                                                            //   isDatePicker: true,
                                                            //   hasOutlineBorderRadius: true,
                                                            //   isNeedDirection: false,
                                                            //   iconEmailInUserD: true,
                                                            //   icon: IconButton(
                                                            //     onPressed: () {},
                                                            //     icon: Icon(
                                                            //         Icons
                                                            //             .calendar_today_outlined,
                                                            //         color: Theme.of(context)
                                                            //             .colorScheme
                                                            //             .iconColor),
                                                            //   ),
                                                            //   enabled: false,
                                                            //   hint: AppStrings.date.tr(),
                                                            //   // hint: ctx.user.dateOfBirth ==
                                                            //   //         Constants.empty
                                                            //   //     ? AppStrings.dataOfBirth.tr()
                                                            //   //     : fixShowDate(ctx.user.dateOfBirth),
                                                            //   controller: _dateOfDelivery,
                                                            //   onInputChanged: (vale) {},
                                                            //   onInputValidated: null,
                                                            //   noPadding: true,
                                                            // ),
                                                            ),
                                                      ),
                                                      // Directionality(
                                                      //     textDirection:
                                                      //         TextDirection.ltr,
                                                      //     child: Theme(
                                                      //       data: ThemeData(
                                                      //         textButtonTheme:
                                                      //             TextButtonThemeData(
                                                      //           style: TextButton
                                                      //               .styleFrom(
                                                      //             foregroundColor: Theme.of(
                                                      //                     context)
                                                      //                 .colorScheme
                                                      //                 .primary,
                                                      //           ),
                                                      //         ),
                                                      //         dialogTheme:
                                                      //             DialogTheme(
                                                      //           shape:
                                                      //               RoundedRectangleBorder(
                                                      //             borderRadius:
                                                      //                 BorderRadius
                                                      //                     .circular(
                                                      //               14,
                                                      //             ), // this is the border radius of the picker
                                                      //           ),
                                                      //         ),
                                                      //         splashColor: Theme
                                                      //                 .of(context)
                                                      //             .colorScheme
                                                      //             .primary,
                                                      //         colorScheme:
                                                      //             ColorScheme
                                                      //                 .light(
                                                      //           primary: Theme.of(
                                                      //                   context)
                                                      //               .colorScheme
                                                      //               .primary,
                                                      //           // onPrimary: ColorManager.white,
                                                      //           inverseSurface: Theme.of(
                                                      //                   context)
                                                      //               .colorScheme
                                                      //               .productColor,
                                                      //         ),
                                                      //
                                                      //         // inputDecorationTheme: const InputDecorationTheme(
                                                      //         //   filled: true,
                                                      //         //   fillColor: Colors.white,
                                                      //         // ),
                                                      //         dialogBackgroundColor:
                                                      //             Theme.of(
                                                      //                     context)
                                                      //                 .colorScheme
                                                      //                 .productColor,
                                                      //       ),
                                                      //       child:
                                                      //           DateTimePicker(
                                                      //         type:
                                                      //             DateTimePickerType
                                                      //                 .date,
                                                      //         dateMask:
                                                      //             'dd/MM/yy',
                                                      //         controller:
                                                      //             _controller2,
                                                      //
                                                      //         ini
                                                      //         // initialDate:
                                                      //         // DateTime
                                                      //         //     .now()
                                                      //         //     .add(const Duration(
                                                      //         //     days: 2)),
                                                      //         firstDate: DateTime
                                                      //                 .now()
                                                      //             .add(const Duration(
                                                      //                 days: 2)),
                                                      //         lastDate:
                                                      //             DateTime(
                                                      //                 2100),
                                                      //         use24HourFormat:
                                                      //             true,
                                                      //         locale:
                                                      //             const Locale(
                                                      //                 'en', ''),
                                                      //         textAlign:
                                                      //             TextAlign
                                                      //                 .center,
                                                      //
                                                      //         onChanged: (val) {
                                                      //           var parsedDate =
                                                      //               DateTime
                                                      //                   .parse(
                                                      //                       val);
                                                      //           if (parsedDate
                                                      //               .isBefore(
                                                      //                   DateTime(
                                                      //             DateTime.now()
                                                      //                 .year,
                                                      //             DateTime.now()
                                                      //                 .month,
                                                      //             DateTime.now()
                                                      //                     .day +
                                                      //                 2,
                                                      //           ))) {
                                                      //             fToast.showToast(
                                                      //                 child: ToastBody(
                                                      //                     text: context
                                                      //                         .resources
                                                      //                         .strings
                                                      //                         .youCantSelectOldTime,
                                                      //                     bgColor: Theme.of(context)
                                                      //                         .colorScheme
                                                      //                         .toastBackGround));
                                                      //             _validTimeCubit
                                                      //                 .save(
                                                      //                     false);
                                                      //           } else {
                                                      //             _validTimeCubit
                                                      //                 .save(
                                                      //                     true);
                                                      //
                                                      //             _cartDatePickerCubit
                                                      //                 .save(
                                                      //                     val);
                                                      //           }
                                                      //         },
                                                      //         // validator: (val) {
                                                      //         //   setState(() => _valueToValidate2 = val ?? '');
                                                      //         //   return null;
                                                      //         // },
                                                      //         onSaved: (val) =>
                                                      //             _cartDatePickerCubit
                                                      //                 .save(
                                                      //                     val!),
                                                      //       ),
                                                      //     )
                                                      const FixedHieght(
                                                        extra: true,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                              return const SizedBox(
                                                height: 100,
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     _selectDate(context);
                                      //   },
                                      //   child: CustomText(
                                      //     content: selectedDate.toString(),
                                      //   ),
                                      // )
                                    ],
                                  );
                                }
                                return Container();
                              }),

                          // the listener for sending requests on app button and the app button
                          GestureDetector(
                            onTap: () async {
                              HapticFeedback.heavyImpact();
                              if (_validTimeCubit.state) {
                                if (_selectedAddressCubit.state != -1) {
                                  _postSelectedAddresCubit
                                      .addAddress(_selectedAddressCubit.state);
                                  _saveDeliveryMethodsCubit.saveDeliveryMethods(
                                      selectedDeliveryCubit.state,
                                      _controller2.text);
                                  // var res = await Navigator.push(context,
                                  //     MaterialPageRoute(builder: (context) {
                                  //   return CheckoutScreen(
                                  //     postSelectedAddresCubit: _postSelectedAddresCubit,
                                  //   );
                                  // }));
                                  // ignore: unnecessary_null_comparison
                                  // if (res != null) {}
                                } else {
                                  fToast.showToast(
                                      child: ToastBody(
                                        text: context
                                            .resources.strings.chooseAddress,
                                        bgColor: Theme.of(context)
                                            .colorScheme
                                            .toastBackGround,
                                        textColor: Theme.of(context)
                                            .colorScheme
                                            .primaryTextColor,
                                        iconColor: Theme.of(context)
                                            .colorScheme
                                            .redColor,
                                      ),
                                      gravity: ToastGravity.BOTTOM);
                                }
                              } else {
                                fToast.showToast(
                                    child: ToastBody(
                                      text: context.resources.strings
                                          .youCantSelectOldTime,
                                      bgColor: Theme.of(context)
                                          .colorScheme
                                          .toastBackGround,
                                      textColor: Theme.of(context)
                                          .colorScheme
                                          .primaryTextColor,
                                      iconColor: Theme.of(context)
                                          .colorScheme
                                          .redColor,
                                    ),
                                    gravity: ToastGravity.BOTTOM);
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: context
                                      .resources.dimension.extraHighElevation),
                              child: SizedBox(
                                height: 65,
                                width: MediaQuery.of(context).size.width * 0.66,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .lamisColor,
                                      borderRadius: BorderRadius.circular(
                                          context.resources.dimension
                                              .defaultMargin)),
                                  child: Center(
                                    child: CustomText(
                                      content:
                                          context.resources.strings.continues,
                                      titletype: TitleType.bottoms,
                                      color: context.resources.color.colorWhite,
                                      language: Language.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const FixedHieght(),
                        ],
                      ),
                    ),
                    if (_showLoaderCubit.state)
                      Container(
                        color: Theme.of(context)
                            .colorScheme
                            .scaffoldColor
                            .withOpacity(0.5),
                        child: CustomPaint(
                          foregroundPainter: BubblePainter(
                              bubbles: bubbles, controller: _controller),
                          size: Size(MediaQuery.of(context).size.width,
                              MediaQuery.of(context).size.height),
                        ),
                      ),
                    if (mapState != null && mapState == true)
                      PlacePicker(
                          apiKey: "AIzaSyA8ZlmtftOOcArnSdQj6tIKerJQS_B0kLk",
                          hintText: "Find a place ...",
                          searchingText: context.resources.strings.loading,
                          selectText: context.resources.strings.selectPlace,
                          outsideOfPickAreaText:
                              context.resources.strings.placeIsNotInTheArea,
                          initialPosition: kInitialPosition,
                          useCurrentLocation:
                              // ignore: unnecessary_null_comparison
                              kInitialPosition.latitude == null ? true : false,
                          selectInitialPosition: true,
                          usePinPointingSearch: true,
                          usePlaceDetailSearch: true,
                          zoomGesturesEnabled: true,
                          zoomControlsEnabled: true,
                          onPlacePicked: (PickResult result) {
                            selectedPlace = result;

                            _updateMapLocationCubit.updateMapAddress(
                                showMapCubit.id,
                                selectedPlace.geometry!.location.lng,
                                selectedPlace.geometry!.location.lat);

                            showMapCubit.save(false, -1);
                          },
                          onTapBack: () {
                            showMapCubit.save(false, -1);
                          }),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String deliveryTime(int index) {
    if (index == 0) {
      return context.resources.strings.immediateDelivery;
    }
    if (index == 2) {
      return context.resources.strings.withinDelivery;
    }
    if (index == 1) {
      return context.resources.strings.pickDate;
    }
    return "";
  }

  @override
  void dispose() {
    _controller.dispose();
    fToast.removeCustomToast();
    fToast.removeQueuedCustomToasts();

    super.dispose();
  }

  Widget addresses() {
    return BlocBuilder<GetUserAddressesCubit, GetUserAddressesState>(
      bloc: _getUserAddressesCubit,
      builder: (context, state) {
        if (state is GetUserAddressesLoading) {
          return SizedBox(
            height: 200,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return DelayedAnimation(
                      delay: index * 150,
                      child: const AddressCardShimmer().customMargins());
                }),
          );
        }
        if (state is GetUserAddressesDone) {
          if (state.addressResponse.addresses!.isEmpty) {
            return Row(
              children: [
                PlusButton(
                  onPressed: () async {
                    var res = await BottomSheets.showModal(context,
                        type: BottomSheetType.big,
                        hasBorderMargin: true,
                        child: const UserInformationScreen());
                    if (res) {
                      _getUserAddressesCubit.getAddresses();
                    }
                  },
                ),
                const SizedBox(
                  width: 40,
                ),
                Center(
                  child: Column(
                    children: [
                      CustomText(
                        content: context.resources.strings.noAddressPleaseAdd,
                        color: Theme.of(context).colorScheme.primaryTextColor,
                        titletype: TitleType.bottoms,
                        language: Language.center,
                      ),
                      Icon(
                        Icons.arrow_back,
                        size: 40,
                        // AssetImage(context.resources.images.leftArrow),
                        color: Theme.of(context).colorScheme.lamisColor,
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Row(
              children: [
                PlusButton(
                  onPressed: () async {
                    var res = await BottomSheets.showModal(context,
                        type: BottomSheetType.big,
                        hasBorderMargin: true,
                        child: const UserInformationScreen());
                    if (res) {
                      _getUserAddressesCubit.getAddresses();
                    }
                  },
                ),
                SizedBox(
                  height: 210,
                  width: MediaQuery.of(context).size.width - 60,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: state.addressResponse.addresses!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.heavyImpact();
                            _selectedAddressCubit.save(
                                state.addressResponse.addresses![index].id!);
                          },
                          child: DelayedAnimation(
                            delay: index * 150,
                            fromSide: FromSide.right,
                            child: BlocBuilder(
                              bloc: _selectedAddressCubit,
                              builder: (context, substate) {
                                return AddressCard(
                                  mapTapped: () {
                                    kInitialPosition = LatLng(
                                        state.addressResponse.addresses![index]
                                            .lat!,
                                        state.addressResponse.addresses![index]
                                            .lang!);
                                    showMapCubit.save(
                                        true,
                                        state.addressResponse.addresses![index]
                                            .id!);
                                  },
                                  willPop: () {
                                    _getUserAddressesCubit.getAddresses();
                                  },
                                  address:
                                      state.addressResponse.addresses![index],
                                  selected: state.addressResponse
                                          .addresses![index].id ==
                                      _selectedAddressCubit.state,
                                  small: true,
                                );
                              },
                            ).customMargins(),
                          ),
                        );
                      }),
                ),
              ],
            );
          }
        }
        if (state is GetUserAddressesError) {
          return CustomErrorWidget(
            onTap: () {
              _getUserAddressesCubit.getAddresses();
            },
          );
        }
        return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (context, index) {
              return const AddressCardShimmer().customMargins();
            });
      },
    );
  }
}

class PlusButton extends StatelessWidget {
  const PlusButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        onPressed();
      },
      child: Container(
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
        width: 50,
        height: 180,
        child: Center(
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.lamisColor,
          ),
        ),
      ),
    );
  }
}

class CardTypShimmer extends StatelessWidget {
  const CardTypShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(context.resources.dimension.highElevation),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      context.resources.dimension.bigMargin),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.cardColor)),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                            context.resources.dimension.bigMargin),
                        topRight: Radius.circular(
                            context.resources.dimension.bigMargin),
                      ),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.cardColor),
                      color: Theme.of(context).colorScheme.cardColor,
                    ),
                    height: context.resources.dimension.priceContainer,
                    width: context.resources.dimension.middleContainerSize,
                  ),
                  CustomText(
                    content: "",
                    titletype: TitleType.subtitle,
                    color: Theme.of(context).colorScheme.primaryTextColor,
                  ),
                ],
              ),
            ),
          );
        });
  }
}

// class _PaymentCard extends StatelessWidget {
//   const _PaymentCard({
//     Key? key,
//     required this.index,
//     required this.paymentTypeResponse,
//     required this.selected,
//   }) : super(key: key);
//   final int index;
//   final PaymentTypeResponse paymentTypeResponse;
//   final SelectedPaymentMethodCubit selected;
//   @override
//   Widget build(BuildContext context) {
//     return DelayedAnimation(
//       delay: index * 150,
//       fromSide: FromSide.right,
//       child: Padding(
//         padding: EdgeInsets.all(context.resources.dimension.highElevation),
//         child: BlocBuilder(
//           bloc: selected,
//           builder: (context, state) {
//             return AnimatedContainer(
//               duration: const Duration(milliseconds: 400),
//               padding:
//                   EdgeInsets.all(context.resources.dimension.lightElevation),
//               decoration: BoxDecoration(
//                 boxShadow: selected.state == paymentTypeResponse.paymentTypeKey
//                     ? [
//                         BoxShadow(
//                             color: Theme.of(context).colorScheme.shadow400,
//                             offset: const Offset(4, 4),
//                             blurRadius: 10,
//                             spreadRadius: 1),
//                         BoxShadow(
//                             color: Theme.of(context).colorScheme.shadow400,
//                             offset: const Offset(3, 3),
//                             blurRadius: 10,
//                             spreadRadius: 1),
//                         BoxShadow(
//                             color: Theme.of(context).colorScheme.shadow200,
//                             offset: const Offset(-3, -3),
//                             blurRadius: 10,
//                             spreadRadius: 1),
//                         BoxShadow(
//                             color: Theme.of(context).colorScheme.shadow100,
//                             offset: const Offset(-4, -4),
//                             blurRadius: 10,
//                             spreadRadius: 1),
//                       ]
//                     : [],
//                 borderRadius: BorderRadius.circular(
//                     context.resources.dimension.bigMargin),
//               ),
//               child: ClipRRect(
//                 clipBehavior: Clip.hardEdge,
//                 borderRadius: BorderRadius.circular(16),
//                 child: CachedNetworkImage(
//                   height: 100,
//                   imageUrl: paymentTypeResponse.image ?? '',
//                   fadeOutDuration: const Duration(seconds: 1),
//                   fadeInDuration: const Duration(seconds: 3),
//                   errorWidget: (context, url, error) => Image(
//                     image: AssetImage(
//                       context.resources.images.noProduct,
//                     ),
//                     height: 100,
//                     width: 100,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
