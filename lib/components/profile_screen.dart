import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simpleapp/utils/theme_manager.dart';
import '../screen/login_screen.dart';
import '../components/image_picker_component.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? profilePhoto;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadLoginState();
  }

  Future<void> _loadLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      profilePhoto = prefs.getString('profilePhoto');
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      isLoggedIn = false;
      profilePhoto = null;
    });
  }

  void _refreshImage() {
    _loadLoginState(); // Reloads profile image in real-time
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileImagePicker(onImagePicked: _refreshImage),
              const SizedBox(height: 20),
              isLoggedIn
                  ? ElevatedButton(
                      onPressed: _logout,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            isDarkMode ? Colors.black : Colors.blue), // button color
                        foregroundColor: MaterialStateProperty.all(Colors.white), // text color
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
                      ),
                      child: const Text("Logout"),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            isDarkMode ? Colors.black : Colors.blue), // button color
                        foregroundColor: MaterialStateProperty.all(Colors.white), // text color
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
                      ),
                      child: const Text("Login"),
                    ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[850] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode ? Colors.black : Colors.white,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Theme",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black, // Explicit solid text color
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: themeProvider.primaryColors.entries.map((entry) {
                        final themeName = entry.key;
                        final color = entry.value;
                        final isSelected = themeProvider.currentTheme == themeName;

                        return InkWell(
                          onTap: () {
                            themeProvider.setTheme(themeName);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected ? color : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  themeName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: isDarkMode ? Colors.white : Colors.black, // Explicit solid text color
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
