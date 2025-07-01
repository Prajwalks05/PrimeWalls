import 'dart:convert';
import 'dart:io';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simpleapp/utils/theme_manager.dart';
import 'package:simpleapp/scripts/wallpaper_setter.dart';
import 'package:simpleapp/screen/login_screen.dart';
import 'package:simpleapp/scripts/favourite_handler.dart'; // Import your handler

class ImageDetailScreen extends StatefulWidget {
  final String imageUrl;

  const ImageDetailScreen({super.key, required this.imageUrl});

  @override
  _ImageDetailScreenState createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
  bool isFavorite = false;
  bool isLoggedIn = false;
  bool _isSyncing = false; // Track syncing state

  @override
  void initState() {
    super.initState();
    _checkLoginState();
    _checkIfFavourite(); // Add this
  }

  Future<void> _checkLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  Future<void> _checkIfFavourite() async {
    final favourites = await FirebaseHandler.getFavourites();
    setState(() {
      isFavorite = favourites.contains(widget.imageUrl);
    });
  }

  void _showLoginPrompt() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('You must be logged in to perform this action.'),
        action: SnackBarAction(
          label: 'Login',
          textColor: Colors.blueAccent,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
        ),
      ),
    );
  }

  // Function to handle adding/removing from favorites
  Future<void> _toggleFavorite() async {
    if (_isSyncing) return; // Prevent spamming if syncing is in progress

    setState(() {
      _isSyncing = true; // Set syncing state
    });

    // Assuming `FavouriteHandler` has a method to add or remove favorites
    final bool? success =
        await FirebaseHandler.toggleFavourite(widget.imageUrl);
    if (success == false) {
      debugPrint("errro");
    } else {
      setState(() {
        isFavorite = !isFavorite; // Toggle favorite status
      });
    }

    setState(() {
      _isSyncing = false; // Reset syncing state after operation
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        content: Text(
          isFavorite ? "Added to favorites" : "Removed from favorites",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ),
    );
  }

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
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
              side: BorderSide(
                  color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!),
            ),
            onPressed: isLoggedIn
                ? () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
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
                  }
                : _showLoginPrompt,
            child: Text(
              "Set Wallpaper",
              style: TextStyle(
                color: isDarkMode ? Colors.black : Colors.black,
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
          Expanded(
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error, size: 100),
            ),
          ),
        ],
      ),
      floatingActionButton:
          _isSyncing // Show loader when syncing is in progress
              ? CircularProgressIndicator()
              : FloatingActionButton(
                  backgroundColor: isFavorite
                      ? Colors.red
                      : (isDarkMode ? Colors.grey[800] : Colors.grey[300]),
                  onPressed: isLoggedIn ? _toggleFavorite : _showLoginPrompt,
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
