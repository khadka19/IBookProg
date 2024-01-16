// To parse this JSON data, do
//
//     final orderDetailsModel = orderDetailsModelFromJson(jsonString);

import 'dart:convert';

OrderDetailsModel orderDetailsModelFromJson(String str) => OrderDetailsModel.fromJson(json.decode(str));

String orderDetailsModelToJson(OrderDetailsModel data) => json.encode(data.toJson());

class OrderDetailsModel {
    bool success;
    String message;
    List<OrderDetailsModelDetails> data;

    OrderDetailsModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory OrderDetailsModel.fromJson(Map<String, dynamic> json) => OrderDetailsModel(
        success: json["success"],
        message: json["message"],
        data: List<OrderDetailsModelDetails>.from(json["data"].map((x) => OrderDetailsModelDetails.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class OrderDetailsModelDetails {
    String product;
    String unit;
    double qty;

    OrderDetailsModelDetails({
        required this.product,
        required this.unit,
        required this.qty,
    });

    factory OrderDetailsModelDetails.fromJson(Map<String, dynamic> json) => OrderDetailsModelDetails(
        product: json["product"],
        unit: json["unit"],
        qty: json["qty"],
    );

    Map<String, dynamic> toJson() => {
        "product": product,
        "unit": unit,
        "qty": qty,
    };
}
