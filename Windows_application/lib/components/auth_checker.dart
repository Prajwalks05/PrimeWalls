import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simpleapp/components/profile_screen.dart';
import '../screen/login_screen.dart';

class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final firebaseUser = FirebaseAuth.instance.currentUser;

    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') == true || firebaseUser != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn ? const ProfileScreen() : const LoginScreen();
  }
}
