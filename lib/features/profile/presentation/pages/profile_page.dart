import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/favorite_service.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/widgets/cookify_logo.dart';
import '../../../about/presentation/pages/about_page.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../help/presentation/pages/help_page.dart';
import '../../../notification/presentation/pages/notification_page.dart';
import '../../../privacy/presentation/pages/privacy_page.dart';
import 'edit_profile_page.dart';
import '../../../../core/services/review_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String _userName = 'Pengguna Cookify';
  String _userEmail = 'user@cookify.id';
  int _favoriteCount = 0;
  int _reviewCount = 0;
  bool _isLoading = true;

  Future<void> refresh() async {
    await _loadUserData();
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await AuthService.getUserName();
    final email = await AuthService.getUserEmail();
    final favIds = await FavoriteService.getFavoriteIds();
    final reviewCount = await ReviewService.countUserReviews(email);

    if (mounted) {
      setState(() {
        _userName = name;
        _userEmail = email;
        _favoriteCount = favIds.length;
        _reviewCount = reviewCount;
        _isLoading = false;
      });
    }
  }

  Future<void> _showLogoutDialog() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Keluar dari Cookify?',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: textPrimary,
          ),
        ),
        content: Text(
          'Kamu yakin ingin keluar dari akun ini?',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Batal',
              style: TextStyle(
                color: textSecondary,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Keluar',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _logout();
    }
  }

  Future<void> _logout() async {
    await AuthService.logout();

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  Future<void> _showThemeDialog() async {
    final themeController = context.read<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final selected = await showDialog<ThemeMode>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Pilih Tema',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _themeOption(
              icon: Icons.light_mode,
              label: 'Terang',
              mode: ThemeMode.light,
              current: themeController.themeMode,
              textPrimary: textPrimary,
            ),
            _themeOption(
              icon: Icons.dark_mode,
              label: 'Gelap',
              mode: ThemeMode.dark,
              current: themeController.themeMode,
              textPrimary: textPrimary,
            ),
            _themeOption(
              icon: Icons.brightness_auto,
              label: 'Ikut Sistem',
              mode: ThemeMode.system,
              current: themeController.themeMode,
              textPrimary: textPrimary,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Batal',
              style: TextStyle(
                color: textSecondary,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (selected != null) {
      await themeController.setTheme(selected);
    }
  }

  Widget _themeOption({
    required IconData icon,
    required String label,
    required ThemeMode mode,
    required ThemeMode current,
    required Color textPrimary,
  }) {
    final isSelected = mode == current;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : textPrimary,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? AppColors.primary : textPrimary,
        ),
      ),
      trailing:
          isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
      onTap: () => Navigator.pop(context, mode),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkSurface : Colors.grey[50];
    final borderColor = isDark ? AppColors.darkBorder : Colors.grey[200]!;
    final textPrimary = isDark ? Colors.white : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CookifyLogo(size: 45),
                            IconButton(
                              icon: const Icon(Icons.logout),
                              onPressed: _showLogoutDialog,
                              tooltip: 'Keluar',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Profile Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.accent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 48,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _userName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _userEmail,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Statistik
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            _buildStat(
                              '$_favoriteCount',
                              'Favorit',
                              cardColor,
                              borderColor,
                              textSecondary,
                            ),
                            const SizedBox(width: 12),
                            _buildStat(
                              '$_reviewCount',
                              'Review',
                              cardColor,
                              borderColor,
                              textSecondary,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Menu
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pengaturan',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // EDIT PROFIL
                            _buildMenuTile(
                              icon: Icons.person_outline,
                              title: 'Edit Profil',
                              cardColor: cardColor,
                              borderColor: borderColor,
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                              onTap: () async {
                                final updated = await Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const EditProfilePage(),
                                  ),
                                );
                                if (updated == true && mounted) {
                                  _loadUserData();
                                }
                              },
                            ),

                            // TEMA
                            _buildMenuTile(
                              icon: context.watch<ThemeController>().isDarkMode
                                  ? Icons.dark_mode
                                  : Icons.light_mode_outlined,
                              title: 'Tema',
                              subtitle:
                                  context.watch<ThemeController>().isDarkMode
                                      ? 'Gelap'
                                      : 'Terang',
                              cardColor: cardColor,
                              borderColor: borderColor,
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                              onTap: _showThemeDialog,
                            ),

                            // NOTIFIKASI
                            _buildMenuTile(
                              icon: Icons.notifications_outlined,
                              title: 'Notifikasi',
                              cardColor: cardColor,
                              borderColor: borderColor,
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const NotificationPage(),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 24),

                            Text(
                              'Lainnya',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // TENTANG
                            _buildMenuTile(
                              icon: Icons.info_outline,
                              title: 'Tentang Cookify & About Me',
                              cardColor: cardColor,
                              borderColor: borderColor,
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AboutPage(),
                                  ),
                                );
                              },
                            ),

                            // BANTUAN
                            _buildMenuTile(
                              icon: Icons.help_outline,
                              title: 'Bantuan & FAQ',
                              cardColor: cardColor,
                              borderColor: borderColor,
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const HelpPage(),
                                  ),
                                );
                              },
                            ),

                            // PRIVASI
                            _buildMenuTile(
                              icon: Icons.privacy_tip_outlined,
                              title: 'Kebijakan Privasi',
                              cardColor: cardColor,
                              borderColor: borderColor,
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const PrivacyPage(),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 16),

                            // KELUAR
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: OutlinedButton.icon(
                                onPressed: _showLogoutDialog,
                                icon: const Icon(Icons.logout, size: 20),
                                label: const Text(
                                  'Keluar',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: const BorderSide(
                                    color: AppColors.primary,
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildStat(
    String value,
    String label,
    Color? cardColor,
    Color borderColor,
    Color textSecondary,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required Color? cardColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary, size: 22),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            color: textPrimary,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: textSecondary,
                  fontFamily: 'Poppins',
                ),
              )
            : null,
        trailing: Icon(
          Icons.chevron_right,
          size: 20,
          color: textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }
}
