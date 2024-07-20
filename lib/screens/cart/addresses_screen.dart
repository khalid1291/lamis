import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:lamis/cubits/address/update_map_location/update_map_location_cubit.dart';

import '../../cubits/cart/show_map_cubit.dart';
import '../../cubits/cubits.dart';
import '../../res/resources_export.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({Key? key}) : super(key: key);

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen>
    with SingleTickerProviderStateMixin {
  late GetUserAddressesCubit _getUserAddressesCubit;
  late SelectedAddressCubit _selectedAddressCubit;
  late PostSelectedAddresCubit _postSelectedAddresCubit;
  FToast fToast = FToast();
  late ShowMapCubit showMapCubit;
  var kInitialPosition = const LatLng(-33.8567844, 151.213108);
  late PickResult selectedPlace;

  late UpdateMapLocationCubit _updateMapLocationCubit;
  @override
  void initState() {
    _getUserAddressesCubit = GetUserAddressesCubit()..getAddresses();
    _selectedAddressCubit = SelectedAddressCubit(-1);
    _postSelectedAddresCubit = PostSelectedAddresCubit();
    showMapCubit = ShowMapCubit(false, -1);
    _updateMapLocationCubit = UpdateMapLocationCubit();
    fToast.init(context);
    super.initState();
  }

  @override
  void dispose() {
    fToast.removeCustomToast();
    fToast.removeQueuedCustomToasts();
    super.dispose();
  }

  Future<bool> _willPopCallback() async {
    Navigator.pop(context, true);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.lamisColor,
          shadowColor: Colors.transparent,
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: BlocListener<UpdateMapLocationCubit, UpdateMapLocationState>(
            bloc: _updateMapLocationCubit,
            listener: (context, state) {
              if (state is UpdateMapLocationDone) {
                fToast.showToast(
                    child: ToastBody(
                  text: state.response.message,
                  bgColor: Theme.of(context).colorScheme.toastBackGround,
                ));
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
              builder: (context, state) {
                return Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // the listener for sending requests on app button and the app button
                    BlocListener(
                      bloc: _postSelectedAddresCubit,
                      listener: (context, state) {
                        if (state is PostSelectedAddressLoading) {
                          fToast.showToast(
                              child: ToastBody(
                            text: context.resources.strings.loading,
                            bgColor:
                                Theme.of(context).colorScheme.toastBackGround,
                          ));
                        }
                        if (state is PostSelectedAddressMessage) {
                          if (state.generalResponse.result) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CheckoutScreen(
                                postSelectedAddresCubit:
                                    PostSelectedAddresCubit(),
                              );
                            }));
                            // _checkOutCartCubit.checkout(
                            //     UserRepo().user.id, _choosedPaymentMethodCubit.state);
                          } else {
                            fToast.showToast(
                                child: ToastBody(
                              iconColor: state.generalResponse.result
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryTextColor
                                  : Theme.of(context).colorScheme.redColor,
                              text: state.generalResponse.message,
                              bgColor:
                                  Theme.of(context).colorScheme.toastBackGround,
                              icon: state.generalResponse.result
                                  ? Icons.done_all
                                  : Icons.error_outline,
                            ));
                          }
                        }
                      },
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: AppButton(
                          buttonSize: ButtonSize.big,
                          padding:
                              context.resources.dimension.extraHighElevation,
                          onTap: () {
                            if (_selectedAddressCubit.state != -1) {
                              _postSelectedAddresCubit
                                  .addAddress(_selectedAddressCubit.state);
                            } else {
                              fToast.showToast(
                                  child: ToastBody(
                                      text: context
                                          .resources.strings.chooseAddress,
                                      bgColor: Theme.of(context)
                                          .colorScheme
                                          .toastBackGround,
                                      iconColor: Theme.of(context)
                                          .colorScheme
                                          .redColor,
                                      textColor: Theme.of(context)
                                          .colorScheme
                                          .background),
                                  gravity: ToastGravity.BOTTOM);
                            }
                          },
                          buttonText: context.resources.strings.continues,
                        ),
                      ),
                      // ),
                    ),
                    // the container in background with primary color
                    Container(
                      height:
                          context.resources.dimension.middleContainerSize * 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            context.resources.dimension.bigMargin),
                        color: Theme.of(context).colorScheme.lamisColor,
                      ),
                    ),
                    // the main content of the page
                    Align(
                      alignment: Alignment.center,
                      child: LeaveContainerWithShadow(
                        height: MediaQuery.of(context).size.height / 1.5,
                        widget: ListView(
                          children: [
                            BlocBuilder<GetUserAddressesCubit,
                                GetUserAddressesState>(
                              bloc: _getUserAddressesCubit,
                              builder: (context, state) {
                                if (state is GetUserAddressesLoading) {
                                  return ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: 2,
                                      itemBuilder: (context, index) {
                                        return DelayedAnimation(
                                            delay: index * 150,
                                            child: const AddressCardShimmer()
                                                .customMargins());
                                      });
                                }
                                if (state is GetUserAddressesDone) {
                                  if (state
                                      .addressResponse.addresses!.isEmpty) {
                                    return CustomText(
                                      content: context
                                          .resources.strings.noAddressPleaseAdd,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryTextColor,
                                      titletype: TitleType.bottoms,
                                      language: Language.center,
                                    );
                                  } else {
                                    return ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: state
                                            .addressResponse.addresses!.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              _selectedAddressCubit.save(state
                                                  .addressResponse
                                                  .addresses![index]
                                                  .id!);
                                            },
                                            child: DelayedAnimation(
                                              delay: index * 150,
                                              child: BlocBuilder(
                                                bloc: _selectedAddressCubit,
                                                builder: (context, substate) {
                                                  return SizedBox(
                                                    width: 200,
                                                    child: AddressCard(
                                                      mapTapped: () {
                                                        kInitialPosition = LatLng(
                                                            state
                                                                .addressResponse
                                                                .addresses![
                                                                    index]
                                                                .lat!,
                                                            state
                                                                .addressResponse
                                                                .addresses![
                                                                    index]
                                                                .lang!);

                                                        showMapCubit.save(
                                                            true,
                                                            state
                                                                .addressResponse
                                                                .addresses![
                                                                    index]
                                                                .id!);
                                                      },
                                                      willPop: () {
                                                        _getUserAddressesCubit
                                                            .getAddresses();
                                                      },
                                                      address: state
                                                          .addressResponse
                                                          .addresses![index],
                                                      selected: state
                                                              .addressResponse
                                                              .addresses![index]
                                                              .id ==
                                                          _selectedAddressCubit
                                                              .state,
                                                    ),
                                                  );
                                                },
                                              ).customMargins(),
                                            ),
                                          );
                                        });
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: 3,
                                    itemBuilder: (context, index) {
                                      return const AddressCardShimmer()
                                          .customMargins();
                                    });
                              },
                            ),
                            AppButton(
                                    onTap: () async {
                                      var res = await BottomSheets.showModal(
                                          context,
                                          type: BottomSheetType.big,
                                          hasBorderMargin: true,
                                          child: const UserInformationScreen());
                                      if (res) {
                                        _getUserAddressesCubit.getAddresses();
                                      }
                                    },
                                    buttonText:
                                        context.resources.strings.addAddress)
                                .customMargins(),
                          ],
                        ),
                      ),
                    ),

                    if (state != null && state == true)
                      PlacePicker(
                          apiKey: "AIzaSyA8ZlmtftOOcArnSdQj6tIKerJQS_B0kLk",
                          hintText: "Find a place ...",
                          searchingText: context.resources.strings.loading,
                          selectText: context.resources.strings.selectPlace,
                          outsideOfPickAreaText:
                              context.resources.strings.placeIsNotInTheArea,
                          initialPosition: kInitialPosition,
                          useCurrentLocation:
                              showMapCubit.id == -1 ? true : false,
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
}
