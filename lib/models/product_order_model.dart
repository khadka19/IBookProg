import 'dart:convert';

SelectProductOrderModel selectProductOrderModelFromJson(String str) => SelectProductOrderModel.fromJson(json.decode(str));

class SelectProductOrderModel {
    bool success;
    String message;
    List<ProductOrderModel> data;

    SelectProductOrderModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory SelectProductOrderModel.fromJson(Map<String, dynamic> json) => SelectProductOrderModel(
        success: json["success"],
        message: json["message"],
        data: List<ProductOrderModel>.from(json["data"].map((x) => ProductOrderModel.fromJson(x))),
    );
}

class ProductOrderModel {
    int id;
    String productName;
    String unit;

    ProductOrderModel({
        required this.id,
        required this.productName,
        required this.unit,
    });

    factory ProductOrderModel.fromJson(Map<String, dynamic> json) => ProductOrderModel(
        id: json["id"],
        productName: json["productName"],
        unit: json["unit"],
    );

  where(Function(dynamic product) param0) {}
}