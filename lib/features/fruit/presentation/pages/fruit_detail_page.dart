import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../recipe/data/dummy_recipes.dart';
import '../../../recipe/presentation/pages/recipe_detail_page.dart';
import '../../../recipe/presentation/widgets/recipe_card.dart';
import '../../data/fruit_data.dart';

class FruitDetailPage extends StatelessWidget {
  final Fruit fruit;

  const FruitDetailPage({super.key, required this.fruit});

  @override
  Widget build(BuildContext context) {
    const fruitToRecipes = {
      'Alpukat': ['es_teler'],
      'Anggur': ['tanghulu', 'salad_buah', 'fruit_sando'],
      'Apel': ['apple_pie', 'salad_buah'],
      'Blueberry': ['berry_smoothies', 'berry_cheesecake', 'acai'],
      'Jeruk': <String>[],
      'Kiwi': ['salad_buah', 'fruit_sando'],
      'Mangga': [
        'jus_mangga',
        'mango_sticky_rice',
        'pudding_mangga',
        'rujak_buah',
      ],
      'Melon': <String>[],
      'Nanas': ['rujak_buah'],
      'Pepaya': ['rujak_buah'],
      'Pisang': [
        'pisang_goreng',
        'bolu_pisang',
        'banana_strawberry_pancake',
        'fruit_sando',
        'salad_buah',
        'acai',
        'es_teler',
      ],
      'Semangka': <String>[],
      'Strawberry': [
        'strawberry_cake',
        'berry_smoothies',
        'berry_cheesecake',
        'fruit_sando',
        'salad_buah',
        'tanghulu',
        'acai',
        'banana_strawberry_pancake',
      ],
      'Mix': [
        'acai',
        'banana_strawberry_pancake',
        'berry_cheesecake',
        'berry_smoothies',
        'es_teler',
        'fruit_sando',
        'rujak_buah',
        'salad_buah',
        'tanghulu',
      ],
    };

    final ids = fruitToRecipes[fruit.name] ?? [];
    final relatedRecipes =
        dummyRecipes.where((r) => ids.contains(r.id)).toList();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                fruit.name,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: AppColors.primary.withValues(alpha: 0.1),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Image.asset(
                        fruit.imagePath,
                        height: 200,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.image,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.primary.withValues(alpha: 0.7),
                        ],
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
                    fruit.nameLatin,
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: textSecondary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    fruit.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: textSecondary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '🥗 Nutrisi (per 100g)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _nutriCard(
                        context,
                        Icons.local_fire_department,
                        '${fruit.calories}',
                        'kkal',
                      ),
                      const SizedBox(width: 8),
                      _nutriCard(
                        context,
                        Icons.bolt,
                        '${fruit.vitaminC}mg',
                        'Vit C',
                      ),
                      const SizedBox(width: 8),
                      _nutriCard(
                        context,
                        Icons.grass,
                        '${fruit.fiber}g',
                        'Serat',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (fruit.season.isNotEmpty) ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Musim: ${fruit.season}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (fruit.varieties.isNotEmpty) ...[
                    Text(
                      '🍇 Variasi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: fruit.varieties.map((v) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            v,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (fruit.tips.isNotEmpty) ...[
                    Text(
                      '💡 Tips',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...fruit.tips.map((tip) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                tip,
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.5,
                                  fontFamily: 'Poppins',
                                  color: textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                  ],
                  Text(
                    '🍽️ Resep dengan ${fruit.name} (${relatedRecipes.length})',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          if (relatedRecipes.isNotEmpty)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: relatedRecipes.length,
                  itemBuilder: (context, i) => RecipeCard(
                    recipe: relatedRecipes[i],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              RecipeDetailPage(recipe: relatedRecipes[i]),
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          else
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'Belum ada resep untuk buah ini',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _nutriCard(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
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
