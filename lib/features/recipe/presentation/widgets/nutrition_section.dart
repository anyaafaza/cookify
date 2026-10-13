import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/nutrition.dart';

class NutritionSection extends StatelessWidget {
  final Nutrition nutrition;

  const NutritionSection({super.key, required this.nutrition});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _buildCard(context, 'Kalori', '${nutrition.calories}', 'kkal',
                Icons.local_fire_department),
            const SizedBox(width: 12),
            _buildCard(context, 'Protein', '${nutrition.protein}', 'gr',
                Icons.fitness_center),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildCard(
                context, 'Karbo', '${nutrition.carbs}', 'gr', Icons.rice_bowl),
            const SizedBox(width: 12),
            _buildCard(
                context, 'Lemak', '${nutrition.fat}', 'gr', Icons.opacity),
          ],
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, String label, String value,
      String unit, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Warna text adaptif
    final valueColor = isDark ? Colors.white : AppColors.lightTextPrimary;
    final labelColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: labelColor,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: valueColor,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 12,
                    color: labelColor,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
