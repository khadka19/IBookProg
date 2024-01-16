import 'package:flutter/material.dart';
import 'package:petrolpump/models/customer_model.dart';
class ViewOrderProvider extends ChangeNotifier{
   String? _selectedStatus = "Select a Status";

  String? get selectedStatus => _selectedStatus;

  set selectedStatus(String? status) {
    _selectedStatus = status;
    notifyListeners();
  }


   DateTime? _selectedDateFrom;
  DateTime? get selectedDateFrom => _selectedDateFrom;

  set selectedDateFrom(DateTime? date) {
    _selectedDateFrom = date;
    notifyListeners(); // Ensure you notify listeners after updating dateFrom
  }

  DateTime? _selectedDateTo;
  DateTime? get selectedDateTo => _selectedDateTo;

  set selectedDateTo(DateTime? date) {
    _selectedDateTo = date;
    notifyListeners(); // Ensure you notify listeners after updating dateTo
  }
 void clearSelectedValues() {
    _selectedStatus = "Select a Status";
    _selectedDateFrom = null;
    _selectedDateTo = null;
    notifyListeners();
  }


}
class CustomerProviderVO extends ChangeNotifier {
  List<CustomerModel> _customers = [];
  List<CustomerModel> get customers => _customers;
  int? cusId;
  String ledgerName = "";
  String address = "";
  String panNo = "";

  void selectCustomer(
      String? id, String ledgerName, String address, String panNo) {
    cusId = int.parse(id!);
    this.ledgerName = ledgerName.toString();
    this.address = address.toString();
    this.panNo = panNo.toString();
    notifyListeners();
  }

  void clearSelection() {
    cusId = 0;
    ledgerName = "";
    address = "";
    panNo = "";

    notifyListeners();
  }
}



class OrderDetailsProvider with ChangeNotifier {
  bool _isDialogOpen = false;

  bool get isDialogOpen => _isDialogOpen;

  void openDialog() {
    _isDialogOpen = true;
    notifyListeners();
  }

  void closeDialog() {
    _isDialogOpen = false;
    notifyListeners();
  }
}

