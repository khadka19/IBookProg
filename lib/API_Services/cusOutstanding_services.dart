import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/Preference/preference.dart';
import 'package:petrolpump/Utilities/utilities.dart';
import 'package:petrolpump/models/area_model.dart';
import 'package:petrolpump/models/cusOutstandingModel.dart';
import 'package:http/http.dart'as http;
import 'package:petrolpump/models/mr_model.dart';


class CusOutstandingServices{
   Future<List<CusSplrOutstandingModelDetails>> getCusOutstanding(String date,String ageingOn,int? ledgerId,[int? selectedMR,int? selectedArea,int? selectedProductCompany]) async {
    var baseURL = await UserPreference.getUserPreference("BaseURL");
    Uri url = Uri.parse(baseURL + "/api/report/GetCustomerOutstandingReport?asonDate=$date&ageingOn=$ageingOn Date&ledgerId=$ledgerId&mrId=$selectedMR&areaId=$selectedArea&companyId=$selectedProductCompany");
    var token = await UserPreference.getUserPreference("Token");
    try {
      final responseCustomer = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token', // Make sure this is correct
        },
      );
      if (responseCustomer.statusCode == 200) {
        var resData = cussplrOutstandingModelFromJson(responseCustomer.body);
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



  Future<List<MrModelDetails>> getMR() async {
    var baseURL = await UserPreference.getUserPreference("BaseURL");
    Uri url = Uri.parse(baseURL + "/api/common/GetMrList");
    var token = await UserPreference.getUserPreference("Token");
    try {
      final responseCustomer = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token', // Make sure this is correct
        },
      );
      if (responseCustomer.statusCode == 200) {
        var resData = mrModelFromJson(responseCustomer.body);
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


  Future<List<AreaModelDetails>> getAreaList() async {
    var baseURL = await UserPreference.getUserPreference("BaseURL");
    Uri url = Uri.parse(baseURL + "/api/common/getarealist");
    var token = await UserPreference.getUserPreference("Token");
    try {
      final responseCustomer = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token', // Make sure this is correct
        },
      );
      if (responseCustomer.statusCode == 200) {
        var resData = areaModelFromJson(responseCustomer.body);
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