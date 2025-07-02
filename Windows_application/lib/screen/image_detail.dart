import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simpleapp/utils/theme_manager.dart';
import 'package:simpleapp/scripts/wallpaper_setter.dart';
import 'package:path/path.dart' as p;
import 'package:simpleapp/scripts/dailyrefresh.dart';
import 'package:simpleapp/screen/login_screen.dart';
import 'package:simpleapp/scripts/favourite_handler.dart';

class ImageDetailScreen extends StatefulWidget {
  final String imageUrl;
  final String imageId; // ✅ Accept imageId

  const ImageDetailScreen({
    super.key,
    required this.imageUrl,
    required this.imageId,
  });

  @override
  _ImageDetailScreenState createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
  bool isFavorite = false;
  bool isLoggedIn = false;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _checkLoginState();
    _checkIfFavourite();
  }

  Future<void> _checkLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  Future<void> _checkIfFavourite() async {
    final favs = await FirebaseHandler.getFavourites();
    setState(() {
      isFavorite = favs.contains(widget.imageUrl);
    });
  }

  void _showLoginPrompt() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('You must be logged in to perform this action.'),
        action: SnackBarAction(
          label: 'Login',
          textColor: Colors.blueAccent,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          ),
        ),
      ),
    );
  }

  Future<void> _toggleFavorite() async {
    if (_isSyncing) return;
    setState(() => _isSyncing = true);

    final success = await FirebaseHandler.toggleFavourite(widget.imageUrl);
    if (success != false) {
      setState(() => isFavorite = !isFavorite);
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
    setState(() => _isSyncing = false);
  }

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

      final File jsonFile = File('${downloadDir.path}\\response.json');
      if (!await jsonFile.exists()) {
        throw Exception("response.json not found in ${downloadDir.path}");
      }

      final Map<String, dynamic> jsonData =
          jsonDecode(await jsonFile.readAsString());

      final String? originalUrl = jsonData['src']?['original'];
      if (originalUrl == null || originalUrl.isEmpty) {
        throw Exception("Original image URL missing in response.json");
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

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Preview"),
        backgroundColor: isDark ? Colors.black : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    side: BorderSide(
                      color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                    ),
                  ),
                  onPressed: () async {
                    final String cleanedUrl = widget.imageUrl.split('?').first;

                    await DailyWallpaperQueue.addToQueue(
                        widget.imageId, cleanedUrl);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("✅ Added to queue")),
                    );
                  },
                  child: Text(
                    "Add to Queue",
                    style: TextStyle(
                      color: isDark ? Colors.black : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(width: 20), // 20px spacing between buttons

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    side: BorderSide(
                      color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                    ),
                  ),
                  onPressed: isLoggedIn
                      ? () async {
                          try {
                            final Directory downloadDir = Directory(
                              '${Platform.environment['USERPROFILE']}\\Downloads\\Primewalls',
                            );

                            final File jsonFile =
                                File('${downloadDir.path}\\response.json');
                            if (!await jsonFile.exists()) {
                              throw Exception("response.json not found");
                            }

                            final Map<String, dynamic> jsonData =
                                jsonDecode(await jsonFile.readAsString());

                            final String? imageId = jsonData['id']?.toString();
                            if (imageId == null || imageId.isEmpty) {
                              throw Exception(
                                  "Image ID not found in response.json");
                            }

                            await downloadWallpaperAsCustomFile(context);
                            await setWallpaperFromCustomFile(context, imageId);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("❌ Failed: $e")),
                            );
                          }
                        }
                      : _showLoginPrompt,
                  child: Text(
                    "Set Wallpaper",
                    style: TextStyle(
                      color: isDark ? Colors.black : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Column(
        children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (_, __) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (_, __, ___) => const Icon(Icons.error, size: 100),
            ),
          ),
        ],
      ),
      floatingActionButton: _isSyncing
          ? const CircularProgressIndicator()
          : FloatingActionButton(
              backgroundColor: isFavorite
                  ? Colors.red
                  : (isDark ? Colors.grey[800] : Colors.grey[300]),
              onPressed: isLoggedIn ? _toggleFavorite : _showLoginPrompt,
              child: Icon(
                Icons.favorite,
                color: isFavorite
                    ? Colors.white
                    : (isDark ? Colors.white : Colors.black),
              ),
            ),
    );
  }
}
