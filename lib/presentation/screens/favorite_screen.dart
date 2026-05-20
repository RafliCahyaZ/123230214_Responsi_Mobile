import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../../core/widgets/empty_state.dart';
import '../controllers/favorite_controller.dart';
import '../widgets/favorite_anime_tile.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Anime')),
      body: Obx(() {
        final favorites = controller.favorites;
        if (favorites.isEmpty) {
          return const EmptyState(
            icon: Icons.favorite_border_rounded,
            title: 'Belum ada anime favorit',
            message: 'Tambahkan anime dari halaman Detail agar muncul di library Favorite.',
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadFavorites,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final anime = favorites[index];
              return FavoriteAnimeTile(
                anime: anime,
                onTap: () => Get.toNamed(AppRoutes.detail, arguments: anime.id),
                onDelete: () => controller.removeFavorite(anime.id),
              );
            },
          ),
        );
      }),
    );
  }
}
