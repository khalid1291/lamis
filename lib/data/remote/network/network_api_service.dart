import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:lamis/data/remote/app_exception.dart';
import 'package:lamis/data/remote/remote.dart';

import '../../../../repos/repos.dart';
import '../../../cubits/main/is_logged_in_cubit.dart';
import '../../../main.dart';
import '../response/unauthorized_response.dart';

class NetworkApiService extends BaseApiService {
  static Client client = Client();

  late Response response;

  @override
  Future getRequest(String url) async {
    dynamic responseJson;
    try {
      if (kDebugMode) {
        print("token:${UserRepo().token}");
        print("language:${UserRepo().language}");
        print("url: ${Uri.parse(baseUrl + url)}");
        print("country code :${UserRepo().country} ");
      }
      final response = await client.get(Uri.parse(baseUrl + url), headers: {
        "Content-Type": "application/json",
        "App-Language": UserRepo().language,
        "Accept": "application/json",
        "country-code": UserRepo().country,
        "Authorization": "Bearer ${UserRepo().token}",
      });
      if (kDebugMode) {
        print("url : $url , status code : ${response.statusCode}");
      }
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('لا يوجد اتصال بالانترنت');
    }
    return responseJson;
  }

  @override
  Future<dynamic> deleteResponse(String url) async {
    dynamic responseJson;
    try {
      if (kDebugMode) {
        print("token:${UserRepo().token}");
        print("language:${UserRepo().language}");
        print("url: ${Uri.parse(baseUrl + url)}");
        print("country code :${UserRepo().country} ");
      }
      final response = await client.delete(Uri.parse(baseUrl + url), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${UserRepo().token}",
        "App-Language": UserRepo().language,
        "Accept": "application/json",
        "country-code": UserRepo().country
      });
      if (kDebugMode) {
        print("url : $url , status code : ${response.statusCode}");
      }
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('لا يوجد اتصال بالانترنت');
    }
    return responseJson;
  }

  @override
  Future postRequest(String url, Map<String, String> jsonBody) async {
    if (kDebugMode) {
      print("token:${UserRepo().token}");
      print("language:${UserRepo().language}");
      print("url: ${Uri.parse(baseUrl + url)}");
      print("country code :${UserRepo().country} ");
    }
    dynamic responseJson;
    try {
      final response =
          await client.post(Uri.parse(baseUrl + url), body: jsonBody, headers: {
        "App-Language": UserRepo().language,
        "Accept": "application/json",
        "country-code": UserRepo().country,
        "Authorization": "Bearer ${UserRepo().token}",
      });
      if (kDebugMode) {
        print("url : $url , status code : ${response.statusCode}");
      }
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('لا يوجد اتصال بالانترنت');
    }
    return responseJson;
  }

  @override
  Future postRequestAuthenticated(
      String url, Map<String, String> jsonBody) async {
    dynamic responseJson;
    if (kDebugMode) {
      print("token:${UserRepo().token}");
      print("language:${UserRepo().language}");
      print("url: ${Uri.parse(baseUrl + url)}");
      print("country code :${UserRepo().country} ");
      print("body: $jsonBody");
    }

    try {
      final response = await client
          .post(Uri.parse(baseUrl + url), body: jsonEncode(jsonBody), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${UserRepo().token}",
        "App-Language": UserRepo().language,
        "Accept": "application/json",
        "country-code": UserRepo().country
      });
      if (kDebugMode) {
        print("url : $url , status code : ${response.statusCode}");
      }
      responseJson = returnResponse(response);
      if (kDebugMode) {
        print("url : $url , status code : ${response.statusCode}");
      }
    } on SocketException {
      throw FetchDataException('لا يوجد اتصال بالانترنت ');
    }
    return responseJson;
  }

  dynamic returnResponse(Response response) {
    if (kDebugMode) {
      print(response.body);
    }
    switch (response.statusCode) {
      case 200:
      case 201:
        dynamic responseJson = response.body;
        return responseJson;
      case 400:
        throw BadRequestException(response.toString());
      case 401:
        throw UnauthorisedException(
            unAuthorisedResponseFromJson(response.body).message);
      case 403:
        {
          MyApp.context
              .read<IsLoggedInCubit>()
              .changeUserState(isLoggedIn: false);
          throw UnauthorisedException(
              unAuthorisedResponseFromJson(response.body).message);
        }
      case 404:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            ' ${response.statusCode} حصل خطأ اثناء الاتصال ');
    }
  }

  @override
  Future getRequestAuthenticated(String url) async {
    dynamic responseJson;
    try {
      final response = await client.get(Uri.parse(baseUrl + url), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${UserRepo().token}",
        "App-Language": UserRepo().language,
        "Accept": "application/json",
        "country-code": UserRepo().country
      });
      //print(UserRepo().token);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('لا يوجد اتصال بالانترنت');
    }
    return responseJson;
  }
}
