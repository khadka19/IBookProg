import 'package:flutter/material.dart';
import 'package:petrolpump/Provider/all_provider.dart';
import 'package:petrolpump/models/customer_model.dart';

class CustomerProviderLR extends ChangeNotifier {

  List<CustomerModel> _customers = [];
  List<CustomerModel> get customers => _customers;
  int cusId = 0;
  String ledgerName = "";
  String address = "";
  String panNo = "";

  void selectCustomer(
      String id, String ledgerName, String address, String panNo) {
    cusId = int.parse(id);
    this.ledgerName = ledgerName.toString();
    this.address = address.toString();
    this.panNo = panNo.toString();
    notifyListeners();
  }


void resetState() {
  _customers=[];
    // Implement code to reset the state of the provider
    // For example, clear selected customer and product.
    // You can also clear other relevant data.
  notifyListeners();
}
  void clearSelection() {
      _customers=[];
    cusId = 0;
    ledgerName = "";
    address = "";
    panNo = "";
    ProductProvider productProvider = ProductProvider();
    productProvider.productList = [];
    notifyListeners();
  }
}
class LedgerDateProvider extends ChangeNotifier{
  DateTime? _selectedDateFrom=null;
  DateTime? get selectedDateFrom => _selectedDateFrom;

  set selectedDateFrom(DateTime? date) {
    _selectedDateFrom = date;
    notifyListeners(); // Ensure you notify listeners after updating dateFrom
  }

  DateTime? _selectedDateTo=null;
  DateTime? get selectedDateTo => _selectedDateTo;

  set selectedDateTo(DateTime? date) {
    _selectedDateTo = date;
    notifyListeners(); // Ensure you notify listeners after updating dateTo
  }

  clearSelection(){
    selectedDateFrom=null;
    selectedDateTo=null;
  }
}

class PDFLedgerProvider extends ChangeNotifier{
  String? _pdfDatePeriod;
  String? get pdfDatePeriod => _pdfDatePeriod;

  set selectedDatePeriod(String? date) {
    _pdfDatePeriod = date;
    notifyListeners(); // Ensure you notify listeners after updating dateFrom
  }


    String? _pdfDrTotal;
  String? get pdfDrTotal => _pdfDrTotal;

  set selectedPdfDr(String? date) {
    _pdfDrTotal = date;
    notifyListeners(); // Ensure you notify listeners after updating dateFrom
  }

     String? _pdfCrTotal;
  String? get pdfCrTotal => _pdfCrTotal;

  set selectedPdfCr(String? date) {
    _pdfCrTotal = date;
    notifyListeners(); // Ensure you notify listeners after updating dateFrom
  }
}



