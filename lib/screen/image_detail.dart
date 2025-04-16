import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:simpleapp/utils/theme_manager.dart';

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
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor:
                      isDarkMode ? Colors.white : Colors.black,
                  content: Text(
                    "Set as wallpaper clicked",
                    style: TextStyle(
                      color: isDarkMode ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              );
            },
            child: Text(
              "Set Wallpaper",
              style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black),
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
                isFavorite
                    ? "Added to favorites"
                    : "Removed from favorites",
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
