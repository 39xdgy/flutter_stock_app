import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

CustomTheme currentTheme = CustomTheme();

class CustomTheme with ChangeNotifier {
  static bool _isDarkTheme = false;
  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    var hour = int.parse(DateFormat.H().format(DateTime.now()));
    var minute = int.parse(DateFormat.m().format(DateTime.now()));
    if (hour >= 16 || hour < 9) {
      _isDarkTheme = true;
    } else if (hour == 9 && minute < 30) {
      _isDarkTheme = true;
    } else {
      _isDarkTheme = false;
    }
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: const Color.fromARGB(255, 199, 43, 131),
      scaffoldBackgroundColor: const Color.fromARGB(255, 43, 199, 186),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: Color.fromARGB(255, 32, 99, 156),
      scaffoldBackgroundColor: Color.fromARGB(255, 37, 37, 37),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 208, 208, 208),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }
}
