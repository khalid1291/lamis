import 'package:lamis/data/remote/remote.dart';
import 'package:lamis/models/models.dart';
import 'dart:developer';

class SearchRepo {
  final BaseApiService _apiService = NetworkApiService();

  Future<ProductMiniResponse> searchKeyWord(String keyWord, int pageNumber,
      {String sortKey = "",
      String brands = "",
      String categories = "",
      String min = "",
      String max = ""}) async {
    try {
      dynamic response = await _apiService.getRequest(
          "${ApiEndPoints.searchReq}?&name=$keyWord&page=$pageNumber&sort_key=$sortKey&brands=$brands&categories=$categories&min=$min&max=$max");

      log("the search $response");
      return productMiniResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<BrandResponse> getBrands() async {
    try {
      dynamic response = await _apiService.getRequest(ApiEndPoints.getBrands);
      return brandResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<ShopResponse> getShops(String keyWord) async {
    try {
      dynamic response = await _apiService
          .getRequest("${ApiEndPoints.getShops}?&name=$keyWord");
      return shopResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }
  //
  // Future<List<SearchSuggestionResponse>> searchKeyWord(
  //     String keyWord, String type) async {
  //   try {
  //     dynamic response = await _apiService
  //         .getRequest(ApiEndPoints.searchReq + keyWord + "&type=$type");
  //     return searchSuggestionResponseFromJson(response);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  //
  // Future<List<SearchSuggestionResponse>> searchKeyWord(
  //     String keyWord, String type) async {
  //   try {
  //     dynamic response = await _apiService
  //         .getRequest(ApiEndPoints.searchReq + keyWord + "&type=$type");
  //     return searchSuggestionResponseFromJson(response);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
