// To parse this JSON data, do
//
//     final deliveryMethodsResponse = deliveryMethodsResponseFromJson(jsonString);

import 'dart:convert';

DeliveryMethodsResponse deliveryMethodsResponseFromJson(String str) =>
    DeliveryMethodsResponse.fromJson(json.decode(str));

String deliveryMethodsResponseToJson(DeliveryMethodsResponse data) =>
    json.encode(data.toJson());

class DeliveryMethodsResponse {
  DeliveryMethodsResponse({
    required this.data,
  });

  List<DeliveryMethod> data;

  factory DeliveryMethodsResponse.fromJson(Map<String, dynamic> json) =>
      DeliveryMethodsResponse(
        data: List<DeliveryMethod>.from(
            json["data"].map((x) => DeliveryMethod.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DeliveryMethod {
  DeliveryMethod({
    required this.id,
    required this.name,
    required this.value,
  });

  int id;
  String name;
  int value;

  factory DeliveryMethod.fromJson(Map<String, dynamic> json) => DeliveryMethod(
        id: json["id"],
        name: json["name"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "value": value,
      };
}
