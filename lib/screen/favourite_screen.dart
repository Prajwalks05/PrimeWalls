import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpleapp/components/appbar.dart'; // Assuming you have a custom app bar
import 'package:simpleapp/components/bottomnav.dart'; // Correct import here
import 'package:simpleapp/utils/theme_manager.dart'; // Assuming ThemeManager is in utils

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => FavouriteScreenState();
}

class FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    // Get current theme provider
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      // Custom AppBar with theme toggle button
      appBar: const GradientAppBarFb1(title: 'Flutter Wallpapers'),
      // Body of the screen
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Your Favourite Wallpapers",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Add content for the favourites list here
              // For example, a list of images or widgets
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarFb2(currentIndex: 2),
    );
  }
}
