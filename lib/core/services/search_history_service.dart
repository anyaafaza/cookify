import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryService {
  static const String _key = 'search_history';
  static const int _maxItems = 10;

  // Ambil riwayat
  static Future<List<String>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  // Tambah ke riwayat
  static Future<void> addToHistory(String query) async {
    if (query.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_key) ?? [];

    history.remove(query);

    history.insert(0, query);

    if (history.length > _maxItems) {
      history.removeRange(_maxItems, history.length);
    }

    await prefs.setStringList(_key, history);
  }

  // Hapus satu item
  static Future<void> removeFromHistory(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_key) ?? [];
    history.remove(query);
    await prefs.setStringList(_key, history);
  }

  // Hapus semua riwayat
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
