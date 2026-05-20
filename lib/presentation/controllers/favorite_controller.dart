import 'dart:async';

import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../data/models/anime_model.dart';
import '../../data/services/favorite_service.dart';

class FavoriteController extends GetxController {
  FavoriteController(this._favoriteService);

  final FavoriteService _favoriteService;
  final RxList<Anime> favorites = <Anime>[].obs;
  StreamSubscription<BoxEvent>? _subscription;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
    _listenHiveChanges();
  }

  Future<void> loadFavorites() async {
    final result = await _favoriteService.getFavorites();
    favorites.assignAll(result);
  }

  Future<bool> isFavorite(String id) => _favoriteService.isFavorite(id);

  Future<void> addFavorite(Anime anime) async {
    await _favoriteService.addFavorite(anime);
    await loadFavorites();
  }

  Future<void> removeFavorite(String id) async {
    await _favoriteService.removeFavorite(id);
    await loadFavorites();
  }

  Future<void> _listenHiveChanges() async {
    _subscription = _favoriteService.watch().listen((_) => loadFavorites());
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
