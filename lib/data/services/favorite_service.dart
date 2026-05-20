import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../models/anime_model.dart';

class FavoriteService {
  Future<Box> get _box async => Hive.isBoxOpen(AppConstants.favoriteBoxName)
      ? Hive.box(AppConstants.favoriteBoxName)
      : await Hive.openBox(AppConstants.favoriteBoxName);

  Future<List<Anime>> getFavorites() async {
    final box = await _box;
    return box.values
        .whereType<Map>()
        .map((item) => Anime.fromMap(item))
        .toList()
      ..sort((a, b) => a.titleEnJp.compareTo(b.titleEnJp));
  }

  Future<bool> isFavorite(String id) async {
    final box = await _box;
    return box.containsKey(id);
  }

  Future<void> addFavorite(Anime anime) async {
    final box = await _box;
    await box.put(anime.id, anime.toMap());
  }

  Future<void> removeFavorite(String id) async {
    final box = await _box;
    await box.delete(id);
  }

  Future<int> favoriteCount() async {
    final box = await _box;
    return box.length;
  }

  Stream<BoxEvent> watch() async* {
    final box = await _box;
    yield* box.watch();
  }
}
