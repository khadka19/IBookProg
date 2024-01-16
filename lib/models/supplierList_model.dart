// To parse this JSON data, do
//
//     final supplierListModel = supplierListModelFromJson(jsonString);

import 'dart:convert';

SupplierListModel supplierListModelFromJson(String str) => SupplierListModel.fromJson(json.decode(str));

String supplierListModelToJson(SupplierListModel data) => json.encode(data.toJson());

class SupplierListModel {
    bool success;
    String message;
    List<SupplierListModelDetails> data;

    SupplierListModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory SupplierListModel.fromJson(Map<String, dynamic> json) => SupplierListModel(
        success: json["success"],
        message: json["message"],
        data: List<SupplierListModelDetails>.from(json["data"].map((x) => SupplierListModelDetails.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class SupplierListModelDetails {
    int ledgerId;
    String ledgerName;
    String ledgerAddress;
    String ledgerPan;

    SupplierListModelDetails({
        required this.ledgerId,
        required this.ledgerName,
        required this.ledgerAddress,
        required this.ledgerPan,
    });

    factory SupplierListModelDetails.fromJson(Map<String, dynamic> json) => SupplierListModelDetails(
        ledgerId: json["ledger_Id"],
        ledgerName: json["ledger_Name"],
        ledgerAddress: json["ledger_Address"],
        ledgerPan: json["ledger_Pan"],
    );

    Map<String, dynamic> toJson() => {
        "ledger_Id": ledgerId,
        "ledger_Name": ledgerName,
        "ledger_Address": ledgerAddress,
        "ledger_Pan": ledgerPan,
    };
}
