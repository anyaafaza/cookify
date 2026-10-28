import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/favorite_service.dart';
import '../../../../core/widgets/cookify_logo.dart';
import '../../../../core/widgets/view_toggle.dart';
import '../../data/dummy_recipes.dart';
import '../../domain/entities/recipe.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_page.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({super.key});

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  ViewMode _viewMode = ViewMode.grid;
  String _selectedCategory = 'Semua';
  Set<String> _favoriteIds = {};

  // DAFTAR KATEGORI BUAH
  final List<String> _categories = const [
    'Semua',
    'Alpukat',
    'Anggur',
    'Apel',
    'Blueberry',
    'Jeruk',
    'Kiwi',
    'Mangga',
    'Melon',
    'Nanas',
    'Pepaya',
    'Pisang',
    'Semangka',
    'Strawberry',
    'Mix',
  ];

  final Map<String, List<String>> _fruitToRecipes = const {
    // ─── Buah Tunggal ───
    'Alpukat': [
      'es_teler',
    ],
    'Anggur': [
      'tanghulu',
      'salad_buah',
      'fruit_sando',
    ],
    'Apel': [
      'apple_pie',
      'salad_buah',
    ],
    'Blueberry': [
      'berry_smoothies',
      'berry_cheesecake',
      'acai',
    ],
    'Jeruk': [],
    'Kiwi': [
      'salad_buah',
      'fruit_sando',
    ],
    'Mangga': [
      'jus_mangga',
      'mango_sticky_rice',
      'pudding_mangga',
      'rujak_buah',
    ],
    'Melon': [],
    'Nanas': [
      'rujak_buah',
    ],
    'Pepaya': [
      'rujak_buah',
    ],
    'Pisang': [
      'pisang_goreng',
      'bolu_pisang',
      'banana_strawberry_pancake',
      'fruit_sando',
      'salad_buah',
      'acai',
      'es_teler',
    ],
    'Semangka': [],
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

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final ids = await FavoriteService.getFavoriteIds();
    if (mounted) {
      setState(() => _favoriteIds = ids.toSet());
    }
  }

  Future<void> _toggleFavorite(Recipe recipe) async {
    final newStatus = await FavoriteService.toggleFavorite(recipe.id);
    setState(() {
      if (newStatus) {
        _favoriteIds.add(recipe.id);
      } else {
        _favoriteIds.remove(recipe.id);
      }
    });
  }

  List<Recipe> get _filteredRecipes {
    if (_selectedCategory == 'Semua') return dummyRecipes;

    final ids = _fruitToRecipes[_selectedCategory] ?? [];
    if (ids.isEmpty) return [];

    return dummyRecipes.where((r) => ids.contains(r.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CookifyLogo(size: 45),
                    ViewToggle(
                      currentMode: _viewMode,
                      onChanged: (mode) {
                        setState(() => _viewMode = mode);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 44,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  itemBuilder: (context, i) {
                    final category = _categories[i];
                    final isSelected = category == _selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() => _selectedCategory = category);
                        },
                        backgroundColor: Colors.grey[100],
                        selectedColor: AppColors.primary,
                        showCheckmark: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.grey[300]!,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      '${_filteredRecipes.length} resep',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.lightTextSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _filteredRecipes.isEmpty
                    ? _buildEmptyState()
                    : _viewMode == ViewMode.grid
                        ? _buildGrid()
                        : _buildList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 190,
        childAspectRatio: 0.95,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _filteredRecipes.length,
      itemBuilder: (context, i) {
        final recipe = _filteredRecipes[i];
        return RecipeCardGrid(
          recipe: recipe,
          isFavorite: _favoriteIds.contains(recipe.id),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeDetailPage(recipe: recipe),
              ),
            );
            _loadFavorites();
          },
          onFavoriteTap: () => _toggleFavorite(recipe),
        );
      },
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredRecipes.length,
      itemBuilder: (context, i) {
        final recipe = _filteredRecipes[i];
        return RecipeCardList(
          recipe: recipe,
          isFavorite: _favoriteIds.contains(recipe.id),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeDetailPage(recipe: recipe),
              ),
            );
            _loadFavorites();
          },
          onFavoriteTap: () => _toggleFavorite(recipe),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final isKosongKategori =
        _fruitToRecipes[_selectedCategory]?.isEmpty ?? true;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            isKosongKategori
                ? 'Belum ada resep untuk $_selectedCategory'
                : 'Tidak ada resep untuk "$_selectedCategory"',
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.lightTextSecondary,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              setState(() => _selectedCategory = 'Semua');
            },
            child: const Text(
              'Reset Filter',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
