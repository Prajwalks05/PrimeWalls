import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:simpleapp/components/appbar.dart';
import 'package:simpleapp/components/bottomnav.dart'; // uses BottomNavBarFb2
import 'package:simpleapp/components/image_card.dart';
import 'package:simpleapp/screen/image_detail.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

Future<void> _writeResponseToFile(Map<String, dynamic> data) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final downloadPath = '${directory.path}/Primewalls';

    final primewallsDirectory = Directory(downloadPath);
    if (!await primewallsDirectory.exists()) {
      await primewallsDirectory.create(recursive: true);
      print("Primewalls directory created: $downloadPath");
    }

    final jsonFile = File('${primewallsDirectory.path}/response.json');
    await jsonFile.writeAsString(json.encode(data), flush: true);
    print("Full image JSON written to file: ${jsonFile.path}");
  } catch (e) {
    print("Error writing to response.json: $e");
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, String>> imageData = [];
  List<dynamic> fullPhotoData = [];
  bool isLoading = true;

  final String apiKey =
      "gIjCs72ZsEXx9avRNLmLwL4RQ9t81Dcvhpc0wxdY8gBITv0aa7CLZuBt";

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    final String url =
        'https://api.pexels.com/v1/search?query=wallpaper&per_page=200&orientation=landscape&safesearch=true';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['photos'] is List) {
          List<Map<String, String>> results = [];
          fullPhotoData = data['photos'];

          for (var img in data['photos']) {
            results.add({
              'id': img['id'].toString(),
              'url':
                  (img['src'] as Map<String, dynamic>)['landscape'] as String,
            });
          }

          setState(() {
            imageData = results;
            isLoading = false;
          });
        } else {
          throw Exception('Unexpected format in photos response');
        }
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      print('Error fetching images: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBarFb1(title: 'Primewalls'),
      body: Row(
        children: [
          const BottomNavBarFb2(currentIndex: 0),
          const VerticalDivider(width: 1),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : LiquidPullToRefresh(
                    onRefresh: _fetchImages,
                    showChildOpacityTransition: false,
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      thickness: 8,
                      scrollbarOrientation: ScrollbarOrientation.right,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(10),
                        child: StaggeredGrid.count(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          children: List.generate(imageData.length, (index) {
                            return SizedBox(
                              height: 275,
                              child: ImageCard(
                                imageUrl: imageData[index]['url']!,
                                imageId: imageData[index]['id']!,
                                onTap: () async {
                                  final tappedImageJson = fullPhotoData[index];
                                  print(
                                      "Clicked image JSON:\n${jsonEncode(tappedImageJson)}");
                                  await _writeResponseToFile(tappedImageJson);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ImageDetailScreen(
                                        imageUrl: imageData[index]['url']!,
                                        imageId: imageData[index]['id']!,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
