import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:simpleapp/screen/image_detail.dart';
// import 'package:simpleapp/screens/image_detail.dart';
import 'package:simpleapp/utils/theme_manager.dart';

class ImageCard extends StatelessWidget {
  final String imageUrl;

  const ImageCard(
      {super.key, required this.imageUrl, required Null Function() onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageDetailScreen(imageUrl: imageUrl),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            height: 250,
            color: Colors.grey[300],
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) =>
              const Icon(Icons.error, size: 100),
        ),
      ),
    );
  }
}
