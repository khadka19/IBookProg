import 'dart:convert';

TrialStockModel trialStockModelFromJson(String str) => TrialStockModel.fromJson(json.decode(str));

String trialStockModelToJson(TrialStockModel data) => json.encode(data.toJson());

class TrialStockModel{
  bool success;
  String message;
  List<TrialStockModelDetails> data;

  TrialStockModel({
    required this.success,
    required this.message,
    required this.data
  });
  factory TrialStockModel.fromJson(Map<String, dynamic> json) => TrialStockModel(
        success: json["success"],
        message: json["message"],
        data: List<TrialStockModelDetails>.from(json["data"].map((x) => TrialStockModelDetails.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class TrialStockModelDetails{
  int productId;
  String productName;
  String productAlias;
  String productUnit;
  double inQuantity;
  double outQuantity;
  double balance;
  double openingQuantity;

  TrialStockModelDetails({
    required this.productId,
    required this.productName,
    required this.productAlias,
    required this.productUnit,
    required this.inQuantity,
    required this.outQuantity,
    required this.balance,
    required this.openingQuantity,
  });

    factory TrialStockModelDetails.fromJson(Map<String, dynamic> json) => TrialStockModelDetails(
        productId: json["productId"],
        productName: json["productName"],
        productAlias: json["productAlias"],
        productUnit: json["productUnit"],
        inQuantity: json["inQuantity"],
        openingQuantity: json["openingQuantity"],
        outQuantity: json["outQuantity"],
        balance: json["balance"],

    );

    Map<String, dynamic> toJson() => {
        "productId": productId,
        "productName": productName,
        "productAlias":productAlias,
        "productUnit":productUnit,
        "inQuantity":inQuantity,
        "outQuantity":outQuantity,
        "balance":balance,
        "openingQuantity":openingQuantity

    };
}