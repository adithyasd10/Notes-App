import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Color(0xFFF9F9F9), // Background like the image
  cardColor: Colors.white, // White cards
  primaryColor: Color(0xFF2A2E3D), // Dark text for headings
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF2A2E3D)),
    bodyMedium: TextStyle(color: Color(0xFF2A2E3D)),
  ),
  iconTheme: const IconThemeData(color: Color(0xFF2A2E3D)),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Color(0xFF2A2E3D)),
    titleTextStyle: TextStyle(
      color: Color(0xFF2A2E3D),
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF1F2232), // Deep dark background
  cardColor: Color(0xFF2A2E3D), // Dark card background
  primaryColor: Colors.white,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
);
