import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lamis/cubits/address/add_address/add_address_cubit.dart';
import 'package:lamis/res/resources_export.dart';
import 'package:lamis/screens/home/home_screen.dart';
import 'package:lamis/widgets/general/custom_botton.dart';

import '../../models/address/address_response.dart';
import '../../widgets/general/custom_modal.dart';
import '../../widgets/general/toast_body.dart';
import 'user_information_screen.dart';

class AddressesOptionsScreen extends StatefulWidget {
  final Address address;

  const AddressesOptionsScreen({Key? key, required this.address})
      : super(key: key);

  @override
  State<AddressesOptionsScreen> createState() => _AddressesOptionsScreenState();
}

class _AddressesOptionsScreenState extends State<AddressesOptionsScreen> {
  late AddAddressCubit _addressCubit;
  FToast fToast = FToast();

  @override
  void initState() {
    _addressCubit = AddAddressCubit();
    fToast.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddAddressCubit, AddAddressState>(
      bloc: _addressCubit,
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
            text: state.response.message,
            bgColor: Theme.of(context).colorScheme.toastBackGround,
          ));
          Navigator.maybePop(context, true);
        }
        if (state is AddAddressError) {
          fToast.showToast(
              child: ToastBody(
            text: state.message,
            iconColor: Theme.of(context).colorScheme.redColor,
            bgColor: Theme.of(context).colorScheme.toastBackGround,
          ));
        }
      },
      child: Column(
        children: [
          CustomButton(
              onPress: () {
                _addressCubit.deleteAddress(id: widget.address.id!);
              },
              content: context.resources.strings.delete),
          const FixedHieght(),
          CustomButton(
              onPress: () async {
                var res = await BottomSheets.showModal(context,
                    type: BottomSheetType.big,
                    hasBorderMargin: true,
                    child: UserInformationScreen(
                      address: widget.address,
                      update: true,
                    ));
                if (res) {
                  // ignore: use_build_context_synchronously
                  Navigator.maybePop(context, true);
                }
              },
              content: context.resources.strings.update)
        ],
      ),
    );
  }
}
