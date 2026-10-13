import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyUsers = 'registered_users';
  static const String _keyCurrentEmail = 'current_user_email';

  // HASH PASSWORD
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  // AMBIL SEMUA USER
  static Future<List<Map<String, dynamic>>> _getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_keyUsers) ?? [];
    return usersJson.map((u) => jsonDecode(u) as Map<String, dynamic>).toList();
  }

  // SIMPAN SEMUA USER
  static Future<void> _saveAllUsers(List<Map<String, dynamic>> users) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = users.map((u) => jsonEncode(u)).toList();
    await prefs.setStringList(_keyUsers, usersJson);
  }

  // REGISTER
  static Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final users = await _getAllUsers();
    final normalizedEmail = email.trim().toLowerCase();

    // Cek email sudah terdaftar
    final exists = users.any(
      (u) => (u['email'] as String).toLowerCase() == normalizedEmail,
    );
    if (exists) {
      return 'Email sudah terdaftar. Silakan login.';
    }

    // Tambah user baru
    users.add({
      'name': name.trim(),
      'email': normalizedEmail,
      'password': _hashPassword(password),
      'createdAt': DateTime.now().toIso8601String(),
    });

    await _saveAllUsers(users);
    return null;
  }

  // LOGIN
  static Future<String?> login({
    required String email,
    required String password,
  }) async {
    final users = await _getAllUsers();
    final normalizedEmail = email.trim().toLowerCase();
    final hashedPassword = _hashPassword(password);

    // Cari user
    final user = users.firstWhere(
      (u) =>
          (u['email'] as String).toLowerCase() == normalizedEmail &&
          u['password'] == hashedPassword,
      orElse: () => {},
    );

    if (user.isEmpty) {
      return 'Email atau password salah.';
    }

    // Simpan session
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCurrentEmail, normalizedEmail);
    return null;
  }

  // CEK LOGIN
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_keyCurrentEmail);
    return email != null && email.isNotEmpty;
  }

  // AMBIL DATA USER YANG SEDANG LOGIN
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_keyCurrentEmail);
    if (email == null || email.isEmpty) return null;

    final users = await _getAllUsers();
    try {
      return users.firstWhere(
        (u) => (u['email'] as String).toLowerCase() == email.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  // AMBIL NAMA USER
  static Future<String> getUserName() async {
    final user = await getCurrentUser();
    return (user?['name'] as String?) ?? 'Pengguna Cookify';
  }

  // AMBIL EMAIL USER
  static Future<String> getUserEmail() async {
    final user = await getCurrentUser();
    return (user?['email'] as String?) ?? 'user@cookify.id';
  }

  // LOGOUT
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCurrentEmail);
  }

  // UPDATE PROFIL
  static Future<String?> updateProfile({
    required String newName,
    required String newEmail,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final currentEmail = prefs.getString(_keyCurrentEmail);
    if (currentEmail == null) return 'Kamu belum login.';

    final users = await _getAllUsers();
    final normalizedNewEmail = newEmail.trim().toLowerCase();
    final normalizedCurrentEmail = currentEmail.toLowerCase();

    if (normalizedNewEmail != normalizedCurrentEmail) {
      final emailTaken = users.any(
        (u) => (u['email'] as String).toLowerCase() == normalizedNewEmail,
      );
      if (emailTaken) {
        return 'Email sudah dipakai akun lain.';
      }
    }

    final index = users.indexWhere(
      (u) => (u['email'] as String).toLowerCase() == normalizedCurrentEmail,
    );
    if (index == -1) return 'Akun tidak ditemukan.';

    // Update data
    users[index]['name'] = newName.trim();
    users[index]['email'] = normalizedNewEmail;

    await _saveAllUsers(users);

    // Update session kalau email berubah
    if (normalizedNewEmail != normalizedCurrentEmail) {
      await prefs.setString(_keyCurrentEmail, normalizedNewEmail);
    }

    return null;
  }

  // GANTI PASSWORD
  static Future<String?> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final currentEmail = prefs.getString(_keyCurrentEmail);
    if (currentEmail == null) return 'Kamu belum login.';

    final users = await _getAllUsers();
    final hashedOld = _hashPassword(oldPassword);

    // Cari user
    final index = users.indexWhere(
      (u) =>
          (u['email'] as String).toLowerCase() == currentEmail.toLowerCase() &&
          u['password'] == hashedOld,
    );

    if (index == -1) {
      return 'Password lama salah.';
    }

    // Update password
    users[index]['password'] = _hashPassword(newPassword);
    await _saveAllUsers(users);

    return null;
  }
}
