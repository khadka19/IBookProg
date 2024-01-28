import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/Preference/preference.dart';
import 'package:petrolpump/Utilities/api_url.dart';
import 'package:petrolpump/Utilities/utilities.dart';
import 'package:petrolpump/models/auth_model.dart';
import 'package:petrolpump/models/companyName_model.dart';
import 'package:petrolpump/models/user_name_model.dart';

class AuthService {

  getCompanyName(String userName,String password) async {
    var baseURL = await UserPreference.getUserPreference("BaseURL");
    Uri url = Uri.parse(baseURL + "/api/Common/GetCompaniesUsingUserCredentials?username=$userName&password=$password");

// Set loading state to true
    // Introduce a delay of at least 2 seconds with a CircularProgressIndicator
    await Future.delayed(const Duration(seconds: 2), () {
      
    });

    var res = await http.get(url);
    try {
      if (res.statusCode == 200) {
        var data = postModelFromJson(res.body);
        return data.data;
      } else {
        print("Error");
      }
    } catch (e) {
      Utilities.showToastMessage(e.toString(), AppColors.warningColor); 
      throw Exception(e.toString());
    }
  }

//username method
  getUserName(String? name) async {
    Uri url = Uri.parse("${ApiURLs.licenseURL}?user=$name");
    try {
      var res = await http.get(url);
      if (res.statusCode == 200) {
        var data = userNameModelFromJson(res.body);
        if (data.error == false && data.data!=null) {
          //for static
          // var staticURL ="http://194.163.134.186:2007"; 
        var staticURL= data.data;  
          UserPreference.setUserPreference("BaseURL", staticURL!);
          return staticURL;
        }
        else{
         return;
        }
      }

    } catch (e) {
      Utilities.showToastMessage(e.toString(), AppColors.warningColor); 
      throw Exception(e.toString());
    }
  }


  Future<AuthResponse> login(AuthRequest request) async {
    var baseURL = await UserPreference.getUserPreference("BaseURL");

    var reqData = jsonEncode(request.toJson());
    var reqUrl = Uri.parse(baseURL + "/api/Auth/Login");

    // var reqUrl = Uri.parse("http://194.163.134.186:2007/api/Auth/Login");

    try {
      final response = await http.post(
        reqUrl,
        headers: <String, String>{
          'Content-Type': 'application/json', // Make sure this is correct
        },
        body: reqData,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        var finalData = AuthResponse.fromJson(jsonData);
        if (finalData.success) {
          UserPreference.setUserPreference('CompanyName', request.company);
          UserPreference.setUserPreference('Token', finalData.data!.token.toString());
          return finalData;
        }
      
        else{
          throw Exception(finalData.message);
        }
      } else {
       
        throw Exception(json.decode(response.body));
      }
    } catch (e) {
     Utilities.showToastMessage(e.toString(), AppColors.warningColor); 
      throw Exception(e.toString());
    }
  }
}
