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
  bool isFavorite = false; // Track favorite state

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Preview"),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Implement wallpaper setting functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor:
                      isDarkMode ? Colors.white : Colors.black, // Invert colors
                  content: Text(
                    "Set as wallpaper clicked",
                    style: TextStyle(
                        color: isDarkMode
                            ? Colors.black
                            : Colors.white), // Invert text color
                  ),
                ),
              );
            },
            child: Text(
              "Set Wallpaper",
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
      backgroundColor:
          isDarkMode ? Colors.black : Colors.white, // Theme-based background
      body: Center(
        child: CachedNetworkImage(
          imageUrl: widget.imageUrl,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) =>
              const Icon(Icons.error, size: 100),
          imageBuilder: (context, imageProvider) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: constraints.maxWidth, // Full width of the screen
                  height: constraints.maxHeight, // Full height of the screen
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.contain, // Maintains aspect ratio
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isFavorite
            ? Colors.red
            : (isDarkMode ? Colors.grey[800] : Colors.grey[300]),
        onPressed: () {
          setState(() {
            isFavorite = !isFavorite; // Toggle favorite state
          });
        },
        child: Icon(Icons.favorite,
            color: isFavorite
                ? Colors.white
                : (isDarkMode ? Colors.white : Colors.black)),
      ),
    );
  }
}
