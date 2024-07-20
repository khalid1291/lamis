abstract class BaseApiService {
  // static const String rootUrl = "http://85.214.83.75:8012/lamis_dev";
  // static const String rootUrl = "http://192.168.1.110/Lamis_Backend";
  static const String rootUrl = "https://www.tourishop-jo.com";
  // static const String rootUrl = "https://lamis.nasca-sy.com";

  // static const String rootUrl = "http://85.214.83.75:8012/lamis_front_demo";
  // static const String rootUrl = "http://85.214.83.75:8012/lamis_demo";
  // static const String rootUrl =
  // "http://h2817272.stratoserver.net:8012/lamis_front_demo_starter";
  final String baseUrl = "$rootUrl/api/v2";
  static const String imagesRoute = "$rootUrl/public/";

  static const String purchaseCode =
      "020b2c36-a3c4-4f72-92d3-d724759c7c6f"; //purchase code required for login method

  Future<dynamic> getRequest(String url);

  Future<dynamic> getRequestAuthenticated(String url);

  Future<dynamic> postRequest(String url, Map<String, String> jsonBody);

  Future<dynamic> postRequestAuthenticated(
    String url,
    Map<String, String> jsonBody,
  );

  Future<dynamic> deleteResponse(String url);
}
