import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/share_service.dart';
import '../../domain/entities/recipe.dart';

class ShareBottomSheet extends StatelessWidget {
  final Recipe recipe;

  const ShareBottomSheet({super.key, required this.recipe});

  static Future<void> show(BuildContext context, Recipe recipe) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ShareBottomSheet(recipe: recipe),
    );
  }

  Future<void> _handleShare(
    BuildContext context,
    String platform,
  ) async {
    // Tutup bottom sheet dulu
    Navigator.pop(context);

    final message = ShareService.buildMessage(
      title: recipe.title,
      description: recipe.description,
      cookingTime: recipe.cookingTime,
      difficulty: recipe.difficulty,
    );

    try {
      switch (platform) {
        case 'whatsapp':
          await ShareService.shareToWhatsApp(message);
          break;
        case 'telegram':
          await ShareService.shareToTelegram(message);
          break;
        case 'facebook':
          await ShareService.shareToFacebook(message);
          break;
        case 'twitter':
          await ShareService.shareToTwitter(message);
          break;
        case 'email':
          await ShareService.shareToEmail(
            subject: 'Resep: ${recipe.title}',
            body: message,
          );
          break;
        case 'system':
          await ShareService.shareViaSystem(
            text: message,
            subject: recipe.title,
          );
          break;
        case 'copy':
          await Clipboard.setData(ClipboardData(text: message));
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Teks resep berhasil disalin!'),
                backgroundColor: AppColors.success,
                duration: Duration(seconds: 2),
              ),
            );
          }
          break;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal share: $e'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkSurface : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 16),

              // Judul
              const Text(
                'Bagikan Resep',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),

              const SizedBox(height: 4),

              Text(
                recipe.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.lightTextSecondary,
                  fontFamily: 'Poppins',
                ),
              ),

              const SizedBox(height: 24),

              // Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: [
                  _buildOption(
                    context,
                    icon: Icons.chat,
                    color: const Color(0xFF25D366),
                    label: 'WhatsApp',
                    platform: 'whatsapp',
                  ),
                  _buildOption(
                    context,
                    icon: Icons.send,
                    color: const Color(0xFF0088CC),
                    label: 'Telegram',
                    platform: 'telegram',
                  ),
                  _buildOption(
                    context,
                    icon: Icons.facebook,
                    color: const Color(0xFF1877F2),
                    label: 'Facebook',
                    platform: 'facebook',
                  ),
                  _buildOption(
                    context,
                    icon: Icons.alternate_email,
                    color: Colors.black,
                    label: 'Twitter/X',
                    platform: 'twitter',
                  ),
                  _buildOption(
                    context,
                    icon: Icons.email,
                    color: const Color(0xFFEA4335),
                    label: 'Email',
                    platform: 'email',
                  ),
                  _buildOption(
                    context,
                    icon: Icons.share,
                    color: AppColors.primary,
                    label: 'Lainnya',
                    platform: 'system',
                  ),
                  _buildOption(
                    context,
                    icon: Icons.copy,
                    color: Colors.grey[700]!,
                    label: 'Salin',
                    platform: 'copy',
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Tombol Batal
              SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightTextSecondary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Opsi Share
  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
    required String platform,
  }) {
    return GestureDetector(
      onTap: () => _handleShare(context, platform),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
