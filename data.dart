import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class Mytheme{
  static ThemeData lighttheme(BuildContext context)  =>
    ThemeData(
          // primarySwatch: Colors.blue,
          fontFamily: GoogleFonts.poppins().fontFamily,
          primaryTextTheme: GoogleFonts.latoTextTheme(),
          
          );
}

