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
import '../cart/user_information_screen.dart';
import '../home/home_screen.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  late final GetUserAddressesCubit _getUserAddressesCubit;
  late final UpdateMapLocationCubit _updateMapLocationCubit;
  @override
  void initState() {
    showMapCubit = ShowMapCubit(false, -1);
    _updateMapLocationCubit = UpdateMapLocationCubit();
    _getUserAddressesCubit = GetUserAddressesCubit()..getAddresses();
    fToast.init(context);
    super.initState();
  }

  late ShowMapCubit showMapCubit;
  var kInitialPosition = const LatLng(-33.8567844, 151.213108);
  late PickResult selectedPlace;
  FToast fToast = FToast();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
      appBar: CustomAppBar(
        title: context.resources.strings.address,
      ),
      body: BlocListener<UpdateMapLocationCubit, UpdateMapLocationState>(
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
          builder: (context, state) {
            return Stack(
              children: [
                ListView(children: [
                  // CustomText(
                  //   content: context.resources.strings.address,
                  //   titletype: TitleType.subtitle,
                  //   language: Language.center,
                  // ),
                  BlocBuilder<GetUserAddressesCubit, GetUserAddressesState>(
                    bloc: _getUserAddressesCubit,
                    builder: (context, state) {
                      if (state is GetUserAddressesLoading) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 200,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return DelayedAnimation(
                                    delay: index * 150,
                                    child: const AddressCardShimmer()
                                        .customMargins());
                              }),
                        );
                      }
                      if (state is GetUserAddressesDone) {
                        if (state.addressResponse.addresses!.isEmpty) {
                          return Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: context
                                      .resources.dimension.largeContainerSize,
                                  width: MediaQuery.of(context).size.width,
                                  child: Image(
                                    image: AssetImage(
                                      context.resources.images.noDataImage,
                                    ),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                const FixedHieght(
                                  extra: true,
                                )
                              ],
                            ),
                          );
                        } else {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 200,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    state.addressResponse.addresses!.length,
                                itemBuilder: (context, index) {
                                  return DelayedAnimation(
                                    delay: index * 200,
                                    fromSide: FromSide.bottom,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: context.resources.dimension
                                              .veryHighElevation,
                                          right: context.resources.dimension
                                              .veryHighElevation),
                                      child: SizedBox(
                                        height: 200,
                                        child: AddressCard(
                                          mapTapped: () {
                                            kInitialPosition = LatLng(
                                                state.addressResponse
                                                    .addresses![index].lat!,
                                                state.addressResponse
                                                    .addresses![index].lang!);
                                            showMapCubit.save(
                                                true,
                                                state.addressResponse
                                                    .addresses![index].id!);
                                          },
                                          willPop: () {
                                            _getUserAddressesCubit
                                                .getAddresses();
                                          },
                                          address: state.addressResponse
                                              .addresses![index],
                                        ).customMargins(),
                                      ),
                                    ),
                                  );
                                }),
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
                  ),
                  CustomButton(
                      onPress: () async {
                        var res = await BottomSheets.showModal(context,
                            type: BottomSheetType.big,
                            hasBorderMargin: true,
                            child: const UserInformationScreen());
                        if (res) {
                          _getUserAddressesCubit.getAddresses();
                        }
                      },
                      content: context.resources.strings.addAddress),
                  const FixedHieght(
                    extra: true,
                  )
                ]),
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
    );
  }
}

// class _AddressCard extends StatelessWidget {
//   const _AddressCard({
//     Key? key,
//     required this.address,
//     this.selected = false,
//   }) : super(key: key);
//
//   final Address address;
//   final bool selected;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         height: context.resources.dimension.middleContainerSize * 1.6,
//         margin: EdgeInsets.symmetric(
//             vertical: context.resources.dimension.mediumMargin),
//         padding: EdgeInsets.symmetric(
//             vertical: context.resources.dimension.mediumMargin),
//         // decoration: BoxDecoration(
//         //   borderRadius: BorderRadius.all(
//         //     Radius.circular(context.resources.dimension.extraHighElevation),
//         //   ),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.only(
//               bottomLeft:
//                   Radius.circular(context.resources.dimension.bigMargin),
//               topRight: Radius.circular(context.resources.dimension.bigMargin)),
//           boxShadow: <BoxShadow>[
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 2,
//               blurRadius: 8,
//             )
//           ],
//
//           color: selected
//               ? Theme.of(context).colorScheme.cardColor.withOpacity(0.2)
//               : Theme.of(context).colorScheme.scaffoldColor,
//           // border: Border.all(
//           //     color: selected
//           //         ? Theme.of(context).colorScheme.redColor
//           //         : Theme.of(context).colorScheme.cardColor),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               height: context.resources.dimension.veryHighElevation,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: CustomText(
//                       content: context.resources.strings.address + " :",
//                       titletype: TitleType.bottoms,
//                       color: Theme.of(context).colorScheme.primaryTextColor,
//                     ),
//                   ),
//                   Expanded(
//                     child: CustomText(
//                       content: address.address ?? '',
//                       titletype: TitleType.bottoms,
//                       color: Theme.of(context).colorScheme.subText,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: context.resources.dimension.veryHighElevation,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: CustomText(
//                       content: context.resources.strings.zipCode + " :",
//                       titletype: TitleType.bottoms,
//                       color: Theme.of(context).colorScheme.primaryTextColor,
//                     ),
//                   ),
//                   Expanded(
//                     child: CustomText(
//                       content: address.postalCode ?? '',
//                       titletype: TitleType.bottoms,
//                       color: Theme.of(context).colorScheme.subText,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: context.resources.dimension.veryHighElevation,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: CustomText(
//                         content: context.resources.strings.city + " :",
//                         titletype: TitleType.bottoms,
//                         color: Theme.of(context).colorScheme.primaryTextColor),
//                   ),
//                   Expanded(
//                     child: CustomText(
//                       content: address.cityName ?? '',
//                       titletype: TitleType.bottoms,
//                       color: Theme.of(context).colorScheme.subText,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: context.resources.dimension.veryHighElevation,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: CustomText(
//                         content: context.resources.strings.state + " :",
//                         titletype: TitleType.bottoms,
//                         color: Theme.of(context).colorScheme.primaryTextColor),
//                   ),
//                   Expanded(
//                     child: CustomText(
//                       content: address.stateName ?? '',
//                       titletype: TitleType.bottoms,
//                       color: Theme.of(context).colorScheme.subText,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: context.resources.dimension.veryHighElevation,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: CustomText(
//                         content: context.resources.strings.country + " :",
//                         titletype: TitleType.bottoms,
//                         color: Theme.of(context).colorScheme.primaryTextColor),
//                   ),
//                   Expanded(
//                     child: CustomText(
//                       content: address.countryName ?? '',
//                       titletype: TitleType.bottoms,
//                       color: Theme.of(context).colorScheme.subText,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: context.resources.dimension.veryHighElevation,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: CustomText(
//                         content: context.resources.strings.phoneNumber + " :",
//                         titletype: TitleType.bottoms,
//                         color: Theme.of(context).colorScheme.primaryTextColor),
//                   ),
//                   Expanded(
//                     // child: PhoneTextField(
//                     //   isEnable: false,
//                     //   countries: [address.countryName!],
//                     //   textEditingController: TextEditingController(),
//                     //   onInputChanged: (phone) {},
//                     //   onInputValidated: (phone) {
//                     //     //_validationCubitPhone.save(phone);
//                     //   },
//                     // ),
//                     child: CustomText(
//                       content: address.phone ?? '',
//                       titletype: TitleType.body,
//                       color: Theme.of(context).colorScheme.primaryTextColor,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             const FixedHieght(),
//             // Container(
//             //   height: 1,
//             //   width: MediaQuery.of(context).size.width / 2,
//             //   decoration: BoxDecoration(
//             //     borderRadius: BorderRadius.circular(8),
//             //     color: Theme.of(context).colorScheme.lamisColor,
//             //   ),
//             // )
//           ],
//         ).customMargins());
//   }
//   // String getPhone(String phone)
//   // {
//   //   PhoneNumber number =  PhoneNumber.getRegionInfoFromPhoneNumber(phone);
//   //   String parsableNumber = number.parseNumber();
//   //   return parsableNumber;
//   // }
// }
