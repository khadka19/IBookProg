import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/Preference/preference.dart';
import 'package:petrolpump/Utilities/utilities.dart';
import 'package:http/http.dart'as http;
import 'package:petrolpump/models/trailStock_brach_model.dart';
import 'package:petrolpump/models/trial_stock_model.dart';


class TrialStockServices{
   Future<List<TrialStockModelDetails>> getTrialStockList(String balanceType,[int? branchId,int? companyId]) async {
    var baseURL = await UserPreference.getUserPreference("BaseURL");
    Uri url = Uri.parse(baseURL + "/api/report/gettrialstockreport?balanceType=$balanceType&branch=$branchId&product=$companyId");
    var token = await UserPreference.getUserPreference("Token");
    try {
      final responseCustomer = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token', // Make sure this is correct
        },
      );
      if (responseCustomer.statusCode == 200) {
        var resData = trialStockModelFromJson(responseCustomer.body);
        if (resData.success) {
          return resData.data;
        } else {
          throw Exception(resData.message);
        }
      } else {
        throw Exception("Customer not found");
      }
    } catch (e) {
      Utilities.showToastMessage("Error :${e.toString()}", AppColors.warningColor);
      return List.empty();
    }
  }


    Future<List<TrialStockBranchDetails>> getTrialStockBranch() async {
    var baseURL = await UserPreference.getUserPreference("BaseURL");
    Uri url = Uri.parse(baseURL + "/api/report/getallbranch");
    var token = await UserPreference.getUserPreference("Token");
    print(token);
    try {
      final responseCustomer = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token', // Make sure this is correct
        },
      );

      if (responseCustomer.statusCode == 200) {
        var resData = trialStockBranchFromJson(responseCustomer.body);

        if (resData.success) {
          return resData.data;
        } else {
          throw Exception(resData.message);
        }
      } else {
        throw Exception("Customer not found");
      }
    } catch (e) {
      Utilities.showToastMessage(e.toString(), AppColors.warningColor); 
      throw Exception(e.toString());
    }
  }
}