import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petrolpump/CommonWidgets/colors.dart';

class NetworkErrorDialog extends StatelessWidget {
  const NetworkErrorDialog({Key? key, this.onPressed}) : super(key: key);

  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.12,
              child: Image.asset('assets/images/InternetConnectionError.png')),
          const SizedBox(height: 32),
          Text(
            "Whoops!",
            style:
                GoogleFonts.aboreto(fontSize: 16, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            "No internet connection found.",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            "Check your connection and try again.",
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shadowColor: Colors.black,
                backgroundColor: AppColors.kPrimaryColor),
            onPressed: onPressed,
            child: const Text("Try Again"),
          )
        ],
      ),
    );
  }
}