import 'package:flutter/material.dart';
import 'package:simpleapp/screen/favourite_screen.dart';
import 'package:simpleapp/screen/profile.dart';
import 'package:simpleapp/screen/search.dart';
import 'package:simpleapp/screen/homescreen.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:simpleapp/utils/theme_manager.dart';
import 'package:simpleapp/screen/favourite_screen.dart';

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
    if (selectedIndex == index) return; // Prevent duplicate navigation

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

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;
        final selectedColor = isDarkMode ? Colors.white : Colors.black;
        final unselectedColor =
            isDarkMode ? Colors.grey[500]! : Colors.grey[800]!;

        return BottomAppBar(
          color: isDarkMode ? Colors.black : Colors.white,
          child: SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconBottomBar(
                    text: "Home",
                    icon: Icons.home,
                    selected: selectedIndex == 0,
                    selectedColor: selectedColor,
                    unselectedColor: unselectedColor,
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                  ),
                  IconBottomBar(
                    text: "Search",
                    icon: Icons.search_outlined,
                    selected: selectedIndex == 1,
                    selectedColor: selectedColor,
                    unselectedColor: unselectedColor,
                    onPressed: () {
                      _navigateToScreen(context, 1, const SearchScreen());
                    },
                  ),
                  IconBottomBar(
                    text: "Favourites",
                    icon: AntDesign.heart_outline,
                    selected: selectedIndex == 2,
                    selectedColor: selectedColor,
                    unselectedColor: unselectedColor,
                    onPressed: () {
                      _navigateToScreen(context, 2, const FavouriteScreen());
                    },
                  ),
                  IconBottomBar(
                    text: "Profile",
                    icon: Icons.person_2_outlined,
                    selected: selectedIndex == 3,
                    selectedColor: selectedColor,
                    unselectedColor: unselectedColor,
                    onPressed: () {
                      _navigateToScreen(context, 3, const ProfileScreen());
                    },
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

class IconBottomBar extends StatelessWidget {
  const IconBottomBar({
    super.key,
    required this.text,
    required this.icon,
    required this.selected,
    required this.onPressed,
    required this.selectedColor,
    required this.unselectedColor,
  });

  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;
  final Color selectedColor;
  final Color unselectedColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 25,
            color: selected
                ? selectedColor
                : unselectedColor, // ✅ Now updates correctly
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                height: .1,
                color: selected ? selectedColor : unselectedColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
