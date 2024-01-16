// To parse this JSON data, do
//
//     final cusOutstandingModel = cusOutstandingModelFromJson(jsonString);

import 'dart:convert';

CusSplrOutstandingModel cussplrOutstandingModelFromJson(String str) => CusSplrOutstandingModel.fromJson(json.decode(str));

String cussplrOutstandingModelToJson(CusSplrOutstandingModel data) => json.encode(data.toJson());

class CusSplrOutstandingModel {
    bool success;
    String message;
    List<CusSplrOutstandingModelDetails> data;

    CusSplrOutstandingModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory CusSplrOutstandingModel.fromJson(Map<String, dynamic> json) => CusSplrOutstandingModel(
        success: json["success"],
        message: json["message"],
        data: List<CusSplrOutstandingModelDetails>.from(json["data"].map((x) => CusSplrOutstandingModelDetails.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class CusSplrOutstandingModelDetails {
    String ledgerName;
    String ledgerPan;
    String ledgerAddress;
    double ledgerDrAmount;
    double ledgerCrAmount;
    double ledgerBalance;
    String docType;
    String docDate;
    String docMiti;
    String docNo;
    int? docDays;
    double invoiceAmount;
    double cumulativeSum;
    double balance;
    int? ledgerBillPayment;

    CusSplrOutstandingModelDetails({
        required this.ledgerName,
        required this.ledgerPan,
        required this.ledgerAddress,
        required this.ledgerDrAmount,
        required this.ledgerCrAmount,
        required this.ledgerBalance,
        required this.docType,
        required this.docDate,
        required this.docMiti,
        required this.docNo,
        required this.docDays,
        required this.invoiceAmount,
        required this.cumulativeSum,
        required this.balance,
        required this.ledgerBillPayment,
    });

    factory CusSplrOutstandingModelDetails.fromJson(Map<String, dynamic> json) => CusSplrOutstandingModelDetails(
        ledgerName:json["ledger_Name"],
        ledgerPan: json["ledger_Pan"],
        ledgerAddress:json["ledger_Address"],
        ledgerDrAmount: json["ledger_DrAmount"],
        ledgerCrAmount: json["ledger_CrAmount"],
        ledgerBalance: json["ledger_Balance"],
        docType:json["docType"],
        docDate: json["docDate"],
        docMiti: json["docMiti"],
        docNo: json["docNo"],
        docDays: json["docDays"],
        invoiceAmount: json["invoiceAmount"],
        cumulativeSum: json["cumulativeSum"],
        balance: json["balance"],
        ledgerBillPayment: json["ledger_BillPayment"]
    );

    Map<String, dynamic> toJson() => {
        "ledger_Name": ledgerName,
        "ledger_Pan": ledgerPan,
        "ledger_Address": ledgerAddress,
        "ledger_DrAmount": ledgerDrAmount,
        "ledger_CrAmount": ledgerCrAmount,
        "ledger_Balance": ledgerBalance,
        "docType": docType,
        "docDate": docDate,
        "docMiti": docMiti,
        "docNo": docNo,
        "docDays": docDays,
        "invoiceAmount": invoiceAmount,
        "cumulativeSum": cumulativeSum,
        "balance": balance,
        "ledger_BillPayment":ledgerBillPayment,
    };
}



