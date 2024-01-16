import 'dart:convert';

SelectProductModel selectProductModelFromJson(String str) => SelectProductModel.fromJson(json.decode(str));

class SelectProductModel {
    bool success;
    String message;
    List<ProductModel> data;

    SelectProductModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory SelectProductModel.fromJson(Map<String, dynamic> json) => SelectProductModel(
        success: json["success"],
        message: json["message"],
        data: List<ProductModel>.from(json["data"].map((x) => ProductModel.fromJson(x))),
    );
}

class ProductModel {
    int id;
    String productName;
    String? company;
    String? unit;
    double? rate;

    ProductModel({
        required this.id,
        required this.productName,
        required this.company,
        required this.unit,
        this.rate,
    });

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        productName: json["productName"],
        company: json["company"],
        unit: json["unit"],
        rate: json["rate"],
    );

  where(Function(dynamic product) param0) {}
}