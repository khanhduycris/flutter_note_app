import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
const Color yellowCrl = Color(0xFFFFB746);
const Color pinkCrl = Color(0xFFff4667);
const Color bluishCrl = Color(0xFF4e5ae8);
const Color primakyClr = bluishCrl;
const Color white = Colors.white;
const Color darkHelper = Color(0xFF424242);
const Color darkGreyClr = Color(0xFF121212);
Color daskHeaderClr = Color(0xFF424242);
class Themes{
  static final light = ThemeData(
    backgroundColor: Colors.white,
    primaryColor: primakyClr,
    brightness: Brightness.light,
  );


  static final dark = ThemeData(
    backgroundColor: darkHelper,
    primaryColor: darkHelper,
    brightness: Brightness.dark,
  );
}

TextStyle get subHeadingStyle{
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode?Colors.grey[400]:Colors.grey
    )
  );
}

TextStyle get headingStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        color: Get.isDarkMode?Colors.white:Colors.black
      )
  );
}

TextStyle get titleStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Get.isDarkMode?Colors.white:Colors.black
      )
  );
}

TextStyle get suTitleStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Get.isDarkMode?Colors.grey[100]:Colors.grey[700]
      )
  );
}