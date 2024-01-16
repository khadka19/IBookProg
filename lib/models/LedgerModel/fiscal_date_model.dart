// To parse this JSON data, do
//
//     final lrFiscalDateModel = lrFiscalDateModelFromJson(jsonString);

import 'dart:convert';

LrFiscalDateModel lrFiscalDateModelFromJson(String str) => LrFiscalDateModel.fromJson(json.decode(str));

String lrFiscalDateModelToJson(LrFiscalDateModel data) => json.encode(data.toJson());

class LrFiscalDateModel {
    bool success;
    String message;
    List<LrFiscalDateModelDetails> data;

    LrFiscalDateModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory LrFiscalDateModel.fromJson(Map<String, dynamic> json) => LrFiscalDateModel(
        success: json["success"],
        message: json["message"],
        data: List<LrFiscalDateModelDetails>.from(json["data"].map((x) => LrFiscalDateModelDetails.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class LrFiscalDateModelDetails {
    DateTime finStartMiti;
    String finEndMiti;
    DateTime finStartDate;
    DateTime finEndDate;
    String dateMode;

    LrFiscalDateModelDetails({
        required this.finStartMiti,
        required this.finEndMiti,
        required this.finStartDate,
        required this.finEndDate,
        required this.dateMode
    });

    factory LrFiscalDateModelDetails.fromJson(Map<String, dynamic> json) => LrFiscalDateModelDetails(
        finStartMiti: DateTime.parse(json["finStartMiti"]),
        finEndMiti: json["finEndMiti"],
        finStartDate: DateTime.parse(json["finStartDate"]),
        finEndDate: DateTime.parse(json["finEndDate"]),
        dateMode:  json["dateMode"],
    );

    Map<String, dynamic> toJson() => {
        "finStartMiti": "${finStartMiti.year.toString().padLeft(4, '0')}-${finStartMiti.month.toString().padLeft(2, '0')}-${finStartMiti.day.toString().padLeft(2, '0')}",
        "finEndMiti": finEndMiti,
        "finStartDate": "${finStartDate.year.toString().padLeft(4, '0')}-${finStartDate.month.toString().padLeft(2, '0')}-${finStartDate.day.toString().padLeft(2, '0')}",
        "finEndDate": "${finEndDate.year.toString().padLeft(4, '0')}-${finEndDate.month.toString().padLeft(2, '0')}-${finEndDate.day.toString().padLeft(2, '0')}",
    };
}
