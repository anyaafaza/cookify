import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/favorite_service.dart';
import '../../../../core/services/review_service.dart';
import '../../../../core/widgets/rating_stars.dart';
import '../../domain/entities/recipe.dart';
import '../widgets/ingredient_section.dart';
import '../widgets/nutrition_section.dart';
import '../widgets/review_section.dart';
import '../widgets/share_bottom_sheet.dart';
import '../widgets/step_section.dart';
import 'cooking_mode_page.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorite = false;
  int _realReviewCount = 0;
  double _averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadFavoriteStatus();
    _loadReviewCount();
  }

  Future<void> _loadFavoriteStatus() async {
    final isFav = await FavoriteService.isFavorite(widget.recipe.id);
    if (mounted) {
      setState(() => _isFavorite = isFav);
    }
  }

  Future<void> _loadReviewCount() async {
    final summary = await ReviewService.getRatingSummary(widget.recipe.id);
    if (mounted) {
      setState(() {
        _realReviewCount = summary['count'] as int;
        _averageRating = (summary['average'] as num).toDouble();
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final newStatus = await FavoriteService.toggleFavorite(widget.recipe.id);
    if (mounted) {
      setState(() => _isFavorite = newStatus);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus ? 'Ditambahkan ke favorit' : 'Dihapus dari favorit',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayRating = _averageRating > 0 ? _averageRating : recipe.rating;

    final textPrimary = isDark ? Colors.white : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final tabBg = isDark ? AppColors.darkSurface : Colors.grey[100];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
              child: _circleButton(
                icon: Icons.arrow_back,
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              _circleButton(
                icon: Icons.share,
                onPressed: () {
                  ShareBottomSheet.show(context, recipe);
                },
              ),
              const SizedBox(width: 4),
              _circleButton(
                icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
                iconColor: _isFavorite ? AppColors.primary : Colors.black87,
                onPressed: _toggleFavorite,
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    recipe.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.restaurant_menu,
                        size: 80,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: textPrimary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Rating
                  Row(
                    children: [
                      RatingStars(rating: displayRating, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        '($_realReviewCount review)',
                        style: TextStyle(
                          fontSize: 13,
                          color: textSecondary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Deskripsi
                  Text(
                    recipe.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: textSecondary,
                      fontFamily: 'Poppins',
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Info Cards
                  Row(
                    children: [
                      _infoCard(context, Icons.access_time, recipe.cookingTime,
                          'Waktu'),
                      const SizedBox(width: 8),
                      _infoCard(
                          context, Icons.restaurant, recipe.portions, 'Porsi'),
                      const SizedBox(width: 8),
                      _infoCard(context, Icons.bar_chart, recipe.difficulty,
                          'Tingkat'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Container(
                    decoration: BoxDecoration(
                      color: tabBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: textSecondary,
                      labelStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      tabs: const [
                        Tab(text: 'Bahan'),
                        Tab(text: 'Langkah'),
                        Tab(text: 'Nutrisi'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 400,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        SingleChildScrollView(
                          child: IngredientSection(
                            ingredients: recipe.ingredients,
                          ),
                        ),
                        SingleChildScrollView(
                          child: StepSection(steps: recipe.steps),
                        ),
                        SingleChildScrollView(
                          child: recipe.nutrition != null
                              ? NutritionSection(nutrition: recipe.nutrition!)
                              : Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(32),
                                    child: Text(
                                      'Info nutrisi belum tersedia',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: textSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CookingModePage(recipe: recipe),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text(
                        'Mulai Memasak',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ─── Section Review ───
                  ReviewSection(
                    recipeId: recipe.id,
                    onReviewSubmitted: _loadReviewCount,
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color iconColor = Colors.black87,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor, size: 20),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
      ),
    );
  }

  Widget _infoCard(
      BuildContext context, IconData icon, String value, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final cardBg = isDark ? AppColors.darkSurface : Colors.grey[50];
    final cardBorder = isDark ? AppColors.darkBorder : Colors.grey[200]!;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cardBorder),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(height: 6),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: textPrimary,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
