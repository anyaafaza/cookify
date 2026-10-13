import 'package:flutter/material.dart';

import '../../../../core/widgets/cookify_logo.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../fruit/data/fruit_data.dart';
import '../../../fruit/presentation/pages/fruit_category_page.dart';
import '../../../fruit/presentation/pages/fruit_detail_page.dart';
import '../../../recipe/data/dummy_recipes.dart';
import '../../../recipe/presentation/pages/recipe_detail_page.dart';
import '../../../recipe/presentation/widgets/recipe_card.dart';
import '../widgets/fruit_category_chip.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, String>> fruits = const [
    {'name': 'Mangga', 'image': 'assets/images/fruits/mangga.png'},
    {'name': 'Pisang', 'image': 'assets/images/fruits/pisang.png'},
    {'name': 'Strawberry', 'image': 'assets/images/fruits/strawberry.png'},
    {'name': 'Apel', 'image': 'assets/images/fruits/apel.png'},
    {'name': 'Jeruk', 'image': 'assets/images/fruits/jeruk.png'},
    {'name': 'Semangka', 'image': 'assets/images/fruits/semangka.png'},
    {'name': 'Nanas', 'image': 'assets/images/fruits/nanas.png'},
    {'name': 'Alpukat', 'image': 'assets/images/fruits/alpukat.png'},
    {'name': 'Anggur', 'image': 'assets/images/fruits/anggur.png'},
    {'name': 'Blueberry', 'image': 'assets/images/fruits/blueberry.png'},
    {'name': 'Kiwi', 'image': 'assets/images/fruits/kiwi.png'},
    {'name': 'Melon', 'image': 'assets/images/fruits/melon.png'},
    {'name': 'Pepaya', 'image': 'assets/images/fruits/pepaya.png'},
  ];

  @override
  Widget build(BuildContext context) {
    const popularIds = [
      'acai',
      'berry_smoothies',
      'mango_sticky_rice',
      'bolu_pisang',
      'berry_cheesecake',
    ];

    final popularRecipes = popularIds
        .map((id) => dummyRecipes.firstWhere((r) => r.id == id))
        .toList();

    const latestIds = [
      'tanghulu',
      'fruit_sando',
      'apple_pie',
      'acai',
      'salad_buah',
    ];

    final latestRecipes = latestIds
        .map((id) => dummyRecipes.firstWhere((r) => r.id == id))
        .toList();
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
                      CookifyLogo(size: 45),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SectionHeader(
                  title: '🍎 Kategori Buah',
                  onSeeAll: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FruitCategoryPage(),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: fruits.length,
                    itemBuilder: (context, i) {
                      final fruitName = fruits[i]['name']!;
                      return FruitCategoryChip(
                        name: fruitName,
                        imagePath: fruits[i]['image']!,
                        onTap: () {
                          final fruit = fruitsData.firstWhere(
                            (f) =>
                                f.name.toLowerCase() == fruitName.toLowerCase(),
                            orElse: () => fruitsData.first,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FruitDetailPage(fruit: fruit),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SectionHeader(
                  title: '📈 Populer Minggu Ini',
                ),
                SizedBox(
                  height: 190,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: popularRecipes.length,
                    itemBuilder: (context, i) => RecipeCard(
                      recipe: popularRecipes[i],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                RecipeDetailPage(recipe: popularRecipes[i]),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SectionHeader(
                  title: '🆕 Resep Terbaru',
                ),
                SizedBox(
                  height: 190,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: latestRecipes.length,
                    itemBuilder: (context, i) => RecipeCard(
                      recipe: latestRecipes[i],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                RecipeDetailPage(recipe: latestRecipes[i]),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
