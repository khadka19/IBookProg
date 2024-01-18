// To parse this JSON data, do
//
//     final trialStockBranch = trialStockBranchFromJson(jsonString);

import 'dart:convert';

TrialStockBranch trialStockBranchFromJson(String str) => TrialStockBranch.fromJson(json.decode(str));

String trialStockBranchToJson(TrialStockBranch data) => json.encode(data.toJson());

class TrialStockBranch {
    bool success;
    String message;
    List<TrialStockBranchDetails> data;

    TrialStockBranch({
        required this.success,
        required this.message,
        required this.data,
    });

    factory TrialStockBranch.fromJson(Map<String, dynamic> json) => TrialStockBranch(
        success: json["success"],
        message: json["message"],
        data: List<TrialStockBranchDetails>.from(json["data"].map((x) => TrialStockBranchDetails.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class TrialStockBranchDetails {
    int id;
    String name;

    TrialStockBranchDetails({
        required this.id,
        required this.name,
    });

    factory TrialStockBranchDetails.fromJson(Map<String, dynamic> json) => TrialStockBranchDetails(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
