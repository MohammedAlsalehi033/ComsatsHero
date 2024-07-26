import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyThemes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.merriweather(),
      displaySmall: GoogleFonts.pacifico(),
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.purple,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.merriweather(),
      displaySmall: GoogleFonts.pacifico(),
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.purple,
      brightness: Brightness.dark,
    ),
  );

  static final greenTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.green,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.merriweather(),
      displaySmall: GoogleFonts.pacifico(),
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.green,
      brightness: Brightness.light,
    ),
  );

  static final redTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.red,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.merriweather(),
      displaySmall: GoogleFonts.pacifico(),
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.red,
      brightness: Brightness.light,
    ),
  );

  static final orangeTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.orange,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.merriweather(),
      displaySmall: GoogleFonts.pacifico(),
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.orange,
      brightness: Brightness.light,
    ),
  );

  static final tealTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.teal,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.merriweather(),
      displaySmall: GoogleFonts.pacifico(),
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.teal,
      brightness: Brightness.light,
    ),
  );
}
