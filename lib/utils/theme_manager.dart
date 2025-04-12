import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = ThemeData.light();
  bool _isDarkMode = false;
  String _currentTheme = "Zinc"; // Default theme

  // Theme color maps
  final Map<String, Color> primaryColors = {
    "Amber": const Color.fromARGB(255, 193, 222, 51),
    "Slate": const Color(0xFF334155),
    "Stone": const Color(0xFF57534E),
    "Gray": const Color(0xFF4B5563),
    "Neutral": const Color(0xFF525252),
    "Red": const Color(0xFFEF4444),
    "Rose": const Color(0xFFF43F5E),
    "Orange": const Color(0xFFF97316),
    "Green": const Color(0xFF22C55E),
    "Blue": const Color(0xFF3B82F6),
    "Yellow": const Color(0xFFEAB308),
    "Violet": const Color(0xFF8B5CF6),
  };

  ThemeProvider() {
    _loadTheme();
  }

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _isDarkMode;
  String get currentTheme => _currentTheme;

  // Get the current primary color based on theme selection
  Color get primaryColor =>
      primaryColors[_currentTheme] ?? const Color(0xFF4338CA);

  // Get gradient colors for appbar based on theme and mode
  List<Color> get gradientColors {
    if (_isDarkMode) {
      return [Colors.black, Colors.grey[900]!];
    } else {
      Color baseColor = primaryColors[_currentTheme] ?? const Color(0xFF4338CA);
      return [baseColor, baseColor.withOpacity(0.7)];
    }
  }

  // Toggle between light and dark mode
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _updateThemeData();
    _saveTheme();
    notifyListeners();
  }

  // Set specific color theme
  void setTheme(String themeName) {
    if (primaryColors.containsKey(themeName)) {
      _currentTheme = themeName;
      _updateThemeData();
      _saveTheme();
      notifyListeners();
    }
  }

  // Update theme data based on current settings
  void _updateThemeData() {
    Color primaryColor =
        primaryColors[_currentTheme] ?? const Color(0xFF4338CA);

    if (_isDarkMode) {
      _themeData = ThemeData.dark().copyWith(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.dark(
          primary: primaryColor,
          secondary: primaryColor.withOpacity(0.7),
        ),
      );
    } else {
      _themeData = ThemeData.light().copyWith(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          secondary: primaryColor.withOpacity(0.7),
        ),
      );
    }
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _currentTheme = prefs.getString('selectedTheme') ?? 'Zinc';
    _updateThemeData();
    notifyListeners();
  }

  Future<void> _saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    await prefs.setString('selectedTheme', _currentTheme);
  }
}
