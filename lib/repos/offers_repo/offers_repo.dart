import 'package:lamis/data/remote/remote.dart';
import 'package:lamis/models/models.dart';

class OffersRepo {
  final BaseApiService _apiService = NetworkApiService();

  Future<ProductMiniResponse> getTodayDeal() async {
    try {
      dynamic response =
          await _apiService.getRequest(ApiEndPoints.getTodayDeal);
      return productMiniResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductMiniResponse> getOffers() async {
    try {
      dynamic response = await _apiService.getRequest(ApiEndPoints.getOffers);
      return productMiniResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<FlashDealResponse> getFlashDeals() async {
    try {
      dynamic response = await _apiService.getRequest(ApiEndPoints.flashDeals);
      return flashDealResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
