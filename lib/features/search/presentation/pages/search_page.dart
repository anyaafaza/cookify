import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/favorite_service.dart';
import '../../../../core/services/search_history_service.dart';
import '../../../../core/widgets/cookify_logo.dart';
import '../../../recipe/data/dummy_recipes.dart';
import '../../../recipe/domain/entities/recipe.dart';
import '../../../recipe/presentation/pages/recipe_detail_page.dart';
import '../../../recipe/presentation/widgets/recipe_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  List<Recipe> _results = [];
  List<String> _history = [];
  Set<String> _favoriteIds = {};
  bool _isSearching = false;

  final List<String> _popularSearches = const [
    'Acai',
    'Berry',
    'Sticky Rice',
    'Bolu Pisang',
    'Cheesecake',
  ];

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _loadFavorites();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final history = await SearchHistoryService.getHistory();
    if (mounted) {
      setState(() => _history = history);
    }
  }

  Future<void> _loadFavorites() async {
    final ids = await FavoriteService.getFavoriteIds();
    if (mounted) {
      setState(() => _favoriteIds = ids.toSet());
    }
  }

  Future<void> _toggleFavorite(Recipe recipe) async {
    final newStatus = await FavoriteService.toggleFavorite(recipe.id);
    if (mounted) {
      setState(() {
        if (newStatus) {
          _favoriteIds.add(recipe.id);
        } else {
          _favoriteIds.remove(recipe.id);
        }
      });

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

  void _onSearchChanged() {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _results = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    final filtered = dummyRecipes.where((recipe) {
      final title = recipe.title.toLowerCase();
      final category = recipe.fruitCategory.toLowerCase();
      final searchLower = query.toLowerCase();
      return title.contains(searchLower) || category.contains(searchLower);
    }).toList();

    setState(() => _results = filtered);
  }

  void _performSearch(String query) {
    _searchController.text = query;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: query.length),
    );
    SearchHistoryService.addToHistory(query);
    _loadHistory();
  }

  Future<void> _clearHistory() async {
    await SearchHistoryService.clearHistory();
    _loadHistory();
  }

  Future<void> _removeHistory(String query) async {
    await SearchHistoryService.removeFromHistory(query);
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final searchBg = isDark ? AppColors.darkSurface : Colors.grey[100]!;
    final chipBg = isDark ? AppColors.darkSurface : Colors.grey[100]!;
    final chipBorder = isDark ? AppColors.darkBorder : Colors.grey[300]!;

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    CookifyLogo(size: 45),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocus,
                  autofocus: false,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Cari resep, bahan, atau buah...',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.primary,
                    ),
                    suffixIcon: query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: searchBg,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      SearchHistoryService.addToHistory(value.trim());
                      _loadHistory();
                    }
                  },
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: query.isEmpty
                      ? _buildIdleState(
                          textPrimary, textSecondary, chipBg, chipBorder)
                      : _isSearching && _results.isEmpty
                          ? _buildEmptyState(query, textSecondary)
                          : _buildResults(textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIdleState(
    Color textPrimary,
    Color textSecondary,
    Color chipBg,
    Color chipBorder,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🔥 Pencarian Populer',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _popularSearches.map((term) {
              return GestureDetector(
                onTap: () => _performSearch(term),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    term,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          if (_history.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '🕐 Riwayat Pencarian',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: _clearHistory,
                  child: const Text(
                    'Hapus Semua',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._history.map((term) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.history,
                  size: 20,
                  color: textSecondary,
                ),
                title: Text(
                  term,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: textPrimary,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => _removeHistory(term),
                ),
                onTap: () => _performSearch(term),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildResults(Color textSecondary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${_results.length} hasil untuk "${_searchController.text}"',
            style: TextStyle(
              fontSize: 13,
              color: textSecondary,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 190,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _results.length,
            itemBuilder: (context, i) {
              final recipe = _results[i];
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
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String query, Color textSecondary) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Tidak ada hasil untuk "$query"',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: textSecondary,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba kata kunci lain',
            style: TextStyle(
              fontSize: 13,
              color: textSecondary,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
