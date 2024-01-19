// To parse this JSON data, do
//
//     final tsProductGroupModel = tsProductGroupModelFromJson(jsonString);

import 'dart:convert';

TsProductGroupModel tsProductGroupModelFromJson(String str) => TsProductGroupModel.fromJson(json.decode(str));

String tsProductGroupModelToJson(TsProductGroupModel data) => json.encode(data.toJson());

class TsProductGroupModel {
    bool success;
    String message;
    List<TsProductGroupModelDetails> data;

    TsProductGroupModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory TsProductGroupModel.fromJson(Map<String, dynamic> json) => TsProductGroupModel(
        success: json["success"],
        message: json["message"],
        data: List<TsProductGroupModelDetails>.from(json["data"].map((x) => TsProductGroupModelDetails.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class TsProductGroupModelDetails {
    int id;
    String name;

    TsProductGroupModelDetails({
        required this.id,
        required this.name,
    });

    factory TsProductGroupModelDetails.fromJson(Map<String, dynamic> json) => TsProductGroupModelDetails(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
