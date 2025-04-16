import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:simpleapp/screen/image_detail.dart'; // Ensure this import is correct
import 'package:simpleapp/utils/theme_manager.dart';

class ImageCard extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const ImageCard({
    Key? key,
    required this.imageUrl,
    required this.onTap,
    required String imageId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high, // 💎 High quality image rendering
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
