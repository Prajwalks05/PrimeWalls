import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpleapp/utils/theme_manager.dart';

class GradientAppBarFb1 extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  @override
  final Size preferredSize;

  const GradientAppBarFb1({
    super.key,
    required this.title,
    this.showBackButton = true,
  }) : preferredSize = const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDark = themeProvider.isDarkMode;

    return AppBar(
      title: Text(
        title,
        style: TextStyle(color: isDark ? Colors.white : Colors.white),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: themeProvider.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      automaticallyImplyLeading: showBackButton,
    );
  }
}
