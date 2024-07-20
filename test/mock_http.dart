import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:lamis/data/remote/network/api_end_points.dart';
import 'package:lamis/data/remote/network/base_api_service.dart';
import 'package:lamis/data/remote/network/network_api_service.dart';
import 'package:lamis/models/categories/category_response.dart';

void main() {
  String rootUrl = "http://85.214.83.75:8012/lamis_dev";
  String baseUrl = "$rootUrl/api/v2";
  final BaseApiService _apiService = NetworkApiService();

  group('getCategory', () {
    test('returns Category when http response is successful', () async {
      final apiProvider = ApiProvider();

      CategoryResponse getCategoryes = await apiProvider.getCategory();
      expect(getCategoryes.success, true);
    });

    // test('return error message when http response is unsuccessful', () async {
    //   // Mock the API call to return an
    //   // empty json response with http status 404
    //   final mockHTTPClient = MockClient((request) async {
    //     final response = {};
    //     return Response(jsonEncode(response), 404);
    //   });
    //   expect(await ApiEndPoints.getCategories,
    //       ' Error occurred  while communication with server \n with status code');
    // });
  });
}

class ApiProvider {
  Client client = Client();
  static String rootUrl = "http://85.214.83.75:8012/lamis_dev";
  static String baseUrl = "$rootUrl/api/v2";
  final BaseApiService _apiService = NetworkApiService();

  Future<CategoryResponse> getCategory() async {
    final response = await client
        .get(Uri.parse(ApiProvider.baseUrl + ApiEndPoints.getCategories));
    CategoryResponse itemModel =
        CategoryResponse.fromJson(json.decode(response.body));
    return itemModel;
  }
}
