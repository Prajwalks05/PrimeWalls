import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpleapp/utils/theme_manager.dart';
import 'package:simpleapp/screen/splashscreen.dart';
import 'package:simpleapp/utils/search_provider.dart';
import 'scripts/firebaseinit.dart'; // ✅ Firebase initializer

void main() async {
  // ✅ Required for using async Firebase initialization
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase before running the app
  await FirebaseInit.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData, // ✅ Theme applied globally
          home: const SplashScreen(), // ✅ SplashScreen remains your home
        );
      },
    );
  }
}
