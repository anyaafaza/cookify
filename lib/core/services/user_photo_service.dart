import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class UserPhotoService {
  static const String _keyPrefix = 'user_photo_';

  static Future<void> savePhoto({
    required String userEmail,
    required Uint8List bytes,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final base64String = base64Encode(bytes);
    await prefs.setString('$_keyPrefix$userEmail', base64String);
  }

  static Future<Uint8List?> getPhoto(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    final base64String = prefs.getString('$_keyPrefix$userEmail');
    if (base64String == null) return null;

    try {
      return base64Decode(base64String);
    } catch (e) {
      return null;
    }
  }

  static Future<void> deletePhoto(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_keyPrefix$userEmail');
  }

  static Future<bool> hasPhoto(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('$_keyPrefix$userEmail');
  }
}
