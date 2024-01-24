import 'package:flutter/material.dart';
import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/Preference/preference.dart';
import 'package:petrolpump/Utilities/utilities.dart';
import 'package:petrolpump/models/LedgerModel/fiscal_date_model.dart';
import 'package:petrolpump/models/LedgerModel/ledger_report_by_id.dart';
import 'package:http/http.dart' as http;

class LedgerService{
   Future<List<LedgerReportModelDetails>> getLedgerById(Id,[String? fromDate,String? toDate]) async {
    var baseURL = await UserPreference.getUserPreference("BaseURL");
    Uri url = Uri.parse(baseURL + "/api/Report/GetLedgerReport?Ledgerid=$Id&fromDate=$fromDate&toDate=$toDate");
    var token = await UserPreference.getUserPreference("Token");
    try {
      final responseCustomer = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token', // Make sure this is correct
        },
      );
      if (responseCustomer.statusCode == 200) {
        var resData = ledgerReportModelFromJson(responseCustomer.body);
        if (resData.success) {
          return resData.data;
        } else {
          throw Exception(resData.message);
        }
      } else {
        throw Exception("Ledger not found");
      }
    } catch (e) {
       Utilities.showToastMessage(e.toString(), AppColors.warningColor); 
      return  List.empty();
    }
  }

}

class LRFiscalDateService{
   Future<List<LrFiscalDateModelDetails>> getFiscalDate() async {
    var baseURL = await UserPreference.getUserPreference("BaseURL");
    Uri url = Uri.parse(baseURL + "/api/Report/GetFiscalYear");
    var token = await UserPreference.getUserPreference("Token");
    try {
      final responseCustomer = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token', // Make sure this is correct
        },
      );
      if (responseCustomer.statusCode == 200) {
        var resData = lrFiscalDateModelFromJson(responseCustomer.body);
        if (resData.success) {
          return resData.data;
        } else {
          throw Exception(resData.message);
        }
      } else {
        throw Exception("Date not found");
      }
    } catch (e) {
      Utilities.showToastMessage(e.toString(), AppColors.warningColor); 
      return  List.empty();
    }
  }

}