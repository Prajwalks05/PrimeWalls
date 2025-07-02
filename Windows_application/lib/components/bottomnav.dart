import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simpleapp/utils/theme_manager.dart';
import 'package:simpleapp/screen/homescreen.dart';
import 'package:simpleapp/screen/search.dart';
import 'package:simpleapp/screen/favourite_screen.dart';
import 'package:simpleapp/screen/profile.dart';
import 'package:simpleapp/screen/login_screen.dart';

class BottomNavBarFb2 extends StatefulWidget {
  final int currentIndex;
  const BottomNavBarFb2({super.key, required this.currentIndex});

  @override
  _BottomNavBarFb2State createState() => _BottomNavBarFb2State();
}

class _BottomNavBarFb2State extends State<BottomNavBarFb2> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.currentIndex;
  }

  void _navigateToScreen(BuildContext context, int index, Widget screen) {
    if (selectedIndex == index) return;

    setState(() {
      selectedIndex = index;
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    ).then((_) {
      setState(() {
        selectedIndex = widget.currentIndex;
      });
    });
  }

  Future<void> _checkLoginAndNavigate(
      BuildContext context, int index, Widget screen) async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      _navigateToScreen(context, index, screen);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('You must be logged in to access this page.'),
          action: SnackBarAction(
            label: 'Login',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;
        final selectedColor = isDarkMode ? Colors.white : Colors.black;
        final unselectedColor =
            isDarkMode ? Colors.grey[500]! : Colors.grey[700]!;

        return ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            color: isDarkMode ? Colors.black : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: NavigationRail(
                selectedIndex: selectedIndex,
                onDestinationSelected: (int index) {
                  switch (index) {
                    case 0:
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      );
                      break;
                    case 1:
                      _navigateToScreen(context, 1, const SearchScreen());
                      break;
                    case 2:
                      _checkLoginAndNavigate(context, 2, const FavouritesScreen());
                      break;
                    case 3:
                      _navigateToScreen(context, 3, const ProfileScreen());
                      break;
                  }
                },
                labelType: NavigationRailLabelType.all,
                selectedLabelTextStyle: TextStyle(color: selectedColor),
                unselectedLabelTextStyle: TextStyle(color: unselectedColor),
                selectedIconTheme: IconThemeData(color: selectedColor),
                unselectedIconTheme: IconThemeData(color: unselectedColor),
                backgroundColor: isDarkMode ? Colors.black : Colors.white,
                groupAlignment: 0.0, // Center vertically
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: Text("Home"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.search_outlined),
                    selectedIcon: Icon(Icons.search),
                    label: Text("Search"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(AntDesign.heart_outline),
                    selectedIcon: Icon(Icons.favorite),
                    label: Text("Favourites"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person_outline),
                    selectedIcon: Icon(Icons.person),
                    label: Text("Profile"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
