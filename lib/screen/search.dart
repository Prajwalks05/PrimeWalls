import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:simpleapp/components/appbar.dart';
import 'package:simpleapp/components/bottomnav.dart';
import 'package:simpleapp/components/image_card.dart';
import 'package:simpleapp/screen/image_detail.dart';
import 'package:simpleapp/utils/theme_manager.dart';
import 'package:simpleapp/utils/search_provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController textController = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(); // ✅ Defined scroll controller
  final String apiKey =
      "gIjCs72ZsEXx9avRNLmLwL4RQ9t81Dcvhpc0wxdY8gBITv0aa7CLZuBt"; // Replace with your API key

  // 🔹 Fetch images and store them in Provider
  Future<void> _searchImages(String query) async {
    if (query.isEmpty) return;

    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchProvider.setLoading(true);

    final String url =
        'https://api.pexels.com/v1/search?query=$query+wallpaper&per_page=50&orientation=portrait';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': apiKey
        }, // ✅ Pexels requires API key in headers
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        searchProvider.setSearchResults(
          List<String>.from(data['photos']
              .map((img) => img['src']['large'])
              .toList()), // ✅ Fixed key
        );
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

    return Scaffold(
      appBar: GradientAppBarFb1(title: 'Search Wallpapers'),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // 🔹 Search Bar
            SearchInput(
              textController: textController,
              hintText: 'Search wallpapers...',
              onSubmitted: (value) => _searchImages(value),
            ),
            const SizedBox(height: 10),

            // 🔹 Show Loading Indicator
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
                        // 🔹 Show Staggered Grid with Images
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
                                  onTap: () {
                                    // 🔹 Navigate to ImageDetailScreen
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

                        // 🔹 Show Empty Message if No Results
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

// 🔹 Search Input Field
class SearchInput extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final Function(String) onSubmitted;

  const SearchInput({
    required this.textController,
    required this.hintText,
    required this.onSubmitted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    return TextField(
      controller: textController,
      onSubmitted: onSubmitted, // 🔍 Triggers search when user presses enter
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search_sharp,
            color: isDarkMode ? Colors.white : Color(0xff4338CA)),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
        hintText: hintText,
        hintStyle:
            TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: isDarkMode ? Colors.grey[600]! : Colors.white, width: 1.0),
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: isDarkMode ? Colors.grey[500]! : Colors.white, width: 2.0),
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        ),
      ),
    );
  }
}
