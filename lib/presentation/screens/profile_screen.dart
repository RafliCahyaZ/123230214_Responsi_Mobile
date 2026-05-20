import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../controllers/auth_controller.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/location_controller.dart';
import '../controllers/notification_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final favoriteController = Get.find<FavoriteController>();
    final locationController = Get.find<LocationController>();
    final notificationController = Get.find<NotificationController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: RefreshIndicator(
        onRefresh: () async {
          await favoriteController.loadFavorites();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 38,
                      backgroundColor: AppTheme.orange,
                      child: Icon(Icons.person_rounded, size: 42, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Username', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w700)),
                              Text(
                                authController.username.value.isEmpty ? '-' : authController.username.value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 6),
                              Text(AppConstants.appSubtitle, style: TextStyle(color: Colors.grey.shade700)),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.favorite_rounded,
                        title: 'Favorit',
                        value: '${favoriteController.favorites.length}',
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: _StatCard(
                        icon: Icons.movie_filter_rounded,
                        title: 'API',
                        value: 'Kitsu',
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tentang Aplikasi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    Text(
                      'Keripikroll adalah aplikasi mobile untuk browsing anime, melihat detail anime dari Kitsu API, menyimpan anime favorit ke Hive, dan menjaga session login menggunakan SharedPreferences.',
                      style: TextStyle(color: Colors.grey.shade700, height: 1.45),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Bonus Notification & LBS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 12),
                    Obx(() {
                      final location = locationController.location.value;
                      final error = locationController.errorMessage.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (location != null) ...[
                            _InfoLine(icon: Icons.location_on_rounded, text: location.address),
                            _InfoLine(
                              icon: Icons.my_location_rounded,
                              text: '${location.latitude.toStringAsFixed(5)}, ${location.longitude.toStringAsFixed(5)}',
                            ),
                            const SizedBox(height: 10),
                          ],
                          if (error.isNotEmpty) ...[
                            Text(error, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 10),
                          ],
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              ElevatedButton.icon(
                                onPressed: locationController.isLoading.value ? null : locationController.getLocation,
                                icon: locationController.isLoading.value
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      )
                                    : const Icon(Icons.location_searching_rounded),
                                label: Text(locationController.isLoading.value ? 'Mencari...' : 'Ambil Lokasi'),
                              ),
                              OutlinedButton.icon(
                                onPressed: notificationController.showWatchReminder,
                                icon: const Icon(Icons.notifications_active_rounded),
                                label: const Text('Tes Notifikasi'),
                              ),
                              OutlinedButton.icon(
                                onPressed: notificationController.scheduleDailyReminder,
                                icon: const Icon(Icons.schedule_rounded),
                                label: const Text('Reminder 19.00'),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            ElevatedButton.icon(
              onPressed: authController.logout,
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.title, required this.value});

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.orange, size: 34),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 2),
            Text(title, style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.orange),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }
}
