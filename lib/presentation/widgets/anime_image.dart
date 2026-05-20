import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class AnimeImage extends StatelessWidget {
  const AnimeImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = 16,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final child = imageUrl.isEmpty
        ? Container(
            width: width,
            height: height,
            color: AppTheme.orange.withOpacity(.08),
            child: const Icon(Icons.movie_creation_outlined, color: AppTheme.orange, size: 36),
          )
        : CachedNetworkImage(
            imageUrl: imageUrl,
            width: width,
            height: height,
            fit: fit,
            placeholder: (_, __) => Container(
              width: width,
              height: height,
              color: Colors.grey.shade200,
              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            errorWidget: (_, __, ___) => Container(
              width: width,
              height: height,
              color: AppTheme.orange.withOpacity(.08),
              child: const Icon(Icons.broken_image_outlined, color: AppTheme.orange),
            ),
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: child,
    );
  }
}
