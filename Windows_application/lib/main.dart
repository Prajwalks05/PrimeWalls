import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpleapp/utils/theme_manager.dart';
import 'package:simpleapp/utils/search_provider.dart';
import 'package:simpleapp/scripts/firebaseinit.dart';
import 'package:simpleapp/scripts/dailyrefresh.dart'; // ✅ Daily wallpaper logic
import 'package:simpleapp/screen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Primewalls',
          theme: themeProvider.themeData,
          home: const InitialLauncher(),
        );
      },
    );
  }
}

/// ✅ Wrapper widget that runs refresh logic after first frame
class InitialLauncher extends StatefulWidget {
  const InitialLauncher({super.key});

  @override
  State<InitialLauncher> createState() => _InitialLauncherState();
}

class _InitialLauncherState extends State<InitialLauncher> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await DailyWallpaperQueue.checkAndRefresh(context); // ✅ call static
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
