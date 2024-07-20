import 'dart:convert';

CountryResponse countryResponseFromJson(String str) =>
    CountryResponse.fromJson(json.decode(str));

String countryResponseToJson(CountryResponse data) =>
    json.encode(data.toJson());

class CountryResponse {
  CountryResponse({
    this.countries,
    this.success,
    this.status,
  });

  List<Country>? countries;
  bool? success;
  int? status;

  factory CountryResponse.fromJson(Map<String, dynamic> json) =>
      CountryResponse(
        countries:
            List<Country>.from(json["data"].map((x) => Country.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(countries!.map((x) => x.toJson())),
        "success": success,
        "status": status,
      };
}

class Country {
  Country(
      {required this.id,
      this.code,
      this.name,
      this.arabicName,
      this.status,
      this.createdAt,
      this.dbStatus,
      this.deletedAt,
      this.updatedAt});

  @override
  toString() => '$name';

  int id;
  String? code;
  String? name;
  int? status;
  int? dbStatus;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? arabicName;
  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        arabicName: json["arabic_name"],
        status: json["status"],
        dbStatus: json['db_status'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        deletedAt: json['deleted_at'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "arabic_name": arabicName,
        "status": status,
        "db_status": dbStatus,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
      };
}

MyStateResponse myStateResponseFromJson(String str) =>
    MyStateResponse.fromJson(json.decode(str));

String myStateResponseToJson(MyStateResponse data) =>
    json.encode(data.toJson());

class MyStateResponse {
  MyStateResponse({
    this.states,
    this.success,
    this.status,
  });

  List<MyState>? states;
  bool? success;
  int? status;

  factory MyStateResponse.fromJson(Map<String, dynamic> json) =>
      MyStateResponse(
        states:
            List<MyState>.from(json["data"].map((x) => MyState.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(states!.map((x) => x.toJson())),
        "success": success,
        "status": status,
      };
}

class MyState {
  MyState({
    this.id,
    this.countryId,
    this.name,
  });

  @override
  toString() => '$name';

  int? id;
  int? countryId;
  String? name;

  factory MyState.fromJson(Map<String, dynamic> json) => MyState(
        id: json["id"],
        countryId: json["country_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country_id": countryId,
        "name": name,
      };
}

CityResponse cityResponseFromJson(String str) =>
    CityResponse.fromJson(json.decode(str));

String cityResponseToJson(CityResponse data) => json.encode(data.toJson());

class CityResponse {
  CityResponse({
    this.cities,
    this.success,
    this.status,
  });

  List<City>? cities;
  bool? success;
  int? status;

  factory CityResponse.fromJson(Map<String, dynamic> json) => CityResponse(
        cities: List<City>.from(json["data"].map((x) => City.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(cities!.map((x) => x.toJson())),
        "success": success,
        "status": status,
      };
}

class City {
  City({
    this.id,
    this.stateId,
    this.name,
  });

  @override
  toString() => '$name';

  int? id;
  int? stateId;
  String? name;

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        stateId: json["state_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "state_id": stateId,
        "name": name,
      };
}
