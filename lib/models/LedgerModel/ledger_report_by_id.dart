// To parse this JSON data, do
//
//     final ledgerReportModel = ledgerReportModelFromJson(jsonString);

import 'dart:convert';

LedgerReportModel ledgerReportModelFromJson(String str) => LedgerReportModel.fromJson(json.decode(str));

String ledgerReportModelToJson(LedgerReportModel data) => json.encode(data.toJson());

class LedgerReportModel {
    bool success;
    String message;
    List<LedgerReportModelDetails> data;

    LedgerReportModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory LedgerReportModel.fromJson(Map<String, dynamic> json) => LedgerReportModel(
        success: json["success"],
        message: json["message"],
        data: List<LedgerReportModelDetails>.from(json["data"].map((x) => LedgerReportModelDetails.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class LedgerReportModelDetails {
    String particulars;
    String docNo;
    String docDate;
    String docMiti;
    double drAmount;
    double crAmount;

    LedgerReportModelDetails({
        required this.particulars,
        required this.docNo,
        required this.docDate,
        required this.docMiti,
        required this.drAmount,
        required this.crAmount,
    });

    factory LedgerReportModelDetails.fromJson(Map<String, dynamic> json) => LedgerReportModelDetails(
        particulars: json["particulars"],
        docNo: json["docNo"],
        docDate: json["docDate"],
        docMiti: json["docMiti"],
        drAmount: json["drAmount"],
        crAmount: json["crAmount"],
    );

    Map<String, dynamic> toJson() => {
        "particulars": particulars,
        "docNo": docNo,
        "docDate": docDate,
        "docMiti": docMiti,
        "drAmount": drAmount,
        "crAmount": crAmount,
    };
}
  
// }

// enum Particulars {
//     SALES
// }

// final particularsValues = EnumValues({
//     "Sales": Particulars.SALES
// });

// class EnumValues<T> {
//     Map<String, T> map;
//     late Map<T, String> reverseMap;

//     EnumValues(this.map);

//     Map<T, String> get reverse {
//         reverseMap = map.map((k, v) => MapEntry(v, k));
//         return reverseMap;
//     }
// }
