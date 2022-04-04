import 'package:flutter/material.dart';

ThemeData buildTheme() {
  return ThemeData(
      primaryColor: Colors.green[800],
      colorScheme: ColorScheme.light().copyWith(
        primary: Colors.green[600],
        secondary: Colors.blueAccent[700],
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blueAccent[700],
        textTheme: ButtonTextTheme.primary,
      ));
}