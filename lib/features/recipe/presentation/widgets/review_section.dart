import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/review_service.dart';
import 'review_card.dart';
import 'write_review_sheet.dart';

class ReviewSection extends StatefulWidget {
  final String recipeId;
  final VoidCallback? onReviewSubmitted;

  const ReviewSection({
    super.key,
    required this.recipeId,
    this.onReviewSubmitted,
  });

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  List<Review> _reviews = [];
  Map<String, dynamic> _summary = {};
  String _userId = '';
  String _userName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final user = await AuthService.getCurrentUser();
    final reviews = await ReviewService.getReviewsForRecipe(widget.recipeId);
    final summary = await ReviewService.getRatingSummary(widget.recipeId);

    if (mounted) {
      setState(() {
        _userId = (user?['email'] as String?) ?? '';
        _userName = (user?['name'] as String?) ?? 'Pengguna';
        _reviews = reviews;
        _summary = summary;
        _isLoading = false;
      });
    }
  }

  Future<void> _writeReview() async {
    final myReview = await ReviewService.getUserReview(
      recipeId: widget.recipeId,
      userId: _userId,
    );

    if (!mounted) return;

    final result = await WriteReviewSheet.show(
      context,
      recipeId: widget.recipeId,
      userId: _userId,
      userName: _userName,
      existingReview: myReview,
    );

    if (!mounted) return;

    if (result == true) {
      await NotificationService.addNotification(
        userEmail: _userId,
        title: 'Review Kamu Terkirim ⭐',
        body: 'Terima kasih sudah memberi review untuk resep ini!',
        type: 'review',
      );

      if (!mounted) return;

      _loadData();
      widget.onReviewSubmitted?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review berhasil dikirim!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _deleteReview(Review review) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Hapus Review?',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: const Text(
          'Review yang dihapus tidak bisa dikembalikan.',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Batal',
              style: TextStyle(
                color: AppColors.lightTextSecondary,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Hapus',
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
      await ReviewService.deleteReview(review.id);
      if (!mounted) return;
      _loadData();
      widget.onReviewSubmitted?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final myReview = _reviews.firstWhere(
      (r) => r.userId == _userId,
      orElse: () => Review(
        id: '',
        recipeId: '',
        userId: '',
        userName: '',
        rating: 0,
        comment: '',
        createdAt: DateTime.now(),
      ),
    );
    final hasReviewed = myReview.id.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '⭐ Review (${_summary['count'] ?? 0})',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: textPrimary, // ← ADAPTIF
              ),
            ),
            if (!hasReviewed)
              TextButton.icon(
                onPressed: _writeReview,
                icon: const Icon(Icons.edit, size: 16),
                label: const Text(
                  'Tulis',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (_reviews.isNotEmpty) _buildSummary(textPrimary, textSecondary),
        const SizedBox(height: 16),
        if (_reviews.isEmpty)
          _buildEmptyState(textPrimary, textSecondary)
        else
          ..._reviews.map((review) {
            return ReviewCard(
              review: review,
              isOwn: review.userId == _userId,
              onEdit: _writeReview,
              onDelete: () => _deleteReview(review),
            );
          }),
      ],
    );
  }

  Widget _buildSummary(Color textPrimary, Color textSecondary) {
    final average = (_summary['average'] as num).toDouble();
    final count = _summary['count'] as int;
    final distribution = _summary['distribution'] as Map;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.accent.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                average.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: AppColors.primary,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < average.round() ? Icons.star : Icons.star_border,
                    size: 14,
                    color: AppColors.accent,
                  );
                }),
              ),
              const SizedBox(height: 4),
              Text(
                '$count review',
                style: TextStyle(
                  fontSize: 11,
                  color: textSecondary, // ← ADAPTIF
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: List.generate(5, (i) {
                final star = 5 - i;
                final starCount = distribution[star] ?? 0;
                final percent = count > 0 ? starCount / count : 0.0;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        '$star',
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: textPrimary, // ← ADAPTIF
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.star,
                        size: 12,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percent,
                            minHeight: 6,
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 20,
                        child: Text(
                          '$starCount',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'Poppins',
                            color: textSecondary, // ← ADAPTIF
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Color textPrimary, Color textSecondary) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.grey[50];
    final cardBorder = isDark ? AppColors.darkBorder : Colors.grey[200]!;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cardBorder),
      ),
      child: Column(
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'Belum ada review',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: textPrimary, // ← ADAPTIF
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Jadilah yang pertama memberi review!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: textSecondary, // ← ADAPTIF
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _writeReview,
            icon: const Icon(Icons.edit, size: 16),
            label: const Text(
              'Tulis Review',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
