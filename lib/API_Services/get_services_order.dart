import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/Preference/preference.dart';
import 'package:petrolpump/Utilities/utilities.dart';
import 'package:petrolpump/models/product_company_model.dart';
import 'package:http/http.dart'as http;

class MyServiceOrder{
   Future<List<ProductCompanyModel>> getProductCompanyDetails() async {
    var baseURL = await UserPreference.getUserPreference("BaseURL");
    Uri url = Uri.parse("$baseURL/api/Common/ProductCompanyList");
    var token = await UserPreference.getUserPreference("Token");

    try {
      var resposeProductCompany = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer $token',
      });
      if (resposeProductCompany.statusCode == 200) {
        var resData =
            selectProductCompanyModelFromJson(resposeProductCompany.body);
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