import 'dart:convert';

SocialLinksResponse socialLinksResponseFromJson(String str) =>
    SocialLinksResponse.fromJson(json.decode(str));

String socialLinksResponseToJson(SocialLinksResponse data) =>
    json.encode(data.toJson());

class SocialLinksResponse {
  List<SocialLinkData>? socialLinkData;
  bool? success;
  int? status;

  SocialLinksResponse({this.socialLinkData, this.success, this.status});

  SocialLinksResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      socialLinkData = <SocialLinkData>[];
      json['data'].forEach((v) {
        socialLinkData!.add(SocialLinkData.fromJson(v));
      });
    }
    success = json['success'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (socialLinkData != null) {
      data['data'] = socialLinkData!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    data['status'] = status;
    return data;
  }
}

class SocialLinkData {
  String? name;
  String? link;
  String? image;

  SocialLinkData({this.name, this.link, this.image});

  SocialLinkData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    link = json['link'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['link'] = link;
    data['image'] = image;
    return data;
  }
}
