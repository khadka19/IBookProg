import 'dart:convert';

RoleControlModel roleControlModelFromJson(String str) => RoleControlModel.fromJson(json.decode(str));

String roleControlModelToJson(RoleControlModel data) => json.encode(data.toJson());

class RoleControlModel {
    bool success;
    String message;
    bool data;

    RoleControlModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory RoleControlModel.fromJson(Map<String, dynamic> json) => RoleControlModel(
        success: json["success"],
        message: json["message"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data,
    };
}
