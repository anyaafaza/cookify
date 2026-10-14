import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/notification_service.dart';
import '../../features/favorite/presentation/pages/favorite_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/recipe/presentation/pages/recipe_list_page.dart';
import '../../features/search/presentation/pages/search_page.dart';

final GlobalKey<MainNavigationState> mainNavKey =
    GlobalKey<MainNavigationState>();

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => MainNavigationState();
}

class MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  int _unreadNotifications = 0;

  final GlobalKey<FavoritePageState> _favoriteKey =
      GlobalKey<FavoritePageState>();

  late final List<Widget> _pages = [
    const HomePage(),
    const RecipeListPage(),
    const SearchPage(),
    FavoritePage(key: _favoriteKey),
    const ProfilePage(),
  ];

  // TAMBAH
  @override
  void initState() {
    super.initState();
    _loadUnreadCount();
  }

  // TAMBAH
  Future<void> _loadUnreadCount() async {
    final email = await AuthService.getUserEmail();
    final count = await NotificationService.getUnreadCount(email);
    if (mounted) {
      setState(() => _unreadNotifications = count);
    }
  }

  void goToTab(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() => _currentIndex = index);
      _refreshIfNeeded(index);
    }
  }

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
    _refreshIfNeeded(index);
  }

  // UPDATE
  void _refreshIfNeeded(int index) {
    if (index == 3) {
      _favoriteKey.currentState?.refresh();
    }
    if (index == 4) {
      _loadUnreadCount();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
          ),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book),
              label: 'Resep',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Cari',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'Favorit',
            ),

            // Item Profil dengan Badge
            BottomNavigationBarItem(
              icon: _unreadNotifications > 0
                  ? Stack(
                      children: [
                        const Icon(Icons.person_outline),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              _unreadNotifications > 9
                                  ? '9+'
                                  : '$_unreadNotifications',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
