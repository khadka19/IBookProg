import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: must_be_immutable
class SmallText extends StatelessWidget {
  final String text;
  double size;
  TextOverflow overflow;
  Color color;
  TextAlign textAlign;

  SmallText(
      {required this.text,
      required this.size,
      this.overflow = TextOverflow.ellipsis,
      required this.color,
      required this.textAlign,
      
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      maxLines: 1,
      style: GoogleFonts.lato(
        fontSize: 12,
        color: Colors.blue
      ),
    );
  }
}
