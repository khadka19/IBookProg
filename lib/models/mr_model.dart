// To parse this JSON data, do
//
//     final mrModel = mrModelFromJson(jsonString);

import 'dart:convert';

MrModel mrModelFromJson(String str) => MrModel.fromJson(json.decode(str));

String mrModelToJson(MrModel data) => json.encode(data.toJson());

class MrModel {
    bool success;
    String message;
    List<MrModelDetails> data;

    MrModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory MrModel.fromJson(Map<String, dynamic> json) => MrModel(
        success: json["success"],
        message: json["message"],
        data: List<MrModelDetails>.from(json["data"].map((x) => MrModelDetails.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class MrModelDetails {
    int id;
    String name;

    MrModelDetails({
        required this.id,
        required this.name,
    });

    factory MrModelDetails.fromJson(Map<String, dynamic> json) => MrModelDetails(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
