// File: scripts/wallpaper_setter.dart
import 'dart:convert';
import 'dart:io';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<void> setWallpaperFromSavedJson(int location, BuildContext context) async {
  try {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory!.path}/Download/Primewalls/response.json');

    if (!await file.exists()) {
      throw Exception("response.json not found");
    }

    final jsonData = jsonDecode(await file.readAsString());
    final portraitUrl = jsonData['src']['portrait'];

    if (portraitUrl == null) {
      throw Exception("Portrait URL not found in response.json");
    }

    final result = await AsyncWallpaper.setWallpaper(
      url: portraitUrl,
      wallpaperLocation: location,
      goToHome: true,
      toastDetails: ToastDetails.success(),
      errorToastDetails: ToastDetails.error(),
    );

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Wallpaper set successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      throw Exception("Wallpaper could not be set");
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("❌ Error: $e"),
        backgroundColor: Colors.red,
      ),
    );
  }
}
