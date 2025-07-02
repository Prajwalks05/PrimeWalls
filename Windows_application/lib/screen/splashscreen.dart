import 'package:flutter/material.dart';
import 'package:simpleapp/screen/homescreen.dart'; // Import the HomeScreen

// import "package:simpleapp/assets/";
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to HomeScreen after 2.5 seconds
    Future.delayed(const Duration(milliseconds:2500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'splash.gif',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
