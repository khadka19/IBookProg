class Invoice {
  late bool success;
  late String message;
  late InvoiceData data;
  Invoice.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = InvoiceData.fromJson(json['data']);
  }
}
class InvoiceData {
  late String refType;
  late String invoiceNo;
  late String invoiceMiti;
  late String invoiceDate;
  late String customerName;
  late String customerAddress;
  late String customerPan;
  late double grossAmount;
  late double taxableAmount;
  late double nonTaxableAmount;
  late double vatAmount;
  late double grandTotal;
  late String paymode;
  late String companyName;
  late String companyAddress;
  late String companyPhone;
  late String companyMobile;
  late String companyPan;
  late String remarks;
  late List<InvoiceDetail> details;

  InvoiceData.fromJson(Map<String, dynamic> json) {
    refType = json['refType'];
    invoiceNo = json['invoiceNo'];
    invoiceMiti = json['invoiceMiti'];
    invoiceDate = json['invoiceDate'];
    customerName = json['customerName'];
    customerAddress = json['customerAddress'];
    customerPan = json['customerPan'];
    grossAmount = json['grossAmount'];
    taxableAmount = json['taxableAmount'];
    nonTaxableAmount = json['nonTaxableAmount'];
    vatAmount = json['vatAmount'];
    grandTotal = json['grandTotal'];
    paymode = json['paymode'];
    companyName = json['companyName'];
    companyAddress = json['companyAddress'];
    companyPhone = json['companyPhone'];
    companyMobile = json['companyMobile'];
    companyPan = json['companyPan'];
    remarks = json['remarks'];
    if (json['details'] != null) {
      details = List<InvoiceDetail>.from(json['details'].map((detail) => InvoiceDetail.fromJson(detail)));
    }
  }
}

class InvoiceDetail {
  late String particulars;
  late String unit;
  late double quantity;
  late double rate;
  late double amount;
  late double discount;

  InvoiceDetail.fromJson(Map<String, dynamic> json) {
    particulars = json['particulars'];
    unit = json['unit'];
    quantity = json['quantity'];
    rate = json['rate'];
    amount = json['amount'];
    discount = json['discount'];
  }

 
}
