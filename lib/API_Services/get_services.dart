import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/Preference/preference.dart';
import 'package:petrolpump/Utilities/utilities.dart';
import 'package:petrolpump/models/order_details.dart';
import 'package:http/http.dart' as http;

class OrderServices{
  Future<List<OrderDetailsModelDetails>> getOrderDetails(int Id) async {
    var baseURL = await UserPreference.getUserPreference("BaseURL");
    Uri url = Uri.parse("$baseURL/api/SalesOrder/Detail?Id=$Id");
    var token = await UserPreference.getUserPreference("Token");

    try {
      var responseProduct = await http.get(
       url,
        headers: <String, String>{
          'Authorization': 'Bearer $token', // Make sure this is correct
        },
      );

      if (responseProduct.statusCode == 200) {
        var resData = orderDetailsModelFromJson(responseProduct.body);
        print(responseProduct.body);
        if (resData.success) {
          return resData.data;
        } else {
          throw Exception(resData.message);
        }
      } else {
        throw Exception("Order not found");
      }
    } catch (e) {
    Utilities.showToastMessage(e.toString(), AppColors.warningColor); 
      return  List.empty();
    }
  }
}