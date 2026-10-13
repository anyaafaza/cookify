import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String _key = 'favorite_recipes';

  static Future<List<String>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  static Future<bool> isFavorite(String recipeId) async {
    final ids = await getFavoriteIds();
    return ids.contains(recipeId);
  }

  static Future<void> addFavorite(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_key) ?? [];
    if (!ids.contains(recipeId)) {
      ids.add(recipeId);
      await prefs.setStringList(_key, ids);
    }
  }

  static Future<void> removeFavorite(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_key) ?? [];
    ids.remove(recipeId);
    await prefs.setStringList(_key, ids);
  }

  static Future<bool> toggleFavorite(String recipeId) async {
    final isFav = await isFavorite(recipeId);
    if (isFav) {
      await removeFavorite(recipeId);
      return false;
    } else {
      await addFavorite(recipeId);
      return true;
    }
  }

  static Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
