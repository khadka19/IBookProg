class ProductSalesPostModel {
  int customerId;
  String remarks;
  List<ProductSalesDetailsModel> details;
  
  ProductSalesPostModel({
    required this.customerId,
    required this.remarks,
    required this.details,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'remarks': remarks,
      'details': details.map((detail) => detail.toJson()).toList(),
    };
  }
}

class ProductSalesDetailsModel {
  int productId;
  double? quantity;
  double rate;
  double amount;
  double discount;

  ProductSalesDetailsModel({
    required this.productId,
    required this.quantity,
    required this.rate,
    required this.amount,
    required this.discount,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'rate': rate,
      'amount': amount,
      'discount': 0,
    };
  }
}
