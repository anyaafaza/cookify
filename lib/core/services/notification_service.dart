import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AppNotification {
  final String id;
  final String userEmail;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.userEmail,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userEmail': userEmail,
        'title': title,
        'body': body,
        'type': type,
        'isRead': isRead,
        'createdAt': createdAt.toIso8601String(),
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id'] as String,
        userEmail: json['userEmail'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        type: json['type'] as String,
        isRead: json['isRead'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  AppNotification copyWith({bool? isRead}) => AppNotification(
        id: id,
        userEmail: userEmail,
        title: title,
        body: body,
        type: type,
        isRead: isRead ?? this.isRead,
        createdAt: createdAt,
      );
}

class NotificationService {
  static const String _key = 'app_notifications';

  // AMBIL SEMUA NOTIFIKASI
  static Future<List<AppNotification>> _getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getStringList(_key) ?? [];
    return json
        .map((n) =>
            AppNotification.fromJson(jsonDecode(n) as Map<String, dynamic>))
        .toList();
  }

  // SIMPAN SEMUA
  static Future<void> _saveAll(List<AppNotification> items) async {
    final prefs = await SharedPreferences.getInstance();
    final json = items.map((n) => jsonEncode(n.toJson())).toList();
    await prefs.setStringList(_key, json);
  }

  // AMBIL NOTIFIKASI USER
  static Future<List<AppNotification>> getUserNotifications(
    String userEmail,
  ) async {
    final all = await _getAll();
    final filtered = all.where((n) => n.userEmail == userEmail).toList();
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  }

  // HITUNG YANG BELUM DIBACA
  static Future<int> getUnreadCount(String userEmail) async {
    final items = await getUserNotifications(userEmail);
    return items.where((n) => !n.isRead).length;
  }

  // TAMBAH NOTIFIKASI
  static Future<void> addNotification({
    required String userEmail,
    required String title,
    required String body,
    required String type,
  }) async {
    final all = await _getAll();
    all.add(AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userEmail: userEmail,
      title: title,
      body: body,
      type: type,
      createdAt: DateTime.now(),
    ));
    await _saveAll(all);
  }

  // TANDAI SATU SUDAH DIBACA
  static Future<void> markAsRead(String notificationId) async {
    final all = await _getAll();
    final index = all.indexWhere((n) => n.id == notificationId);
    if (index >= 0) {
      all[index] = all[index].copyWith(isRead: true);
      await _saveAll(all);
    }
  }

  // TANDAI SEMUA SUDAH DIBACA
  static Future<void> markAllAsRead(String userEmail) async {
    final all = await _getAll();
    for (var i = 0; i < all.length; i++) {
      if (all[i].userEmail == userEmail && !all[i].isRead) {
        all[i] = all[i].copyWith(isRead: true);
      }
    }
    await _saveAll(all);
  }

  // HAPUS SATU
  static Future<void> deleteNotification(String notificationId) async {
    final all = await _getAll();
    all.removeWhere((n) => n.id == notificationId);
    await _saveAll(all);
  }

  // HAPUS SEMUA USER
  static Future<void> clearUserNotifications(String userEmail) async {
    final all = await _getAll();
    all.removeWhere((n) => n.userEmail == userEmail);
    await _saveAll(all);
  }
}
