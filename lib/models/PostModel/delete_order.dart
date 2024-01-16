// To parse this JSON data, do
//
//     final deleteOrderModel = deleteOrderModelFromJson(jsonString);

import 'dart:convert';

DeleteOrderModel deleteOrderModelFromJson(String str) => DeleteOrderModel.fromJson(json.decode(str));

String deleteOrderModelToJson(DeleteOrderModel data) => json.encode(data.toJson());

class DeleteOrderModel {
    bool success;
    String message;
    dynamic data;

    DeleteOrderModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory DeleteOrderModel.fromJson(Map<String, dynamic> json) => DeleteOrderModel(
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
