import 'dart:convert';
import 'dart:io';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:simpleapp/utils/theme_manager.dart';
import 'package:simpleapp/scripts/wallpaper_setter.dart';

class ImageDetailScreen extends StatefulWidget {
  final String imageUrl;

  const ImageDetailScreen({super.key, required this.imageUrl});

  @override
  _ImageDetailScreenState createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Preview"),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, // White background
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2, // Slight elevation
              side: BorderSide(
                  color: isDarkMode
                      ? Colors.grey[800]!
                      : Colors.grey[300]!), // Border color based on theme
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (BuildContext context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.home),
                        title: const Text('Set as Home Screen'),
                        onTap: () async {
                          Navigator.pop(context);
                          await setWallpaperFromSavedJson(
                              AsyncWallpaper.HOME_SCREEN, context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.lock),
                        title: const Text('Set as Lock Screen'),
                        onTap: () async {
                          Navigator.pop(context);
                          await setWallpaperFromSavedJson(
                              AsyncWallpaper.LOCK_SCREEN, context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.smartphone),
                        title: const Text('Set as Both'),
                        onTap: () async {
                          Navigator.pop(context);
                          await setWallpaperFromSavedJson(
                              AsyncWallpaper.BOTH_SCREENS, context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              "Set Wallpaper",
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Column(
        children: [
          // 🖼️ Full-size image within body
          Expanded(
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              fit: BoxFit.cover, // Fills the body but not behind AppBar
              width: double.infinity,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error, size: 100),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isFavorite
            ? Colors.red
            : (isDarkMode ? Colors.grey[800] : Colors.grey[300]),
        onPressed: () {
          setState(() {
            isFavorite = !isFavorite;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: isDarkMode ? Colors.white : Colors.black,
              content: Text(
                isFavorite ? "Added to favorites" : "Removed from favorites",
                style: TextStyle(
                  color: isDarkMode ? Colors.black : Colors.white,
                ),
              ),
            ),
          );
        },
        child: Icon(
          Icons.favorite,
          color: isFavorite
              ? Colors.white
              : (isDarkMode ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
