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
import 'package:simpleapp/scripts/keyword_filter.dart';

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

    if (containsBannedKeyword(query)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Inappropriate content detected in the search term.')),
      );
      return;
    }

    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchProvider.setLoading(true);
    final String url =
        'https://api.pexels.com/v1/search?query=$query+wallpaper&per_page=200&orientation=landscape&safesearch=true';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['photos'] != null) {
          List<Map<String, String>> results = [];
          fullResponsePhotos = data['photos'];

          for (var img in fullResponsePhotos) {
            results.add({
              'id': img['id'].toString(),
              'url': img['src']['landscape'],
            });
          }
          searchProvider.setSearchResults(results);
          await writeResponseToFile(response.body);
        }
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      print('Error fetching images: $e');
    }
    searchProvider.setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final searchProvider = Provider.of<SearchProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: const GradientAppBarFb1(title: 'Primewalls'),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Row(
        children: [
          const BottomNavBarFb2(currentIndex: 1),
          const VerticalDivider(width: 1),
          Expanded(
            child: Padding(
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
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  children: List.generate(
                                      searchProvider.imageUrls.length, (index) {
                                    return SizedBox(
                                      height: 275,
                                      child: ImageCard(
                                        imageUrl:
                                            searchProvider.imageUrls[index],
                                        imageId: searchProvider.imageIds[index],
                                        onTap: () async {
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          final isLoggedIn =
                                              prefs.getBool('isLoggedIn') ??
                                                  false;

                                          if (!isLoggedIn) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Please log in to view details or set wallpaper.'),
                                              ),
                                            );
                                            return;
                                          }

                                          var fullImageData =
                                              fullResponsePhotos[index];
                                          await writeSingleImageToFile(
                                              fullImageData);

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ImageDetailScreen(
                                                imageUrl: searchProvider
                                                    .imageUrls[index],
                                                imageId: searchProvider
                                                    .imageIds[index],
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
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.grey),
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
          ),
        ],
      ),
    );
  }
}
