import 'package:flutter/material.dart';
import 'package:simpleapp/components/profile_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileScreen(); // ✅ Use ProfileScreen directly
  }
}
