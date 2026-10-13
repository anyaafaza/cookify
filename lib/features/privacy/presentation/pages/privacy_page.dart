import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  // Data Kebijakan Privasi
  static const List<Map<String, String>> _sections = [
    {
      'title': '1. Informasi yang Kami Kumpulkan',
      'content':
          'Cookify menyimpan data akun (nama dan email), preferensi tema, resep favorit, dan riwayat pencarian kamu. Semua data ini disimpan secara lokal di perangkatmu, bukan di server kami.',
    },
    {
      'title': '2. Bagaimana Kami Menggunakan Data',
      'content':
          'Data yang tersimpan digunakan hanya untuk keperluan personalisasi pengalaman kamu, seperti menampilkan nama di profil, menyimpan favorit, dan mengingat tema pilihanmu.',
    },
    {
      'title': '3. Penyimpanan Data',
      'content':
          'Data disimpan menggunakan penyimpanan lokal (SharedPreferences) di browser atau perangkatmu. Kami tidak mengirim data ke server eksternal mana pun.',
    },
    {
      'title': '4. Keamanan Data',
      'content':
          'Password kamu disimpan dalam bentuk hash (SHA-256) sehingga tidak dapat dibaca dalam bentuk aslinya. Namun, kami tetap menyarankan untuk tidak menggunakan password yang sama dengan akun penting lainnya.',
    },
    {
      'title': '5. Berbagi Data dengan Pihak Ketiga',
      'content':
          'Cookify tidak menjual, menyewakan, atau membagikan data pribadi kamu kepada pihak ketiga. Semua data hanya digunakan di dalam aplikasi.',
    },
    {
      'title': '6. Hak Kamu',
      'content':
          'Kamu berhak untuk menghapus akun, mengubah data profil, atau menghapus seluruh data kamu kapan saja dengan mengakses menu Pengaturan di halaman Profil.',
    },
    {
      'title': '7. Perubahan Kebijakan',
      'content':
          'Kami dapat memperbarui kebijakan privasi ini dari waktu ke waktu. Setiap perubahan akan diinformasikan melalui halaman ini.',
    },
    {
      'title': '8. Hubungi Kami',
      'content':
          'Jika kamu memiliki pertanyaan tentang kebijakan privasi ini, silakan hubungi kami di hello@cookify.id.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kebijakan Privasi',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.privacy_tip_outlined,
                    size: 48,
                    color: Colors.white,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Kebijakan Privasi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Terakhir diperbarui: 10 Oktober 2026',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Di Cookify, kami sangat menghargai privasi kamu. '
              'Kebijakan ini menjelaskan bagaimana kami mengumpulkan, '
              'menggunakan, dan melindungi data pribadimu.',
              style: TextStyle(
                fontSize: 13,
                height: 1.6,
                color: textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 20),
            ..._sections.map((section) => _PrivacySection(
                  title: section['title']!,
                  content: section['content']!,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                )),
            const SizedBox(height: 24),
            Center(
              child: Text(
                '© 2026 Cookify. All rights reserved.',
                style: TextStyle(
                  fontSize: 12,
                  color: textSecondary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _PrivacySection extends StatelessWidget {
  final String title;
  final String content;
  final Color textPrimary;
  final Color textSecondary;

  const _PrivacySection({
    required this.title,
    required this.content,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              height: 1.6,
              color: textSecondary,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
