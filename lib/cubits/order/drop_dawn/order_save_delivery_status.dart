import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamis/screens/orders/orders_screen.dart';

class OrderDeliveryStatusCubit extends Cubit<DeliveryStatus> {
  OrderDeliveryStatusCubit(DeliveryStatus initialState)
      : super(DeliveryStatus('', "All"));

  void save(DeliveryStatus val) {
    emit(val);
  }
}
