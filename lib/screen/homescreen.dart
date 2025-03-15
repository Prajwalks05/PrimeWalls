import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../components/appbar.dart';
import '../components/bottomnav.dart';
// import '../components/image_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:simpleapp/components/image_card.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  List<String> imageUrls = [];
  bool isLoading = true;

  final String apiKey = "49236293-9a6d81c6b4d21211d2161e7de";

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    final String url =
        'https://pixabay.com/api/?key=$apiKey&q=wallpaper&image_type=photo&orientation=vertical&per_page=50';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          imageUrls = List<String>.from(
              data['hits'].map((img) => img['webformatURL']).toList());
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      print('Error fetching images: $e');
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
      appBar: const GradientAppBarFb1(title: 'Flutter Wallpapers'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          thickness: 8,
          radius: const Radius.circular(0),
          scrollbarOrientation: ScrollbarOrientation.right,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  controller: _scrollController,
                  child: StaggeredGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: List.generate(imageUrls.length, (index) {
                      return SizedBox(
                        height: 450,
                        child: ImageCard(
                          imageUrl: imageUrls[index],
                          onTap: () {
                            print('Tapped on: ${imageUrls[index]}');
                          },
                        ),
                      );
                    }),
                  ),
                ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarFb2(currentIndex: 0),
    );
  }
}
