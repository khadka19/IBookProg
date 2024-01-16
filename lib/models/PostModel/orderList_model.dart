

class OrderListModel{
  int? userId;
  int? customerId;
   String dateFrom;
   String dateTo;
   String status;

  OrderListModel({  
    required this.userId,
    required this.customerId,
    required this.dateFrom,
    required this.dateTo,
    required this.status
  });
  Map<String, dynamic> toJson() {
    return {
      'UserId' : userId,
      'CustomerId': customerId,
      'DateFrom' : dateFrom,
      'DateTo' : dateTo,
      'Status': status,
      
    };
  }

}