import 'package:lamis/data/remote/remote.dart';
import 'package:lamis/models/models.dart';

class ProductRepo {
  final BaseApiService _apiService = NetworkApiService();

  Future<ProductMiniResponse> getCategoryProducts(
      {int id = 0, name = "", page = 1}) async {
    try {
      dynamic response = await _apiService.getRequest(
          "${ApiEndPoints.getCategoryProducts}$id?page=$page&name=$name");
      return productMiniResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductMiniResponse> getFeaturedProducts({page = 1}) async {
    try {
      dynamic response =
          await _apiService.getRequest(ApiEndPoints.getFeaturedProducts);
      return productMiniResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductDetailsResponse> getProductDetails({int id = 0}) async {
    try {
      dynamic response =
          await _apiService.getRequest("${ApiEndPoints.getProductDetails}$id");
      return productDetailsResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<VariantResponse?> getVariantWiseInfo(
      {int id = 0, color = '', variants = ''}) async {
    try {
      dynamic response = await _apiService.getRequest(
          "${ApiEndPoints.getProductVariant}${id.toString()}&color=$color&variants=$variants");

      return variantResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<VariantResponse?> getVariantPostInfo(
      {int id = 0, color = '', variants = ''}) async {
    Map<String, String> body = {
      "id": id.toString(),
      "color": color,
      "variants": variants
    };
    try {
      dynamic response = await _apiService.postRequest(
          ApiEndPoints.getProductVariantPost, body);

      return variantResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralResponse> submitProductsReview(
      {required String comment,
      required double rating,
      required int productId}) async {
    try {
      Map<String, String> body = {
        "product_id": productId.toString(),
        "rating": rating.toString(),
        "comment": comment
      };
      dynamic response = await _apiService.postRequestAuthenticated(
          ApiEndPoints.submitReview, body);

      return generalResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<ReviewResponse> getProductReviews(
      {required int productId, int pageNumber = 1}) async {
    try {
      dynamic response = await _apiService.getRequest(
        '${ApiEndPoints.getProductReviews}$productId?page=$pageNumber',
      );

      return reviewResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductMiniResponse> getBrandProducts(
      {int brandId = 0, page, name}) async {
    try {
      dynamic response = await _apiService.getRequest(
          "${ApiEndPoints.brandProducts}/${brandId.toString()}?&page=$page&name=$name");

      return productMiniResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductMiniResponse> getBuyAgainProducts({page}) async {
    try {
      dynamic response = await _apiService.getRequestAuthenticated(
          "${ApiEndPoints.buyAgainProducts}?page=$page");

      return productMiniResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductMiniResponse> getFlashDealProducts({int flashId = 0}) async {
    try {
      dynamic response = await _apiService
          .getRequest(ApiEndPoints.flashDealProducts + flashId.toString());

      return productMiniResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
