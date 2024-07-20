import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/repos/repos.dart';

import '../../../../data/remote/network/base_api_service.dart';

part 'payment_web_view_state.dart';

class PaymentWebViewCubit extends Cubit<PaymentWebViewState> {
  PaymentWebViewCubit() : super(PaymentWebViewInitial());

  void getPaymentUrl(
      {required int orderId,
      required int userId,
      required String paymentType}) async {
    emit(PaymentWebViewLoading());

    String paymentUrl = '';

    paymentUrl =
        "${BaseApiService.rootUrl}/api/v2/checkout?payment_option=$paymentType&combined_order_id=$orderId&user_id=${UserRepo().user.id}";

    emit(PaymentWebViewDone(
        paymentUrl: paymentUrl,
        successString: "/montypay-success",
        cancelString: "/montypay-cancel"));
  }
}
