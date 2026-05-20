import 'package:get/get.dart';

import '../../core/utils/app_snackbar.dart';
import '../../data/models/anime_model.dart';
import '../../data/services/api_service.dart';
import '../../data/services/notification_service.dart';
import 'favorite_controller.dart';

class DetailController extends GetxController {
  DetailController(this._apiService, this._notificationService);

  final ApiService _apiService;
  final NotificationService _notificationService;

  final Rxn<Anime> anime = Rxn<Anime>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isFavorite = false.obs;

  Future<void> fetchDetail(String animeId) async {
    isLoading.value = true;
    errorMessage.value = '';
    anime.value = null;
    try {
      final result = await _apiService.getAnimeDetail(animeId);
      anime.value = result;
      isFavorite.value = await Get.find<FavoriteController>().isFavorite(result.id);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite() async {
    final selectedAnime = anime.value;
    if (selectedAnime == null) return;

    final favoriteController = Get.find<FavoriteController>();
    if (isFavorite.value) {
      await favoriteController.removeFavorite(selectedAnime.id);
      isFavorite.value = false;
      AppSnackbar.info('${selectedAnime.titleEnJp} dihapus dari Favorite.');
    } else {
      await favoriteController.addFavorite(selectedAnime);
      isFavorite.value = true;
      await _notificationService.showFavoriteNotification(selectedAnime.titleEnJp);
      AppSnackbar.success('${selectedAnime.titleEnJp} ditambahkan ke Favorite.');
    }
  }
}
