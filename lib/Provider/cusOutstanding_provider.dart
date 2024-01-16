import 'package:flutter/material.dart';
import 'package:petrolpump/Provider/all_provider.dart';
import 'package:petrolpump/models/customer_model.dart';


class CustomerOutstandingProvider extends ChangeNotifier {
  List<CustomerModel> _customers = [];
  List<CustomerModel> get customers => _customers;
  int cusId = 0;
  String ledgerName = "";
  String address = "";
  String panNo = "";

  String _selectedMR = '';
  String get selectedMR => _selectedMR;

   int _selectedMRID=0;
  int get selectedMRID => _selectedMRID;

  String _selectedArea = '';
  String get selectedArea => _selectedArea;

   int _selectedAreaID=0;
  int get selectedAreaID => _selectedAreaID;

  String _selectedProductCompany = '';
  String get selectedProductCompany => _selectedProductCompany;

   int _selectedProductCompanyID=0;
  int get selectedProductCompanyID => _selectedProductCompanyID;

  void selectCustomer(
      String id, String ledgerName, String address, String panNo) {
    cusId = int.parse(id);
    this.ledgerName = ledgerName.toString();
    this.address = address.toString();
    this.panNo = panNo.toString();
    notifyListeners();
  }

  set selectedMR(String data) {
    _selectedMR = data;
    notifyListeners(); //
  }

  set selectedMRID(int data) {
    _selectedMRID = data;
    notifyListeners(); //
  }

  set selectedArea(String data) {
    _selectedArea = data;
    notifyListeners();
  }

  set selectedAreaID(int data) {
    _selectedAreaID = data;
    notifyListeners();
  }

  set selectedProductCompany(String data) {
    _selectedProductCompany = data;
    notifyListeners();
  }

  set selectedProductCompanyID(int data) {
    _selectedProductCompanyID = data;
    notifyListeners();
  }

  void resetState() {
    _customers = [];
    // Implement code to reset the state of the provider
    // For example, clear selected customer and product.
    // You can also clear other relevant data.
    notifyListeners();
  }

  void clearSelection() {
    _customers = [];
    cusId = 0;
    ledgerName = "";
    address = "";
    panNo = "";
    ProductProvider productProvider = ProductProvider();
    productProvider.productList = [];
    notifyListeners();
  }


   DateTime? _selectedAsOnDate=DateTime.now();
  DateTime? get selectedAsOnDate => _selectedAsOnDate;

  late String _ageingOn='';
  String get ageingOn => _ageingOn;

  set selectedAsOnDate(DateTime? date) {
    _selectedAsOnDate = date;
    notifyListeners(); // Ensure you notify listeners after updating dateFrom
  }

  set selectedAgeingOn(String data) {
    _ageingOn = data;
    notifyListeners(); // Ensure you notify listeners after updating dateFrom
  }

  clearSelectionDate() {
    selectedAsOnDate = DateTime.now();
  }
}

