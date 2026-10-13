import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareService {
  static String _buildMessage({
    required String title,
    required String description,
    required String cookingTime,
    required String difficulty,
  }) {
    return '''
🍳 *$title*
📖 Cookify - Masak buah jadi lezat

$description

⏱️ Waktu: $cookingTime
📊 Tingkat: $difficulty

Cek resep lengkap di Cookify! 🍓🥭🍌
''';
  }

  static Future<void> shareToWhatsApp(String text) async {
    final encoded = Uri.encodeComponent(text);
    final url = Uri.parse('https://wa.me/?text=$encoded');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak bisa membuka WhatsApp';
    }
  }

  static Future<void> shareToTelegram(String text) async {
    final encoded = Uri.encodeComponent(text);
    final url = Uri.parse('https://t.me/share/url?url=$encoded&text=$encoded');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak bisa membuka Telegram';
    }
  }

  static Future<void> shareToFacebook(String text) async {
    final encoded = Uri.encodeComponent(text);
    final url =
        Uri.parse('https://www.facebook.com/sharer/sharer.php?u=$encoded');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak bisa membuka Facebook';
    }
  }

  static Future<void> shareToTwitter(String text) async {
    final encoded = Uri.encodeComponent(text);
    final url = Uri.parse('https://twitter.com/intent/tweet?text=$encoded');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak bisa membuka Twitter';
    }
  }

  static Future<void> shareToEmail({
    required String subject,
    required String body,
  }) async {
    final url = Uri.parse(
      'mailto:?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak bisa membuka Email';
    }
  }

  static Future<void> shareViaSystem({
    required String text,
    String? subject,
  }) async {
    await Share.share(
      text,
      subject: subject,
    );
  }

  static Future<void> copyLink(String text, BuildContext context) async {
    await Share.share(text);
  }

  static String buildMessage({
    required String title,
    required String description,
    required String cookingTime,
    required String difficulty,
  }) {
    return _buildMessage(
      title: title,
      description: description,
      cookingTime: cookingTime,
      difficulty: difficulty,
    );
  }
}
