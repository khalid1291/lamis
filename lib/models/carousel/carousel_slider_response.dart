import 'dart:convert';

import 'package:lamis/data/remote/remote.dart';

CarouselSliderResponse sliderResponseFromJson(String str) =>
    CarouselSliderResponse.fromJson(json.decode(str));

String sliderResponseToJson(CarouselSliderResponse data) =>
    json.encode(data.toJson());

class CarouselSliderResponse {
  CarouselSliderResponse({
    required this.sliders,
    required this.success,
    required this.status,
  });

  List<Slider> sliders;
  bool success;
  int status;

  factory CarouselSliderResponse.fromJson(Map<String, dynamic> json) =>
      CarouselSliderResponse(
        sliders: List<Slider>.from(json["data"].map((x) => Slider.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(sliders.map((x) => x.toJson())),
        "success": success,
        "status": status,
      };
}

class Slider {
  Slider({
    required this.photo,
  });

  String photo;

  factory Slider.fromJson(Map<String, dynamic> json) => Slider(
        photo: BaseApiService.imagesRoute + json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "photo": photo,
      };
}
