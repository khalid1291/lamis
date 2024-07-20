import 'package:lamis/data/remote/remote.dart';

import '../../../models/models.dart';

class CategoriesRepo {
  final BaseApiService _apiService = NetworkApiService();

  Future<CategoryResponse> getCategories({parentId = 0}) async {
    try {
      dynamic response = await _apiService
          .getRequest("${ApiEndPoints.getCategories}$parentId");
      return categoryResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<CategoryResponse> getSubCategories({id = 0}) async {
    try {
      dynamic response =
          await _apiService.getRequest("${ApiEndPoints.getSubCategories}$id");
      return categoryResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<CategoryResponse> getFeaturedCategories() async {
    try {
      dynamic response =
          await _apiService.getRequest(ApiEndPoints.getFeaturedCategories);
      return categoryResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
