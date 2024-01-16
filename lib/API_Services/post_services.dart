import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/CommonWidgets/common_model.dart';
import 'package:petrolpump/Preference/preference.dart';
import 'package:petrolpump/Utilities/utilities.dart';
import 'package:petrolpump/models/PostModel/delete_order.dart';
import 'package:petrolpump/models/PostModel/invoice_model.dart';
import 'package:petrolpump/models/PostModel/orderList_model.dart';
import 'package:petrolpump/models/PostModel/orderResponseList_model.dart';
import 'package:petrolpump/models/PostModel/productOrder_post_model.dart';
import 'package:petrolpump/models/PostModel/productSales_post_model.dart';
import 'package:http/http.dart' as http;

class MyServiceSalesPost {
  Future<Invoice> postSalesProductModel(ProductSalesPostModel model) async {
    try {
      var baseURL = await UserPreference.getUserPreference("BaseURL");
      Uri url = Uri.parse("$baseURL/api/SalesPos/Create");
      var token = await UserPreference.getUserPreference("Token");
      final headers = <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      final body = json.encode(model.toJson());
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        var successResponse = response.body;
        final Map<String, dynamic> jsonResponse = json.decode(successResponse);
        final invoice = Invoice.fromJson(jsonResponse);
        if (invoice.success) {
          return invoice;
        } else {
          throw Exception(
              Utilities.showToastMessage(response.body, Colors.red));
        }
      } else {
        throw Exception(Utilities.showToastMessage(response.body, Colors.red));
      }
    } catch (e) {
      Utilities.showToastMessage("Error :${e.toString()}", AppColors.warningColor);
      throw Exception(e.toString());
    }
  }
}

class MyServiceOrderPost {
  Future postOrderProductModel(
      ProductOrderPostModel model) async {
    try {
      var baseURL = await UserPreference.getUserPreference("BaseURL");
      Uri url = Uri.parse("$baseURL/api/SalesOrder/Create");
      var token = await UserPreference.getUserPreference("Token");
      final headers = <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      final body = json.encode(model.toJson());
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
       
        var resData=selectCommonModel(response.body);
        if(resData.success){
          Utilities.showToastMessage(resData.message, AppColors.successColor);
        }
       else{
        Utilities.showToastMessage(resData.message, AppColors.warningColor);
       }
      }
    } catch (e) {
       Utilities.showToastMessage("Error :${e.toString()}", AppColors.warningColor);
      return List.empty();
    }
  
  }
}

class MyServiceOrderList {
  Future<List<OrderResponseDetails>> postOrderList(OrderListModel model) async {
    try {
      var baseURL = await UserPreference.getUserPreference("BaseURL");
      Uri url = Uri.parse("$baseURL/api/SalesOrder/List");
      var token = await UserPreference.getUserPreference("Token");
      final headers = <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      final body = json.encode(model.toJson());
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        String jsonString = response.body;
        Map<String, dynamic> jsonData = json.decode(jsonString);

        List<OrderResponseDetails> orders = (jsonData['data'] as List)
            .map((orderJson) => OrderResponseDetails.fromJson(orderJson))
            .toList();

        return orders;
      } else {
        // Handle non-200 status code here if needed
        Utilities.showToastMessage("Error: ${response.statusCode}", Colors.red);
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      Utilities.showToastMessage("Error :${e.toString()}", AppColors.warningColor);
      return List.empty();
    }
  }
}

class MyServiceDeleteOrder {
  Future<DeleteOrderModel> postDeleteOrder(Id) async {
    var baseURL = await UserPreference.getUserPreference("BaseURL");
    Uri url = Uri.parse('$baseURL/api/SalesOrder/Delete');
    var token = await UserPreference.getUserPreference("Token");
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    final body = jsonEncode({"Id": Id});
    final response = await http.post(url,
        // Assuming 'data.id' is the order ID
        headers: headers,
        body: body);

    if (response.statusCode == 200) {
      return DeleteOrderModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to delete order');
    }
    
  }
}
