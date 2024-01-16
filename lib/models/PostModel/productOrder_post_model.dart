class ProductOrderPostModel {
  int customerId;
  int userId;
  double latitude;
  double longitude;
  String remarks;
  List<ProductOrderDetailsModel> details;
  
  ProductOrderPostModel({
    required this.customerId,
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.remarks,
    required this.details,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'CustomerId': customerId,
      'UserId' : userId,
      'Latitude' : latitude,
      'Longitude' : longitude,
      'Remarks': remarks,
      'Details': details.map((detail) => detail.toJson()).toList(),
    };
  }
}

class ProductOrderDetailsModel {
  int productId;
  double? quantity;
  
  ProductOrderDetailsModel({
    required this.productId,
    required this.quantity,
   
  });

  Map<String, dynamic> toJson() {
    return {
      'ProductId': productId,
      'Qty': quantity,
     
    };
  }
}
