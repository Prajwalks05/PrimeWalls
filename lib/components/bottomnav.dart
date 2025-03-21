import 'package:flutter/material.dart';
import 'package:simpleapp/screen/profile.dart';
import 'package:simpleapp/screen/search.dart';
// import 'package:simpleapp/main.dart';
import 'package:simpleapp/screen/homescreen.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:simpleapp/components/profile_screen.dart';

class BottomNavBarFb2 extends StatefulWidget {
  final int currentIndex;
  const BottomNavBarFb2({super.key, required this.currentIndex});

  @override
  _BottomNavBarFb2State createState() => _BottomNavBarFb2State();
}

class _BottomNavBarFb2State extends State<BottomNavBarFb2> {
  int selectedIndex = 0;

  final Color primaryColor = const Color(0xff4338CA);

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
    return BottomAppBar(
      color: Colors.white,
      child: SizedBox(
        height: 56,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Home Button - Clears all previous screens and navigates to Home
              IconBottomBar(
                text: "Home",
                icon: Icons.home,
                selected: selectedIndex == 0,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false, // Clears all previous routes
                  );
                },
              ),

              // Search Button - Regular navigation
              IconBottomBar(
                text: "Search",
                icon: Icons.search_outlined,
                selected: selectedIndex == 1,
                onPressed: () {
                  _navigateToScreen(context, 1, const SearchScreen());
                },
              ),

              //favourites button here
              IconBottomBar(
                text: "Favourites",
                icon: AntDesign.heart_outline, // Correct usage from icons_plus
                selected: selectedIndex == 2,
                onPressed: () {
                  _navigateToScreen(context, 1, const SearchScreen());
                },
              ),

              // Profile Button - Regular navigation
              IconBottomBar(
                text: "Profile",
                icon: Icons.person_2_outlined,
                selected: selectedIndex == 3,
                onPressed: () {
                  _navigateToScreen(context, 3, const ProfileScreen());
                },
              ),
            ],
          ),
        ),
      ),
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
  });

  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;

  final Color primaryColor = const Color(0xff4338CA);

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
            color: selected ? primaryColor : Colors.black54,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                height: .1,
                color: selected ? primaryColor : Colors.grey.withOpacity(.75),
              ),
            ),
          )
        ],
      ),
    );
  }
}
