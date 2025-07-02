import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simpleapp/scripts/dailyrefresh.dart';
import 'package:simpleapp/scripts/wallpaper_setter.dart';

class DailyRefreshToggle extends StatefulWidget {
  const DailyRefreshToggle({super.key});

  @override
  State<DailyRefreshToggle> createState() => _DailyRefreshToggleState();
}

class _DailyRefreshToggleState extends State<DailyRefreshToggle> {
  bool _isEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadToggleState();
  }

  Future<void> _loadToggleState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isEnabled = prefs.getBool('daily_refresh_enabled') ?? false;
    });
  }

  Future<void> _toggleRefresh(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_refresh_enabled', value);
    setState(() {
      _isEnabled = value;
    });

    if (!value) return;

    final queue = await DailyWallpaperQueue.getQueue();
    if (queue.isEmpty) {
      final responseFile = File(
        '${Platform.environment['USERPROFILE']}\\Downloads\\Primewalls\\response.json',
      );

      if (await responseFile.exists()) {
        final json = jsonDecode(await responseFile.readAsString());
        final String? id = json['id']?.toString();
        final String? url = json['src']?['original'];

        if (id != null && url != null) {
          await DailyWallpaperQueue.addToQueue(id, url);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("✅ Queue initialized from response.json")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("⚠️ Invalid data in response.json")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ response.json not found")),
        );
      }
    }

    // Trigger refresh and exit
    await Future.delayed(const Duration(seconds: 2));
    await DailyWallpaperQueue.checkAndRefresh(context);
    await Future.delayed(const Duration(seconds: 15));
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text("Enable Daily Wallpaper Refresh"),
      subtitle: const Text("Automatically updates your wallpaper every day"),
      value: _isEnabled,
      onChanged: _toggleRefresh,
    );
  }
}
