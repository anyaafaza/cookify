import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/step.dart' as entity;

class StepSection extends StatelessWidget {
  final List<entity.Step> steps;

  const StepSection({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    // Warna text adaptif
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : AppColors.lightTextPrimary;

    return Column(
      children: steps.map((step) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nomor step
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${step.number}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Deskripsi
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    step.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      fontFamily: 'Poppins',
                      color: textColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
