// To parse this JSON data, do
//
//     final areaModel = areaModelFromJson(jsonString);

import 'dart:convert';

AreaModel areaModelFromJson(String str) => AreaModel.fromJson(json.decode(str));

String areaModelToJson(AreaModel data) => json.encode(data.toJson());

class AreaModel {
    bool success;
    String message;
    List<AreaModelDetails> data;

    AreaModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory AreaModel.fromJson(Map<String, dynamic> json) => AreaModel(
        success: json["success"],
        message: json["message"],
        data: List<AreaModelDetails>.from(json["data"].map((x) => AreaModelDetails.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class AreaModelDetails {
    int id;
    String name;

    AreaModelDetails({
        required this.id,
        required this.name,
    });

    factory AreaModelDetails.fromJson(Map<String, dynamic> json) => AreaModelDetails(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
