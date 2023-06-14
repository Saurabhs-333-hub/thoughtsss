import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(backgroundColor: Colors.black87),
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.grey,
    colorScheme: ColorScheme.light(
        background: const Color.fromARGB(255, 255, 255, 255)));

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme:
        AppBarTheme(backgroundColor: Color(Vx.getColorFromHex('#121212'))),
    scaffoldBackgroundColor: Color(Vx.getColorFromHex('#121212')),
    useMaterial3: true,
    colorScheme: ColorScheme.dark(background: Colors.black));
