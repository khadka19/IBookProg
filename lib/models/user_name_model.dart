import 'dart:convert';

UserNameModel userNameModelFromJson(String str) =>
    UserNameModel.fromJson(json.decode(str));

String userNameModelToJson(UserNameModel data) => json.encode(data.toJson());

class UserNameModel {
  bool error;
  String? data;

  UserNameModel({
    required this.error,
    required this.data,
  });
  factory UserNameModel.fromJson(Map<String, dynamic> json) => UserNameModel(
        error: json["error"]??false,
        data: json["data"],
      );
  Map<String, dynamic> toJson() => {
        "error": error,
        "data": data,
      };
}
