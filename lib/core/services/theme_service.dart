import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _key = 'app_theme_mode';

  static Future<void> saveTheme(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, themeMode);
  }

  static Future<String> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) ?? 'light';
  }
}
