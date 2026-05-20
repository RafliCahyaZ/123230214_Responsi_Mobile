import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/error_retry_view.dart';
import '../../core/widgets/loading_view.dart';
import '../controllers/anime_controller.dart';
import '../controllers/auth_controller.dart';
import '../widgets/anime_grid_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final animeController = Get.find<AnimeController>();
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: animeController.fetchAnimeList,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.orange, AppTheme.orangeDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Halo,', style: TextStyle(color: Colors.white70)),
                          Text(
                            authController.username.value.isEmpty ? 'Anime Lover' : authController.username.value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Browse 20 anime populer dari Kitsu API.',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ],
                      )),
                ),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(.18), shape: BoxShape.circle),
                  child: const Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 38),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (animeController.isLoading.value) {
                return const LoadingView(message: 'Mengambil daftar anime...');
              }

              if (animeController.errorMessage.value.isNotEmpty) {
                return ErrorRetryView(
                  message: animeController.errorMessage.value,
                  onRetry: animeController.fetchAnimeList,
                );
              }

              final items = animeController.animeList;
              return RefreshIndicator(
                color: AppTheme.orange,
                onRefresh: animeController.fetchAnimeList,
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: .56,
                  ),
                  itemBuilder: (context, index) {
                    final anime = items[index];
                    return AnimeGridCard(
                      anime: anime,
                      onTap: () => Get.toNamed(AppRoutes.detail, arguments: anime.id),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
