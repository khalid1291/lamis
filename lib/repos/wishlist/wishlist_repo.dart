import 'package:lamis/data/remote/remote.dart';
import 'package:lamis/models/models.dart';

class WishListRepo {
  final BaseApiService _apiService = NetworkApiService();
  Future<WishListChekResponse?> checkUserProductWishlist(int productId) async {
    try {
      dynamic response = await _apiService.getRequestAuthenticated(
          ApiEndPoints.checkIfInWishlist + productId.toString());
      return wishListChekResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<WishListChekResponse?> addtoWishList(int productId) async {
    try {
      dynamic response = await _apiService.getRequestAuthenticated(
          ApiEndPoints.addToWishList + productId.toString());
      return wishListChekResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<WishListChekResponse?> deleteFromWishList(int productId) async {
    try {
      dynamic response = await _apiService.getRequestAuthenticated(
          ApiEndPoints.removeWishList + productId.toString());
      return wishListChekResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<WishlistResponse?> getUserWishList() async {
    try {
      dynamic response =
          await _apiService.getRequestAuthenticated(ApiEndPoints.wishlist);
      return wishlistResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
