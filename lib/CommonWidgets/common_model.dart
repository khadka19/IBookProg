import 'dart:convert';

CommonModel selectCommonModel(String str) =>
    CommonModel.fromJson(json.decode(str));

class CommonModel {
  bool success;
  String message;
  String? data;

  CommonModel({
    required this.success,
    required this.message,
    required this.data,
  });
  factory CommonModel.fromJson(Map<String, dynamic> json) =>
      CommonModel(
        success: json["success"],
        message: json["message"],
        data: json[""],
      );
}