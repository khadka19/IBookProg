import 'package:flutter/material.dart';

class AppColors {
  static const Color kPrimaryColor = Color(0xFF3491cb);
  static const Color borderColor = Color.fromARGB(255, 12, 94, 15);
  static const Color successColor=Color(0xFF009C41);
  static const Color warningColor=Color.fromARGB(255, 209, 83, 74);
  static const Color alternativeColor=Color.fromARGB(255, 233, 242, 244);
  // static const Color kPrimaryColor= Color(0xFF2b8994);
  static const kPrimaryGradientColor1 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 238, 237, 235),
      Color.fromARGB(255, 91, 90, 89)
    ],
  );
  static const Color nearlyDarkBlue = Color(0xFF2633C5);
  static const red = Color(0xFFDB3022);
}
