import 'dart:convert';
import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/Preference/preference.dart';
import 'package:petrolpump/Utilities/utilities.dart';
import 'package:petrolpump/models/PostModel/attendence_post_model.dart';
import 'package:petrolpump/models/PostModel/user_movement_post.dart';
import 'package:petrolpump/models/attendence_checkStatus_model.dart';
import 'package:http/http.dart' as http;
import 'package:petrolpump/models/auth_model.dart';

class MyServiceAttendence {
  Future<AttendenceCheckStatus> getCheckStatus() async {
    var baseURL = await UserPreference.getUserPreference("BaseURL");
    Uri url = Uri.parse("$baseURL/api/Attendance/Status");
    var token = await UserPreference.getUserPreference("Token");

    try {
      var resposeProductCompany = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer $token',
      });
      if (resposeProductCompany.statusCode == 200) {
        var resData =
            selectAttendenceCheckStatusFromJson(resposeProductCompany.body);
        if (resData.success) {
          return resData.data;
        } else {
          throw Exception(resData.message);
        }
      } else {
        throw Exception("Not Found");
      }
    } catch (e) {
      Utilities.showToastMessage(e.toString(), AppColors.warningColor); 
      throw Exception(e.toString());
    }
  }

  Future<bool> postAttendence(AttendencePostModel model) async {
    var baseURL = await UserPreference.getUserPreference("BaseURL");
    Uri url = Uri.parse("$baseURL/api/Attendance/Create");
    var token = await UserPreference.getUserPreference("Token");
    var header = <String, String>{
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    try {
      final body = json.encode(model.toJson());
      var response = await http.post(url, headers: header, body: body);

      if (response.statusCode == 200) {
        var resData = response.body;
        final jsonResponse = json.decode(resData);
        var finalData = AuthResponse.fromJson(jsonResponse);
        if (finalData.success) {
          return true;
        }
        return false;
      } else {
        throw Exception(response);
      }
    } catch (e) {
      Utilities.showToastMessage(e.toString(), AppColors.warningColor); 
      throw Exception(e.toString());
    }
  }

  Future<bool> userMovementPost(UserMovementPostModel userMovementPostModel) async {
    var baseURL = await UserPreference.getUserPreference("BaseURL");
    Uri url = Uri.parse("$baseURL/api/UserMovement/Create");
    var token = await UserPreference.getUserPreference("Token");
    var header = <String, String>{
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    try {
      final body = json.encode(userMovementPostModel.toJson());
      var response = await http.post(url, headers: header, body: body);

      if (response.statusCode == 200) {
        var resData = response.body;
        final jsonResponse = json.decode(resData);
        var finalData = AuthResponse.fromJson(jsonResponse);
        if (finalData.success) {
          return true;
        }
        return false;
      } else {
        throw Exception(response);
      }
    } catch (e) {
     Utilities.showToastMessage(e.toString(), AppColors.warningColor); 
      throw Exception(e.toString());
    }
  }
}


