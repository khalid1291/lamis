import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/screens/orders/orders_screen.dart';

class OrderPaymentStatusCubit extends Cubit<PaymentStatus> {
  OrderPaymentStatusCubit(PaymentStatus initialState)
      : super(PaymentStatus('', "All"));

  void save(PaymentStatus val) => emit(val);
}
