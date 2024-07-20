import 'dart:convert';

import 'package:lamis/models/address/country_model.dart';

GeneralSettings generalSettingsResponseFromJson(String str) =>
    GeneralSettings.fromJson(json.decode(str));

String generalSettingsResponseToJson(GeneralSettings data) =>
    json.encode(data.toJson());

class GeneralSettings {
  bool? result;
  String? androidAppVersion;
  String? iosAppVersion;
  String? forceAppUpdate;
  Countries? countries;

  GeneralSettings(
      {this.result,
      this.androidAppVersion,
      this.iosAppVersion,
      this.forceAppUpdate,
      this.countries});

  GeneralSettings.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    androidAppVersion = json['android_app_version'];
    iosAppVersion = json['ios_app_version'];
    forceAppUpdate = json['force_app_update'];
    countries = Countries.fromJson(json["countries"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['android_app_version'] = androidAppVersion;
    data['ios_app_version'] = iosAppVersion;
    data['force_app_update'] = forceAppUpdate;
    data['countries'] = countries?.toJson();

    return data;
  }
}

class Countries {
  Countries({
    this.data,
  });

  List<Country>? data;

  factory Countries.fromJson(Map<String, dynamic> json) => Countries(
        data: List<Country>.from(json["data"].map((x) => Country.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}
