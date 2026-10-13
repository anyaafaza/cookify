import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CookifyLogo extends StatelessWidget {
  final double size; // tinggi logo
  final bool showText;

  const CookifyLogo({
    super.key,
    this.size = 45,
    this.showText = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      child: Transform.scale(
        scale: 1.5, // ← zoom 1.5x kalau perlu
        alignment: Alignment.centerLeft,
        child: Image.asset(
          'assets/images/logo/logo_cookify.png',
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(
            Icons.restaurant_menu,
            size: size,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
