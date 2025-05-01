import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:simpleapp/components/appbar.dart';
import 'package:simpleapp/components/bottomnav.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simpleapp/components/image_card.dart';
import 'package:simpleapp/screen/image_detail.dart';
import 'package:simpleapp/utils/theme_manager.dart';
import 'package:simpleapp/utils/search_provider.dart';
import 'package:simpleapp/components/search_input.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:simpleapp/scripts/response.dart';
import 'package:simpleapp/components/auth_checker.dart';
import 'package:simpleapp/scripts/keyword_filter.dart'; // Import the keyword filter

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final String apiKey =
      "gIjCs72ZsEXx9avRNLmLwL4RQ9t81Dcvhpc0wxdY8gBITv0aa7CLZuBt";

  List<dynamic> fullResponsePhotos = [];

  // Function to check if the input contains banned keywords
  bool containsBannedKeyword(String query) {
    List<String> bannedKeywords = getDecodedBannedKeywords();
    for (var keyword in bannedKeywords) {
      if (query.toLowerCase().contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  Future<void> _searchImages(String query) async {
    if (query.isEmpty) return;

    // Check for banned words
    if (containsBannedKeyword(query)) {
      // Show a message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Inappropriate content detected in the search term.')),
      );
      return; // Stop further processing
    }

    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchProvider.setLoading(true);

    final String url =
        'https://api.pexels.com/v1/search?query=$query+wallpaper&per_page=100&orientation=portrait&safesearch=true';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': apiKey},
      );

      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Decoded Data: $data");

        if (data['photos'] != null) {
          List<Map<String, String>> results = [];
          fullResponsePhotos = data['photos']; // 🔹 Store full photo objects

          for (var img in fullResponsePhotos) {
            results.add({
              'id': img['id'].toString(),
              'url': img['src']['portrait'],
            });
          }
          searchProvider.setSearchResults(results);

          // Optionally save full response
          await writeResponseToFile(response.body);
        } else {
          print('No photos found in the response');
        }
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      print('Error fetching images: $e');
      searchProvider.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final searchProvider = Provider.of<SearchProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    // Check if user is logged in using the authChecker
    final authChecker = AuthChecker();

    return Scaffold(
      appBar: GradientAppBarFb1(title: 'Search Wallpapers'),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SearchInput(
              textController: textController,
              hintText: 'Search wallpapers...',
              onSubmitted: (value) => _searchImages(value),
            ),
            const SizedBox(height: 10),
            if (searchProvider.isLoading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else
              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  thickness: 8,
                  radius: const Radius.circular(0),
                  scrollbarOrientation: ScrollbarOrientation.right,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        if (searchProvider.imageUrls.isNotEmpty)
                          StaggeredGrid.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            children: List.generate(
                                searchProvider.imageUrls.length, (index) {
                              return SizedBox(
                                height: 450,
                                child: ImageCard(
                                  imageUrl: searchProvider.imageUrls[index],
                                  imageId: searchProvider.imageIds[index],
                                  onTap: () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    final isLoggedIn =
                                        prefs.getBool('isLoggedIn') ?? false;

                                    if (!isLoggedIn) {
                                      // User is NOT logged in → show login prompt
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Please log in to view details or set wallpaper.'),
                                        ),
                                      );
                                      return;
                                    }

                                    // 🔹 Get the full image object from the stored list
                                    var fullImageData =
                                        fullResponsePhotos[index];

                                    // 🔹 Print to console
                                    print(
                                        "Clicked Image Full Data: $fullImageData");

                                    // 🔹 Write full image object to response.json
                                    await writeSingleImageToFile(fullImageData);

                                    // 🔹 Navigate to detail screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ImageDetailScreen(
                                          imageUrl:
                                              searchProvider.imageUrls[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                          )
                        else
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                "Search for wallpapers...",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarFb2(currentIndex: 1),
    );
  }
}
