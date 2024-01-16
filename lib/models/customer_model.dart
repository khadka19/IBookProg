import 'dart:convert';

SelectCustomerModel selectCustomerModelFromJson(String str) => SelectCustomerModel.fromJson(json.decode(str));

class SelectCustomerModel {
    bool success;
    String message;
    List<CustomerModel> data;

    SelectCustomerModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory SelectCustomerModel.fromJson(Map<String, dynamic> json) => SelectCustomerModel(
        success: json["success"],
        message: json["message"],
        data: List<CustomerModel>.from(json["data"].map((x) => CustomerModel.fromJson(x))),
    );
}

class CustomerModel {
    int? id;
    String ledgerName;
    String address;
    String panNo;

    CustomerModel({
        required this.id,
        required this.ledgerName,
        required this.address,
        required this.panNo,
    });

    factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        id: json["id"],
        ledgerName: json["ledgerName"],
        address: json["address"],
        panNo: json["panNo"],
    );
}
