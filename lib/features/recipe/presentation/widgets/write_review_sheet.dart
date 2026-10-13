import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/review_service.dart';

class WriteReviewSheet extends StatefulWidget {
  final String recipeId;
  final String userId;
  final String userName;
  final Review? existingReview;

  const WriteReviewSheet({
    super.key,
    required this.recipeId,
    required this.userId,
    required this.userName,
    this.existingReview,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String recipeId,
    required String userId,
    required String userName,
    Review? existingReview,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WriteReviewSheet(
        recipeId: recipeId,
        userId: userId,
        userName: userName,
        existingReview: existingReview,
      ),
    );
  }

  @override
  State<WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends State<WriteReviewSheet> {
  late double _rating;
  late TextEditingController _commentController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.existingReview?.rating ?? 5.0;
    _commentController = TextEditingController(
      text: widget.existingReview?.comment ?? '',
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Komentar tidak boleh kosong'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    await ReviewService.addOrUpdateReview(
      recipeId: widget.recipeId,
      userId: widget.userId,
      userName: widget.userName,
      rating: _rating,
      comment: _commentController.text.trim(),
    );

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkSurface : Colors.white;
    final isEditing = widget.existingReview != null;

    // Warna adaptif
    final textPrimary = isDark ? Colors.white : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final inputBg = isDark ? Colors.grey[900] : Colors.grey[50];
    final inputBorder = isDark ? AppColors.darkBorder : Colors.grey[200]!;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[700] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Judul
                Text(
                  isEditing ? 'Edit Review' : 'Beri Review',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: textPrimary,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Bagikan pengalamanmu memasak resep ini',
                  style: TextStyle(
                    fontSize: 13,
                    color: textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 20),

                // Rating Bintang
                Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (i) {
                          return GestureDetector(
                            onTap: () {
                              setState(() => _rating = (i + 1).toDouble());
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                i < _rating ? Icons.star : Icons.star_border,
                                size: 44,
                                color: AppColors.accent,
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getRatingLabel(_rating),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Komentar
                Text(
                  'Komentar',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _commentController,
                  maxLines: 4,
                  maxLength: 500,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Ceritakan pengalamanmu...',
                    hintStyle: TextStyle(
                      color: textSecondary,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                    counterStyle: TextStyle(
                      color: textSecondary,
                      fontFamily: 'Poppins',
                    ),
                    filled: true,
                    fillColor: inputBg,
                    contentPadding: const EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: inputBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Tombol
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: textSecondary,
                            side: BorderSide(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : Colors.grey[300]!,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Batal',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  isEditing ? 'Simpan' : 'Kirim',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getRatingLabel(double rating) {
    if (rating >= 4.5) return 'Luar biasa! ⭐';
    if (rating >= 3.5) return 'Bagus 👍';
    if (rating >= 2.5) return 'Cukup';
    if (rating >= 1.5) return 'Kurang';
    return 'Buruk 😞';
  }
}
