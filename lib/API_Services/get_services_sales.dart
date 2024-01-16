import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/Preference/preference.dart';
import 'package:petrolpump/Utilities/utilities.dart';
import 'package:petrolpump/models/customer_model.dart';
import 'package:petrolpump/models/product_model.dart';

class MyService {
//customer get method
  Future<List<CustomerModel>> getCustomerName() async {
    var baseURL = await UserPreference.getUserPreference("BaseURL");
    Uri url = Uri.parse(baseURL + "/api/Common/CustomerList");
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
        var resData = selectCustomerModelFromJson(responseCustomer.body);

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

//customer post method
  Future<void> createCustomer(String name, String address) async {
    var baseURL = await UserPreference.getUserPreference("BaseURL");
    Uri url = Uri.parse("$baseURL/api/Common/CreateCustomer");

    var token = await UserPreference.getUserPreference("Token");

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> requestBody = {
      'name': name,
      'address': address,
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Handle success, if needed
      } else {
        throw Exception("Failed to create customer");
      }
    } catch (e) {
       Utilities.showToastMessage(e.toString(), AppColors.warningColor); 
      throw Exception(e.toString());
    }
  }

  //product get method
  Future<List<ProductModel>> getproductDetails(int? cusId,
      [int? compId]) async {
    var baseURL = await UserPreference.getUserPreference("BaseURL");
    Uri url = Uri.parse(
        "$baseURL/api/Common/ProductList?customerId=$cusId&companyId=$compId");
    var token = await UserPreference.getUserPreference("Token");
    try {
      var responseProduct = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token', // Make sure this is correct
        },
      );

      if (responseProduct.statusCode == 200) {
        var resData = selectProductModelFromJson(responseProduct.body);
        print(responseProduct.body);
        if (resData.success) {
          return resData.data;
        } else {
          throw Exception(resData.message);
        }
      } else {
        throw Exception("Product not found");
      }
    } catch (e) {
     Utilities.showToastMessage(e.toString(), AppColors.warningColor); 
      return  List.empty();
    }
  }
}
