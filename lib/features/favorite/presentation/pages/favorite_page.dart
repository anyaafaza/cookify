import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/favorite_service.dart';
import '../../../../core/widgets/cookify_logo.dart';
import '../../../../core/widgets/view_toggle.dart';
import '../../../recipe/data/dummy_recipes.dart';
import '../../../recipe/domain/entities/recipe.dart';
import '../../../recipe/presentation/pages/recipe_detail_page.dart';
import '../../../recipe/presentation/widgets/recipe_card.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Recipe> _favorites = [];
  bool _isLoading = true;
  ViewMode _viewMode = ViewMode.grid;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);

    final ids = await FavoriteService.getFavoriteIds();
    final favs =
        dummyRecipes.where((recipe) => ids.contains(recipe.id)).toList();

    if (mounted) {
      setState(() {
        _favorites = favs;
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFavorite(Recipe recipe) async {
    await FavoriteService.removeFavorite(recipe.id);
    _loadFavorites();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dihapus dari favorit'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

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
                    _buildViewToggle(isDark),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      '❤️ Favorit Saya',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (!_isLoading && _favorites.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${_favorites.length}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _favorites.isEmpty
                        ? _buildEmptyState(textPrimary, textSecondary)
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

  Widget _buildViewToggle(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _toggleButton(Icons.grid_view, ViewMode.grid),
          _toggleButton(Icons.view_list, ViewMode.list),
        ],
      ),
    );
  }

  Widget _toggleButton(IconData icon, ViewMode mode) {
    final isActive = _viewMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _viewMode = mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isActive ? Colors.white : Colors.grey[500],
        ),
      ),
    );
  }

  // Grid View
  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 190,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _favorites.length,
      itemBuilder: (context, i) => RecipeCardGrid(
        recipe: _favorites[i],
        isFavorite: true,
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecipeDetailPage(recipe: _favorites[i]),
            ),
          );
          _loadFavorites();
        },
        onFavoriteTap: () => _removeFavorite(_favorites[i]),
      ),
    );
  }

  // List View
  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _favorites.length,
      itemBuilder: (context, i) => RecipeCardList(
        recipe: _favorites[i],
        isFavorite: true,
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecipeDetailPage(recipe: _favorites[i]),
            ),
          );
          _loadFavorites();
        },
        onFavoriteTap: () => _removeFavorite(_favorites[i]),
      ),
    );
  }

  Widget _buildEmptyState(Color textPrimary, Color textSecondary) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 100,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum Ada Favorit',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Simpan resep favorit dengan menekan ikon hati',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
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
