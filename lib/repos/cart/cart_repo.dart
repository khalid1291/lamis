import 'package:lamis/data/remote/remote.dart';
import 'package:lamis/models/cart/cart_summary_response.dart';
import 'package:lamis/models/models.dart';

class CartRepo {
  final BaseApiService _apiService = NetworkApiService();

  Future<GeneralResponse?> addToCart(
      int itemId, String variant, int? userId, int quantity) async {
    try {
      Map<String, String> body = {
        "id": itemId.toString(),
        "variant": variant,
        "quantity": quantity.toString(),
      };
      dynamic response = await _apiService.postRequestAuthenticated(
          ApiEndPoints.addToCart, body);
      return generalResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<PaypalUrlResponse> getPayPalUrl({required String url}) async {
    try {
      dynamic response = await _apiService.getRequest(url);
      return paypalUrlResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderCreateResponse?> checkoutCart(
      String paymentType, String note) async {
    try {
      Map<String, String> body = {"payment_type": paymentType, "note": note};
      dynamic response = await _apiService.postRequestAuthenticated(
          ApiEndPoints.orderCreate, body);
      return orderCreateResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderCreateResponse?> cashOnDelivery(
      String paymentType, String note) async {
    try {
      Map<String, String> body = {"payment_type": paymentType, "note": note};
      dynamic response = await _apiService.postRequestAuthenticated(
          ApiEndPoints.cashOnDelivery, body);
      return orderCreateResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderCreateResponse?> walletPayment(
      String paymentType, String note) async {
    try {
      Map<String, String> body = {"payment_type": paymentType, "note": note};
      dynamic response = await _apiService.postRequestAuthenticated(
          ApiEndPoints.walletCash, body);
      return orderCreateResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CartResponse>> fetchCartItems() async {
    try {
      dynamic response =
          await _apiService.postRequestAuthenticated(ApiEndPoints.carts, {});
      return cartResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PaymentTypeResponse>?> fetchPaymentTypes() async {
    try {
      dynamic response = await _apiService.getRequest(
        ApiEndPoints.paymentsTypes,
      );
      return paymentTypeResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralResponse?> deleteCartItem(int itemId) async {
    try {
      dynamic response = await _apiService.deleteResponse(
        ApiEndPoints.deleteCarts + itemId.toString(),
      );
      return generalResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralResponse?> updateCartItem(int itemId, int quantity) async {
    try {
      Map<String, String> body = {
        "cart_ids": itemId.toString(),
        "cart_quantities": quantity.toString()
      };
      dynamic response = await _apiService.postRequestAuthenticated(
          ApiEndPoints.updateCartItem, body);
      return generalResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralResponse?> cartProcess(
      String cartIds, String cartQuantities) async {
    try {
      Map<String, String> body = {
        "cart_ids": cartIds,
        "cart_quantities": cartQuantities
      };
      dynamic response = await _apiService.postRequestAuthenticated(
          ApiEndPoints.cartProcess, body);
      return generalResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<CartSummaryResponse?> getCartSummary() async {
    try {
      dynamic response =
          await _apiService.getRequestAuthenticated(ApiEndPoints.cartSummary);
      return cartSummaryResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<DeliveryMethodsResponse?> getDeliveryMethods() async {
    try {
      dynamic response = await _apiService
          .getRequestAuthenticated(ApiEndPoints.deliveryMethod);
      return deliveryMethodsResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralResponse?> saveDeliveryMethods(
      int deliveryId, String? date) async {
    try {
      Map<String, String> body = {
        "delivery_id": deliveryId.toString(),
        "delivery_time": date ?? ""
      };
      dynamic response = await _apiService.postRequestAuthenticated(
          ApiEndPoints.saveDeliveryMethod, body);
      return generalResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralResponse?> applyCoupon(String coupon) async {
    try {
      Map<String, String> body = {
        "coupon_code": coupon,
      };
      dynamic response = await _apiService.postRequestAuthenticated(
          ApiEndPoints.couponApply, body);
      return generalResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralResponse?> removeCoupon() async {
    try {
      Map<String, String> body = {};
      dynamic response = await _apiService.postRequestAuthenticated(
          ApiEndPoints.couponRemove, body);
      return generalResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
