import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum ViewMode { grid, list }

class ViewToggle extends StatelessWidget {
  final ViewMode currentMode;
  final ValueChanged<ViewMode> onChanged;

  const ViewToggle({
    super.key,
    required this.currentMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(icon: Icons.grid_view, mode: ViewMode.grid),
          _buildButton(icon: Icons.view_list, mode: ViewMode.list),
        ],
      ),
    );
  }

  Widget _buildButton({required IconData icon, required ViewMode mode}) {
    final isActive = currentMode == mode;
    return GestureDetector(
      onTap: () => onChanged(mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isActive ? Colors.white : Colors.grey[600],
        ),
      ),
    );
  }
}
