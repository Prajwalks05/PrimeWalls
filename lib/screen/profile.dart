import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simpleapp/screen/login_screen.dart';
import 'package:simpleapp/utils/theme_manager.dart';
import 'package:simpleapp/components/image_picker_component.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String profilePhoto = '';
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      profilePhoto = prefs.getString('profilePhoto') ?? '';
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('profilePhoto');

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: themeProvider.primaryColor,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLoggedIn
                      ? Column(
                          children: [
                            ProfileImagePicker(
                                onImagePicked: _checkLoginStatus),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _logout,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeProvider.primaryColor,
                              ),
                              child: const Text("Logout",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              "You are not logged in",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeProvider.primaryColor,
                              ),
                              child: const Text("Login",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildThemeCustomization(context, themeProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeCustomization(
      BuildContext context, ThemeProvider themeProvider) {
    bool isDarkMode = themeProvider.isDarkMode;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Customize",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Text(
              "Customize your Primewalls UI experience.",
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Theme Mode",
                    style: TextStyle(
                        fontSize: 18,
                        color: isDarkMode ? Colors.white : Colors.black)),
                Switch(
                  value: isDarkMode,
                  activeColor: themeProvider.primaryColor,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Theme",
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 12,
              children: [
                _buildThemeColorOption(context, "Amber", themeProvider),
                _buildThemeColorOption(context, "Slate", themeProvider),
                _buildThemeColorOption(context, "Stone", themeProvider),
                _buildThemeColorOption(context, "Gray", themeProvider),
                _buildThemeColorOption(context, "Red", themeProvider),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeColorOption(
      BuildContext context, String themeName, ThemeProvider themeProvider) {
    final isSelected = themeProvider.currentTheme == themeName;
    final color = themeProvider.primaryColors[themeName]!;

    return GestureDetector(
      onTap: () {
        themeProvider.setTheme(themeName);
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? color : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(themeName,
                style: TextStyle(
                    color: themeProvider.isDarkMode
                        ? Colors.white
                        : Colors.black)),
          ],
        ),
      ),
    );
  }
}
