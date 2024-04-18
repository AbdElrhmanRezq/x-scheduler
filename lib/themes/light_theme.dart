import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.black),
        color: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
        centerTitle: true),
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
        background: Colors.white,
        primary: Colors.black,
        secondary: Colors.grey));
