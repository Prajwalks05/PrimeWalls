import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = ThemeData.light();
  String _currentTheme = "Zinc"; // Default theme

  final Map<String, ThemeData> themes = {
    "Zinc": ThemeData.dark(),
    "Slate": ThemeData(primarySwatch: Colors.blueGrey),
    "Stone": ThemeData(primarySwatch: Colors.brown),
    "Gray": ThemeData(primarySwatch: Colors.grey),
    "Neutral": ThemeData(primarySwatch: Colors.blueGrey),
    "Red": ThemeData(primarySwatch: Colors.red),
    "Rose": ThemeData(primarySwatch: Colors.pink),
    "Orange": ThemeData(primarySwatch: Colors.orange),
    "Green": ThemeData(primarySwatch: Colors.green),
    "Blue": ThemeData(primarySwatch: Colors.blue),
    "Yellow": ThemeData(primarySwatch: Colors.yellow),
    "Violet": ThemeData(primarySwatch: Colors.purple),
  };

  ThemeProvider() {
    _loadTheme();
  }

  ThemeData get themeData => _themeData;
  String get currentTheme => _currentTheme;

  void setTheme(String themeName) async {
    if (themes.containsKey(themeName)) {
      _themeData = themes[themeName]!;
      _currentTheme = themeName;
      notifyListeners();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedTheme', themeName);
    }
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedTheme = prefs.getString('selectedTheme');
    if (savedTheme != null && themes.containsKey(savedTheme)) {
      _themeData = themes[savedTheme]!;
      _currentTheme = savedTheme;
      notifyListeners();
    }
  }
}
