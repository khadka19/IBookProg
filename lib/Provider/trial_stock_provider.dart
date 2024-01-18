import 'package:flutter/material.dart';

class TrialStockProvider extends ChangeNotifier{
 String _selectedProductCompany = '';
  String get selectedProductCompany => _selectedProductCompany;

   int _selectedProductCompanyId=0;
  int get selectedProductCompanyId => _selectedProductCompanyId;

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
}