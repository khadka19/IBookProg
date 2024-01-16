import 'dart:convert';

OrderResponseList selectCustomerModelFromJson(String str) =>
    OrderResponseList.fromJson(json.decode(str));

class OrderResponseList {
  bool success;
  String message;
  List<OrderResponseDetails> data;

  OrderResponseList({
    required this.success,
    required this.message,
    required this.data,
  });
  factory OrderResponseList.fromJson(Map<String, dynamic> json) =>
      OrderResponseList(
        success: json["success"],
        message: json["message"],
        data: List<OrderResponseDetails>.from(json["data"].map((x) => OrderResponseDetails.fromJson(x))),
      );
}

class OrderResponseDetails {
  int id;
  String customer;
  int orderNo;
  String orderDate;
  String orderMiti;
  String enteredOn;
  String status;
  String remarks;
  String enteredBy;

  OrderResponseDetails({
    required this.id,
    required this.customer,
    required this.orderNo,
    required this.orderDate,
    required this.orderMiti,
    required this.enteredOn,
    required this.status,
    required this.remarks,
    required this.enteredBy,
  });

  // Factory method to create an Order object from a map
  factory OrderResponseDetails.fromJson(Map<String, dynamic> json) {
    return OrderResponseDetails(
      id: json['id'],
      customer: json['customer'],
      orderNo: json['orderNo'],
      orderDate: json['orderDate'],
      orderMiti: json['orderMiti'],
      enteredOn: json['enteredOn'],
      status: json['status'],
      remarks: json['remarks'],
      enteredBy: json['enteredBy'],
    );
  }
}
