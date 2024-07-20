import 'dart:convert';

import 'package:lamis/data/remote/remote.dart';

CategoryResponse categoryResponseFromJson(String str) =>
    CategoryResponse.fromJson(json.decode(str));

String categoryResponseToJson(CategoryResponse data) =>
    json.encode(data.toJson());

class CategoryResponse {
  CategoryResponse({
    required this.categories,
    required this.success,
    required this.status,
  });

  List<Category> categories;
  bool success;
  int status;

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      CategoryResponse(
        categories:
            List<Category>.from(json["data"].map((x) => Category.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(categories.map((x) => x.toJson())),
        "success": success,
        "status": status,
      };
}

class Category {
  Category({
    required this.id,
    required this.name,
    required this.banner,
    required this.icon,
    required this.numberOfChildren,
    this.links,
  });

  int id;
  String name;
  String banner;
  String icon;
  int numberOfChildren;
  CategoriesLinks? links;
  bool selected = false;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        banner: BaseApiService.imagesRoute + json["banner"],
        icon: BaseApiService.imagesRoute + json["icon"],
        numberOfChildren: json["number_of_children"],
        links: CategoriesLinks.fromJson(json["links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "banner": banner,
        "icon": icon,
        "number_of_children": numberOfChildren,
        "links": links?.toJson(),
      };
}

class CategoriesLinks {
  CategoriesLinks({
    required this.products,
    required this.subCategories,
  });

  String products;
  String subCategories;

  factory CategoriesLinks.fromJson(Map<String, dynamic> json) =>
      CategoriesLinks(
        products: json["products"],
        subCategories: json["sub_categories"],
      );

  Map<String, dynamic> toJson() => {
        "products": products,
        "sub_categories": subCategories,
      };
}
