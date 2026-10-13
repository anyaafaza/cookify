import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/notification_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<AppNotification> _notifications = [];
  String _userEmail = '';
  bool _isLoading = true;
  bool _showUnreadOnly = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);

    final email = await AuthService.getUserEmail();
    final items = await NotificationService.getUserNotifications(email);
    await NotificationService.markAllAsRead(email);

    if (mounted) {
      setState(() {
        _userEmail = email;
        _notifications = items;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteNotification(AppNotification item) async {
    await NotificationService.deleteNotification(item.id);
    _loadNotifications();
  }

  Future<void> _clearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Hapus Semua Notifikasi?',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: const Text(
          'Semua notifikasi akan dihapus permanen.',
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
              'Hapus Semua',
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
      await NotificationService.clearUserNotifications(_userEmail);
      _loadNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final chipBg = isDark ? AppColors.darkSurface : Colors.grey[100]!;
    final chipBorder = isDark ? AppColors.darkBorder : Colors.grey[300]!;

    final filtered = _showUnreadOnly
        ? _notifications.where((n) => !n.isRead).toList()
        : _notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _clearAll,
              tooltip: 'Hapus semua',
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                FilterChip(
                  label: Text(
                    'Semua (${_notifications.length})',
                    style: TextStyle(
                      color: !_showUnreadOnly ? Colors.white : textPrimary,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  selected: !_showUnreadOnly,
                  onSelected: (_) {
                    setState(() => _showUnreadOnly = false);
                  },
                  backgroundColor: chipBg,
                  selectedColor: AppColors.primary,
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: !_showUnreadOnly ? chipBorder : AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(
                    'Belum Dibaca',
                    style: TextStyle(
                      color: _showUnreadOnly ? Colors.white : textPrimary,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  selected: _showUnreadOnly,
                  onSelected: (_) {
                    setState(() => _showUnreadOnly = true);
                  },
                  backgroundColor: chipBg,
                  selectedColor: AppColors.primary,
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: _showUnreadOnly ? AppColors.primary : chipBorder,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                    ? _buildEmptyState(textPrimary, textSecondary)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          return _buildNotificationCard(
                            filtered[i],
                            textPrimary,
                            textSecondary,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
    AppNotification item,
    Color textPrimary,
    Color textSecondary,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : Colors.grey[200]!;

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => _deleteNotification(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: item.isRead
                ? borderColor
                : AppColors.primary.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon tipe
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _getColorForType(item.type).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getIconForType(item.type),
                color: _getColorForType(item.type),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),

            // Konten
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                item.isRead ? FontWeight.w500 : FontWeight.w700,
                            fontFamily: 'Poppins',
                            color: textPrimary,
                          ),
                        ),
                      ),
                      if (!item.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: textSecondary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatDate(item.createdAt),
                    style: TextStyle(
                      fontSize: 11,
                      color: textSecondary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color textPrimary, Color textSecondary) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _showUnreadOnly
                ? 'Tidak ada notifikasi belum dibaca'
                : 'Belum ada notifikasi',
            style: TextStyle(
              fontSize: 15,
              color: textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Notifikasi akan muncul di sini',
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

  IconData _getIconForType(String type) {
    switch (type) {
      case 'review':
        return Icons.rate_review;
      case 'favorite':
        return Icons.favorite;
      case 'welcome':
        return Icons.celebration;
      default:
        return Icons.notifications;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'review':
        return AppColors.accent;
      case 'favorite':
        return AppColors.primary;
      case 'welcome':
        return AppColors.secondary;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inHours < 1) return '${diff.inMinutes} menit lalu';
    if (diff.inDays < 1) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} minggu lalu';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()} bulan lalu';
    return '${(diff.inDays / 365).floor()} tahun lalu';
  }
}
