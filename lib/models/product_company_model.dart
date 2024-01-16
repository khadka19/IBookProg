import 'dart:convert';
// ignore: non_constant_identifier_names
SelectProductCompanyModel selectProductCompanyModelFromJson(String str) => SelectProductCompanyModel.fromJson(json.decode(str));

class SelectProductCompanyModel {
    bool success;
    String message;
    List<ProductCompanyModel> data;

    SelectProductCompanyModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory SelectProductCompanyModel.fromJson(Map<String, dynamic> json) => SelectProductCompanyModel(
        success: json["success"],
        message: json["message"],
        data: List<ProductCompanyModel>.from(json["data"].map((x) => ProductCompanyModel.fromJson(x))),
    );

}
class ProductCompanyModel {
    int? id;
    String companyName;

    ProductCompanyModel({
        required this.id,
        required this.companyName,
    });

    factory ProductCompanyModel.fromJson(Map<String, dynamic> json) => ProductCompanyModel(
        id: json["id"],
        companyName: json["companyName"],
    );
}
