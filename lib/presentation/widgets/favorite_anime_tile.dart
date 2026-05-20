import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/anime_model.dart';
import 'anime_image.dart';

class FavoriteAnimeTile extends StatelessWidget {
  const FavoriteAnimeTile({
    super.key,
    required this.anime,
    required this.onTap,
    required this.onDelete,
  });

  final Anime anime;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              AnimeImage(imageUrl: anime.posterImage, width: 76, height: 96, borderRadius: 16),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      anime.titleEnJp,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(anime.ratingText, style: const TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${anime.ageRating} • ${anime.episodeText}',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded),
                color: Colors.red.shade600,
                style: IconButton.styleFrom(backgroundColor: AppTheme.danger.withOpacity(.08)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
