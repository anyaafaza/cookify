import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/ingredient.dart';

class IngredientSection extends StatefulWidget {
  final List<Ingredient> ingredients;

  const IngredientSection({super.key, required this.ingredients});

  @override
  State<IngredientSection> createState() => _IngredientSectionState();
}

class _IngredientSectionState extends State<IngredientSection> {
  final Set<int> _checkedItems = {};

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final bgColor = isDark ? AppColors.darkSurface : Colors.grey[50];
    final borderColor = isDark ? AppColors.darkBorder : Colors.grey[200]!;

    return Column(
      children: widget.ingredients.asMap().entries.map((entry) {
        final index = entry.key;
        final ingredient = entry.value;
        final isChecked = _checkedItems.contains(index);

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color:
                isChecked ? AppColors.primary.withValues(alpha: 0.15) : bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isChecked ? AppColors.primary : borderColor,
            ),
          ),
          child: CheckboxListTile(
            value: isChecked,
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  _checkedItems.add(index);
                } else {
                  _checkedItems.remove(index);
                }
              });
            },
            activeColor: AppColors.primary,
            checkColor: Colors.white,
            title: Text(
              ingredient.name,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                decoration: isChecked ? TextDecoration.lineThrough : null,
                color: isChecked ? Colors.grey : textColor,
              ),
            ),
            secondary: Text(
              ingredient.amount,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isChecked ? Colors.grey : AppColors.primary,
              ),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            dense: true,
          ),
        );
      }).toList(),
    );
  }
}
