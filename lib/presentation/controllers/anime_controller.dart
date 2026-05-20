import 'package:get/get.dart';

import '../../data/models/anime_model.dart';
import '../../data/services/api_service.dart';

class AnimeController extends GetxController {
  AnimeController(this._apiService);

  final ApiService _apiService;

  final RxList<Anime> animeList = <Anime>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAnimeList();
  }

  Future<void> fetchAnimeList() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _apiService.getAnimeList();
      animeList.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }
}
