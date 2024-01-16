import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:petrolpump/CommonWidgets/colors.dart';

class Utilities {
  static showToastMessage(String message, Color color,
      [bool isSuccess = true]) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: isSuccess == true
            ?AppColors.successColor
            : AppColors.warningColor,
        fontSize: 14.0 //message font size
        );
  }
  static void showSnackBar(BuildContext context, String message,
      [bool isSuccess = true]) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        duration: const Duration(seconds: 2),
        backgroundColor: isSuccess == true
            ? AppColors.successColor
            :AppColors.warningColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        )));
  }
}
