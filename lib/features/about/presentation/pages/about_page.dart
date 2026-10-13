import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/cookify_logo.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna adaptif
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Me',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Center(
              child: CookifyLogo(size: 100),
            ),
            const SizedBox(height: 24),
            Text(
              'Cookify',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Versi 1.0.0',
              style: TextStyle(
                fontSize: 13,
                color: textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Cookify adalah website resep olahan buah terlengkap. '
              'Di sini kamu bisa menemukan, menyimpan, dan membagikan '
              'berbagai resep olahan buah favoritmu dengan mudah.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              '👤 About Me',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pembuat Website Cookify',
              style: TextStyle(
                fontSize: 13,
                color: textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoTile(
              icon: Icons.person_outline,
              label: 'Nama',
              value: 'Aghnia Khairi Faza Maverika',
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
            _buildInfoTile(
              icon: Icons.badge_outlined,
              label: 'NIM',
              value: '25051204404',
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
            _buildInfoTile(
              icon: Icons.school_outlined,
              label: 'Mata Kuliah',
              value: 'Pemrograman Berbasis Platform',
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
            _buildInfoTile(
              icon: Icons.cake_outlined,
              label: 'TTL',
              value: 'Magetan, 23 Juli 2007',
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
            _buildInfoTile(
              icon: Icons.email_outlined,
              label: 'Email',
              value: '25051204404@mhs.unesa.ac.id',
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
            _buildInfoTile(
              icon: Icons.camera_alt_outlined,
              label: 'Instagram',
              value: '@aniiarchivee',
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
            _buildInfoTile(
              icon: Icons.code,
              label: 'GitHub',
              value: '@anyaafaza',
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              '© 2026 Cookify. All rights reserved.',
              style: TextStyle(
                fontSize: 12,
                color: textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),
    );
  }
}
