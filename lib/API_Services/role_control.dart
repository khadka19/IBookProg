import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/Preference/preference.dart';
import 'package:http/http.dart' as http;
import 'package:petrolpump/Utilities/utilities.dart';
import 'package:petrolpump/models/role_control_model.dart';

class RoleCheckServices {

  roleCheckCreateOrder() async {
    var baseURL = await UserPreference.getUserPreference("BaseURL");
    Uri url = Uri.parse(baseURL +
        "/api/Common/GetIsmenuaccess?parentId=217&menuId=219&actionType=Add");
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
        var resData = roleControlModelFromJson(responseCustomer.body);
        if (resData.success) {
         return resData.data ?? false; 
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      Utilities.showToastMessage("Error :${e.toString()}", AppColors.warningColor);
      return List.empty();
    }
  }

   roleCheckSalesBill() async {
    var baseURL = await UserPreference.getUserPreference("BaseURL");
    Uri url = Uri.parse(baseURL +
        "/api/Common/GetIsmenuaccess?parentId=242&menuId=244&actionType=Add");
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
        var resData = roleControlModelFromJson(responseCustomer.body);

        if (resData.success) {
         return resData.data ?? false; 
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      Utilities.showToastMessage("Error :${e.toString()}", AppColors.warningColor);
      return List.empty();
    }
  }

  roleCheckViewOrder() async {
    var baseURL = await UserPreference.getUserPreference("BaseURL");
    Uri url = Uri.parse(baseURL +
        "/api/Common/GetIsmenuaccess?parentId=217&menuId=222&actionType=List");
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
        var resData = roleControlModelFromJson(responseCustomer.body);

        if (resData.success) {
         return resData.data ?? false; 
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      Utilities.showToastMessage("Error :${e.toString()}", AppColors.warningColor);
      return List.empty();
    }
  }

   roleCheckLedgerReport() async {
    var baseURL = await UserPreference.getUserPreference("BaseURL");
    Uri url = Uri.parse(baseURL +
        "/api/Common/GetIsmenuaccess?parentId=543&menuId=544&actionType=View");
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
        var resData = roleControlModelFromJson(responseCustomer.body);

        if (resData.success) {
         return resData.data ?? false; 
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
       Utilities.showToastMessage("Error :${e.toString()}", AppColors.warningColor);
      return List.empty();
    }
  }

  roleCheckCustomerOutstanding() async {
    var baseURL = await UserPreference.getUserPreference("BaseURL");
    Uri url = Uri.parse(baseURL +
        "/api/Common/GetIsmenuaccess?parentId=542&menuId=551&actionType=View");
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
        var resData = roleControlModelFromJson(responseCustomer.body);

        if (resData.success) {
         return resData.data ?? false; 
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
       Utilities.showToastMessage("Error :${e.toString()}", AppColors.warningColor);
      return List.empty();
    }
  }

   roleCheckSupplierOutstanding() async {
    var baseURL = await UserPreference.getUserPreference("BaseURL");
    Uri url = Uri.parse(baseURL +
        "/api/Common/GetIsmenuaccess?parentId=542&menuId=555&actionType=View");
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
        var resData = roleControlModelFromJson(responseCustomer.body);

        if (resData.success) {
         return resData.data ?? false; 
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
       Utilities.showToastMessage("Error :${e.toString()}", AppColors.warningColor);
      return List.empty();
    }
  }

  roleCheckTrialStock() async {
    var baseURL = await UserPreference.getUserPreference("BaseURL");
    Uri url = Uri.parse(baseURL +
        "/api/Common/GetIsmenuaccess?parentId=713&menuId=714&actionType=View");
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
        var resData = roleControlModelFromJson(responseCustomer.body);

        if (resData.success) {
         return resData.data ?? false; 
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
       Utilities.showToastMessage("Error :${e.toString()}", AppColors.warningColor);
      return List.empty();
    }
  }
}
