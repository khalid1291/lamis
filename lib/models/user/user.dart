import 'package:lamis/data/remote/remote.dart';

class User {
  User(
      {required this.id,
      this.type,
      required this.name,
      this.email,
      required this.avatar,
      required this.avatarOriginal,
      required this.phone,
      this.code});

  int id;
  String? type;
  String name;
  String? email;
  String? avatar;
  String avatarOriginal;
  String? phone;
  String? code;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        type: json["type"],
        name: json["name"],
        email: json["email"],
        avatar: json["avatar"],
        avatarOriginal: BaseApiService.imagesRoute + json["avatar_original"],
        phone: json["phone"],
        code: json["affiliate_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "name": name,
        "email": email,
        "avatar": avatar,
        "avatar_original": avatarOriginal,
        "phone": phone,
        "affiliate_code": code
      };

  @override
  String toString() {
    return "code: $code ,";
  }
}
