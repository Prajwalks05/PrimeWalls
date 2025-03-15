import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Color(0xFFFAF9F6), // Silky White Background
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFAF9F6), // Matching AppBar
      foregroundColor: Colors.black,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFFAF9F6),
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
    ),
  );

  bool _isDarkMode = false;

  ThemeProvider() {
    _loadTheme();
  }

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme(bool isDark) async {
    _isDarkMode = isDark;
    _themeData = isDark
        ? ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.black,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
            ),
          )
        : ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFFAF9F6),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFFAF9F6),
              foregroundColor: Colors.black,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color(0xFFFAF9F6),
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
            ),
          );

    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _themeData = _isDarkMode
        ? ThemeData.dark()
        : ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFFAF9F6),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFFAF9F6),
              foregroundColor: Colors.black,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color(0xFFFAF9F6),
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
            ),
          );
    notifyListeners();
  }
}
