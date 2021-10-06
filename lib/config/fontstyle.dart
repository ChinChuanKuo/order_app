import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_app/config/config.dart';
import 'package:order_app/widgets/widgets.dart';

class Fontstyle {
  static final title = GoogleFonts.dmSans(
    textStyle: TextStyle(
      color: Palette.facebookBlue,
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
    ),
  );

  static header(Color? color) => GoogleFonts.roboto(
        textStyle: TextStyle(
          fontSize: Responsive.isDevice() ? 18.0 : 16.0,
          color: color,
          fontWeight: FontWeight.w700,
        ),
      );

  static subtitle(Color? color) => GoogleFonts.roboto(
        textStyle: TextStyle(
          fontSize: Responsive.isDevice() ? 16.0 : 14.0,
          color: color,
          fontWeight: FontWeight.w400,
        ),
      );

  static info(Color? color) => GoogleFonts.roboto(
        textStyle: TextStyle(
          fontSize: Responsive.isDevice() ? 15.0 : 13.0,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      );

  static subinfo(Color? color) => GoogleFonts.roboto(
        textStyle: TextStyle(
          fontSize: Responsive.isDevice() ? 13.5 : 12.0,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      );

  static device(Color? color) => GoogleFonts.roboto(
        textStyle: TextStyle(
          color: color,
          fontSize: Parameter.textSize,
        ),
      );
}
