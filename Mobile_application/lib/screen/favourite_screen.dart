import 'package:flutter/material.dart';
import 'package:simpleapp/components/appbar.dart';
import 'package:simpleapp/components/image_card.dart';
import 'package:simpleapp/scripts/favourite_handler.dart';
import 'package:simpleapp/screen/image_detail.dart';
import 'package:simpleapp/components/bottomnav.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  List<String> favouriteUrls = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    final favs = await FirebaseHandler.getFavourites();
    setState(() {
      favouriteUrls = favs;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBarFb1(title: 'Primewalls'),
      bottomNavigationBar: const BottomNavBarFb2(currentIndex: 2),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : LiquidPullToRefresh(
              onRefresh: _loadFavourites,
              showChildOpacityTransition: false,
              child: favouriteUrls.isEmpty
                  ? const Center(child: Text("No favourites yet."))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(10),
                      child: StaggeredGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        children: favouriteUrls.map((imageUrl) {
                          return SizedBox(
                              height: 450,
                              child: ImageCard(
                                imageUrl: imageUrl,
                                imageId: '', // Unused in favourites
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ImageDetailScreen(imageUrl: imageUrl),
                                    ),
                                  ).then((_) => _loadFavourites());
                                },
                              ));
                        }).toList(),
                      ),
                    ),
            ),
    );
  }
}
