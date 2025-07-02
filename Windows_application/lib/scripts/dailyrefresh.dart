import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simpleapp/scripts/wallpaper_setter.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

class DailyWallpaperQueue {
  static const String fileName = 'daily_queue.json';

  // Get the path to the Primewalls directory inside Downloads
  static Future<String> _getQueueFilePath() async {
    final Directory downloadDir = Directory(
      '${Platform.environment['USERPROFILE']}\\Downloads\\Primewalls',
    );
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }
    return '${downloadDir.path}\\$fileName';
  }

  // Downloads the image only if it's not already saved
  static Future<void> _downloadImageIfMissing(
      BuildContext context, String imageUrl, String imageId) async {
    final picturesDir = Directory(
      '${Platform.environment['USERPROFILE']}\\Pictures\\Primewalls',
    );
    if (!await picturesDir.exists()) {
      await picturesDir.create(recursive: true);
    }

    final filePath = '${picturesDir.path}\\$imageId.wallpaperdata';
    final imageFile = File(filePath);

    if (!await imageFile.exists()) {
      final response = await http.get(Uri.parse(imageUrl));
      await imageFile.writeAsBytes(response.bodyBytes);
    }
  }

// Checks if a day has passed since last refresh and sets new wallpaper
  static Future<void> checkAndRefresh(BuildContext context) async {
  final queue = await getQueue();
  if (queue.isEmpty) return;

  final prefs = await SharedPreferences.getInstance();
  final lastRefreshDateStr = prefs.getString('last_refresh_date'); // Store 'yyyy-MM-dd'
  final todayStr = DateTime.now().toIso8601String().split('T').first;

  // Already refreshed today
  if (lastRefreshDateStr == todayStr) return;

  final String? imageUrl = queue.values.first;
  final String? imageId = queue.keys.first;

  if (imageUrl != null && imageId != null) {
    await _downloadImageIfMissing(context, imageUrl, imageId);
    await DailyWallpaperQueue().setWallpaperFromCustomFile(context, imageId);
    await removeFirst();

    // Save the refresh day (yyyy-MM-dd)
    await prefs.setString('last_refresh_date', todayStr);
  }
}


//helper wallpaper saetter functions
  Future<void> downloadWallpaperAsCustomFile(BuildContext context) async {
    try {
      final Directory downloadDir = Directory(
        '${Platform.environment['USERPROFILE']}\\Downloads\\Primewalls',
      );

      final Directory picturesDir = Directory(
        '${Platform.environment['USERPROFILE']}\\Pictures\\Primewalls',
      );

      if (!await downloadDir.exists()) {
        throw Exception("Download directory does not exist.");
      }
      if (!await picturesDir.exists()) {
        await picturesDir.create(recursive: true);
      }

      final File jsonFile = File('${downloadDir.path}\\.json');
      if (!await jsonFile.exists()) {
        throw Exception("response.json not found in ${downloadDir.path}");
      }

      final Map<String, dynamic> jsonData =
          jsonDecode(await jsonFile.readAsString());

      final String? originalUrl = jsonData['src']?['original'];
      if (originalUrl == null || originalUrl.isEmpty) {
        throw Exception("Original image URL missing in daily_queue.json");
      }

      final String imageId = jsonData['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = '$imageId.wallpaperdata';

      final File targetFile = File('${picturesDir.path}\\$fileName');

      if (await targetFile.exists()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("ℹ️ Wallpaper already exists")),
        );
        return;
      }

      final response = await http.get(Uri.parse(originalUrl));
      await targetFile.writeAsBytes(response.bodyBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Wallpaper downloaded successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to download wallpaper: $e")),
      );
    }
  }

  Future<void> setWallpaperFromCustomFile(
      BuildContext context, String imageId) async {
    try {
      final Directory picturesDir = Directory(
        '${Platform.environment['USERPROFILE']}\\Pictures\\Primewalls',
      );
      final String fileName = '$imageId.wallpaperdata';
      final File dataFile = File('${picturesDir.path}\\$fileName');

      if (!await dataFile.exists()) {
        throw Exception("Wallpaper file not found: $fileName");
      }

      final Directory tempDir = Directory.systemTemp;
      final String tempImagePath = p.join(tempDir.path, 'temp_wallpaper.png');

      await dataFile.copy(tempImagePath);

      await setWallpaperWindows(
          tempImagePath, context); // This sets the wallpaper
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to set wallpaper: $e")),
      );
    }
  }

  // Add a new image to the daily queue (imageId -> originalUrl)
  static Future<void> addToQueue(String imageId, String originalUrl) async {
    try {
      final String filePath = await _getQueueFilePath();
      final File queueFile = File(filePath);

      Map<String, String> queue = {};
      if (await queueFile.exists()) {
        final content = await queueFile.readAsString();
        queue = Map<String, String>.from(json.decode(content));
      }

      // Prevent duplicates
      if (!queue.containsKey(imageId)) {
        queue[imageId] = originalUrl;
        await queueFile.writeAsString(jsonEncode(queue), flush: true);
      }
    } catch (e) {
      print("❌ Failed to add to queue: $e");
    }
  }

  // Load the queue
  static Future<Map<String, String>> getQueue() async {
    final String filePath = await _getQueueFilePath();
    final File queueFile = File(filePath);
    if (!await queueFile.exists()) return {};
    final content = await queueFile.readAsString();
    return Map<String, String>.from(json.decode(content));
  }

  // Optionally get the next image (can use this in a scheduler)
  static Future<String?> getNextWallpaperUrl() async {
    final queue = await getQueue();
    if (queue.isEmpty) return null;
    return queue.values.first;
  }

  // Optionally remove the used one
  static Future<void> removeFirst() async {
    final queue = await getQueue();
    if (queue.isNotEmpty) {
      final String firstKey = queue.keys.first;
      queue.remove(firstKey);

      final String filePath = await _getQueueFilePath();
      final File queueFile = File(filePath);
      await queueFile.writeAsString(jsonEncode(queue), flush: true);
    }
  }
}
