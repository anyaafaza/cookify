import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyUsers = 'registered_users';
  static const String _keyCurrentEmail = 'current_user_email';

  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  static Future<List<Map<String, dynamic>>> _getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_keyUsers) ?? [];
    return usersJson.map((u) => jsonDecode(u) as Map<String, dynamic>).toList();
  }

  static Future<void> _saveAllUsers(List<Map<String, dynamic>> users) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = users.map((u) => jsonEncode(u)).toList();
    await prefs.setStringList(_keyUsers, usersJson);
  }

  static Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final users = await _getAllUsers();
    final normalizedEmail = email.trim().toLowerCase();

    final exists = users
        .any((u) => (u['email'] as String).toLowerCase() == normalizedEmail);
    if (exists) return 'Email sudah terdaftar. Silakan login.';

    users.add({
      'name': name.trim(),
      'email': normalizedEmail,
      'password': _hashPassword(password),
      'createdAt': DateTime.now().toIso8601String(),
    });

    await _saveAllUsers(users);
    return null;
  }

  static Future<String?> login({
    required String email,
    required String password,
  }) async {
    final users = await _getAllUsers();
    final normalizedEmail = email.trim().toLowerCase();
    final hashedPassword = _hashPassword(password);

    final user = users.firstWhere(
      (u) =>
          (u['email'] as String).toLowerCase() == normalizedEmail &&
          u['password'] == hashedPassword,
      orElse: () => {},
    );

    if (user.isEmpty) return 'Email atau password salah.';

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCurrentEmail, normalizedEmail);
    return null;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_keyCurrentEmail);
    return email != null && email.isNotEmpty;
  }

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_keyCurrentEmail);
    if (email == null || email.isEmpty) return null;

    final users = await _getAllUsers();
    try {
      return users.firstWhere(
          (u) => (u['email'] as String).toLowerCase() == email.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  static Future<String> getUserName() async {
    final user = await getCurrentUser();
    return (user?['name'] as String?) ?? 'Pengguna Cookify';
  }

  static Future<String> getUserEmail() async {
    final user = await getCurrentUser();
    return (user?['email'] as String?) ?? 'user@cookify.id';
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCurrentEmail);
  }
}
