import 'package:flutter/material.dart';

class TrialStockProvider extends ChangeNotifier{
 String _selectedProductCompany = '';
  String get selectedProductCompany => _selectedProductCompany;

   int _selectedProductCompanyId=0;
  int get selectedProductCompanyId => _selectedProductCompanyId;

   String _selectedProductGroup = '';
  String get selectedProductGroup => _selectedProductGroup;

   int _selectedProductGroupId=0;
  int get selectedProductGroupId => _selectedProductGroupId;

   String _selectedProductName = '';
  String get selectedProductName => _selectedProductName;

   int _selectedProductNameId=0;
  int get selectedProductNameId => _selectedProductNameId;

   String _selectedBalanceType = '';
  String get selectedBalanceType => _selectedBalanceType;

  int _selectedBranchId=0;
  int get selectedBranchId => _selectedBranchId;

  String _selectedBranch='';
  String get selectedBranch=>_selectedBranch;

  set selectedProductCompany(String data) {
    _selectedProductCompany = data;
    notifyListeners();
  }

  set selectedProductCompanyId(int data) {
    _selectedProductCompanyId = data;
    notifyListeners();
  }

    set selectedProductGroup(String data) {
    _selectedProductGroup = data;
    notifyListeners();
  }

  set selectedProductGroupId(int data) {
    _selectedProductGroupId = data;
    notifyListeners();
  }

   set selectedProductName(String data) {
    _selectedProductName = data;
    notifyListeners();
  }

  set selectedProductNameId(int data) {
    _selectedProductNameId = data;
    notifyListeners();
  }

  set selectedBalanceType(String data){
    _selectedBalanceType=data;
    notifyListeners();
   
  }
   set selectedBranch(String data){
      _selectedBranch=data;
      notifyListeners();
    }
    set selectedBranchId(int data){
      _selectedBranchId=data;
      notifyListeners();
    }

//  trialStock Date Provider

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