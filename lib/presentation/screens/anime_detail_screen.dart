import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/error_retry_view.dart';
import '../../core/widgets/loading_view.dart';
import '../controllers/detail_controller.dart';
import '../widgets/anime_image.dart';

class AnimeDetailScreen extends StatefulWidget {
  const AnimeDetailScreen({super.key});

  @override
  State<AnimeDetailScreen> createState() => _AnimeDetailScreenState();
}

class _AnimeDetailScreenState extends State<AnimeDetailScreen> {
  late final DetailController _controller;
  late final String _animeId;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<DetailController>();
    _animeId = (Get.arguments ?? '').toString();
    Future.microtask(() => _controller.fetchDetail(_animeId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const LoadingView(message: 'Mengambil detail anime...');
        }

        if (_controller.errorMessage.value.isNotEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detail Anime')),
            body: ErrorRetryView(
              message: _controller.errorMessage.value,
              onRetry: () => _controller.fetchDetail(_animeId),
            ),
          );
        }

        final anime = _controller.anime.value;
        if (anime == null) {
          return const LoadingView(message: 'Menyiapkan detail...');
        }

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 320,
              pinned: true,
              foregroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  anime.titleEnJp,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    AnimeImage(imageUrl: anime.coverImage, borderRadius: 0, fit: BoxFit.cover),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black.withOpacity(.72), Colors.transparent, Colors.black.withOpacity(.75)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimeImage(imageUrl: anime.posterImage, width: 120, height: 170, borderRadius: 18),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                anime.titleEnJp,
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.dark),
                              ),
                              const SizedBox(height: 8),
                              _InfoChip(icon: Icons.star_rounded, label: anime.ratingText, color: Colors.amber.shade700),
                              const SizedBox(height: 8),
                              _InfoChip(icon: Icons.shield_rounded, label: '${anime.ageRating} • ${anime.ageRatingGuide}', color: AppTheme.orange),
                              const SizedBox(height: 8),
                              _InfoChip(icon: Icons.video_library_rounded, label: anime.episodeText, color: Colors.blueGrey),
                              const SizedBox(height: 8),
                              _InfoChip(icon: Icons.calendar_month_rounded, label: anime.startDate, color: Colors.green),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text('Nonton'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Obx(() {
                          final favorite = _controller.isFavorite.value;
                          return Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _controller.toggleFavorite,
                              icon: Icon(favorite ? Icons.favorite_rounded : Icons.favorite_border_rounded),
                              label: Text(favorite ? 'Favorit' : 'Tambah Favorit'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: favorite ? Colors.red.shade600 : AppTheme.dark,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Sinopsis',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.dark),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      anime.synopsis,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(fontSize: 15, height: 1.55),
                    ),
                    const SizedBox(height: 22),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Informasi Anime', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                            const Divider(height: 24),
                            _InfoRow(label: 'Judul Canonical', value: anime.canonicalTitle),
                            _InfoRow(label: 'Rating Umur', value: anime.ageRating),
                            _InfoRow(label: 'Guide', value: anime.ageRatingGuide),
                            _InfoRow(label: 'Jumlah Episode', value: anime.episodeText),
                            _InfoRow(label: 'Rating', value: anime.ratingText),
                            _InfoRow(label: 'Status', value: anime.status),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label, required this.color});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w700)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w800))),
        ],
      ),
    );
  }
}
