// ignore_for_file: file_names
//dark and light theme
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Mythemes {
  static final darkTheme = ThemeData(
    appBarTheme: AppBarTheme(backgroundColor: HexColor("#3700B3")),
    scaffoldBackgroundColor: HexColor("#3700B3"),
    colorScheme: ColorScheme.dark(
        primary: HexColor("#03dac5"),
        primaryContainer: HexColor("#121212"),
        onPrimaryContainer: Colors.white,
        onBackground: Colors.white,
        background: HexColor("#3700B3")),
  );
  static final lightTheme = ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: HexColor("#4169E1"),
      ),
      scaffoldBackgroundColor: HexColor("#4169E1"),
      colorScheme: ColorScheme.light(
        onBackground: Colors.white,
        primaryContainer: Colors.white,
        onPrimaryContainer: Colors.black,
        primary: HexColor("#4169E1"),
        background: HexColor("#4169E1"),
      ));
}
