import 'package:flutter/material.dart';
import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/CommonWidgets/constants_text.dart';

// ignore: must_be_immutable
class CustomAppBarWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final Color buttonColor;
  final String buttonText;
  final BuildContext context;
  final bool isLoadingReplaceBtn; // Add isLoading parameter

  CustomAppBarWidget({
    required this.onPressed,
    required this.buttonColor,
    required this.buttonText,
    required this.context,
    required this.isLoadingReplaceBtn, // Add isLoading parameter
  });
   @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      
      onPressed: isLoadingReplaceBtn ? null : onPressed, // Disable button if loading
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.kPrimaryColor,
        primary: buttonColor,
      ),
      child: isLoadingReplaceBtn
          ? Text(ContstantsText.loadingText,style: TextStyle(fontSize: 16),)
          : Text(
              buttonText,
              style: TextStyle(fontSize: 16),
            ),
    );
  }
}