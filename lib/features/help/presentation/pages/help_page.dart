import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  static const List<Map<String, String>> _faqs = [
    {
      'q': 'Apa itu Cookify?',
      'a':
          'Cookify adalah platform resep olahan buah terlengkap. Di sini kamu bisa menemukan, menyimpan, dan membagikan resep buah favoritmu.',
    },
    {
      'q': 'Bagaimana cara mencari resep?',
      'a':
          'Buka tab "Cari" di bawah, lalu ketik nama resep, bahan, atau buah yang kamu inginkan. Kamu juga bisa klik chip pencarian populer untuk mencari lebih cepat.',
    },
    {
      'q': 'Bagaimana cara menyimpan resep favorit?',
      'a':
          'Klik ikon hati (❤️) di kartu resep atau di halaman detail resep. Resep akan otomatis tersimpan di tab "Favorit".',
    },
    {
      'q': 'Apakah data saya aman?',
      'a':
          'Ya. Semua data kamu (akun, favorit, riwayat pencarian) disimpan secara lokal di perangkatmu. Kami tidak mengirim data ke server manapun.',
    },
    {
      'q': 'Bagaimana cara mengganti tema?',
      'a':
          'Buka tab "Profil" → pilih menu "Tema" → pilih Terang, Gelap, atau Ikut Sistem. Tema akan otomatis tersimpan.',
    },
    {
      'q': 'Bagaimana cara logout?',
      'a':
          'Buka tab "Profil" → klik tombol "Keluar" di bawah, atau klik ikon 🚪 di kanan atas.',
    },
    {
      'q': 'Apakah saya bisa mendaftar lebih dari satu akun?',
      'a':
          'Bisa. Kamu bisa daftar beberapa akun dengan email berbeda, lalu login dengan salah satu akun yang kamu inginkan.',
    },
    {
      'q': 'Bagaimana cara menghubungi tim Cookify?',
      'a':
          'Kamu bisa kirim email ke hello@cookify.id. Kami akan merespons dalam 1-2 hari kerja.',
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
          'Bantuan & FAQ',
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
                    Icons.help_outline,
                    size: 48,
                    color: Colors.white,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Ada yang bisa kami bantu?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Temukan jawaban dari pertanyaan umum',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Pertanyaan Umum',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ..._faqs.map((faq) => _FaqTile(
                  question: faq['q']!,
                  answer: faq['a']!,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                )),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.email_outlined,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Masih butuh bantuan?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Hubungi kami di hello@cookify.id',
                          style: TextStyle(
                            fontSize: 12,
                            color: textSecondary,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;
  final Color textPrimary;
  final Color textSecondary;

  const _FaqTile({
    required this.question,
    required this.answer,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.grey[50];
    final cardBorder = isDark ? AppColors.darkBorder : Colors.grey[200]!;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cardBorder),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        iconColor: AppColors.primary,
        collapsedIconColor: textSecondary,
        title: Text(
          question,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: textPrimary,
          ),
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 13,
                height: 1.6,
                color: textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
