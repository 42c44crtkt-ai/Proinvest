import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notification_provider.dart';
import '../../../../core/theme/app_theme.dart';

class NotificationCentreScreen extends ConsumerWidget {
  const NotificationCentreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(notificationsProvider.notifier);
    final sortedNotifications = ref.watch(sortedNotificationsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Notifications'),
        elevation: 0,
        actions: [
          if (sortedNotifications.any((n) => !n.isRead))
            TextButton(
              onPressed: () => notifier.markAllAsRead(),
              child: Text(
                'Mark All Read',
                style: AppTheme.labelMedium.copyWith(
                  color: AppTheme.primary,
                ),
              ),
            ),
        ],
      ),
      body: sortedNotifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off,
                    size: 64,
                    color: AppTheme.textTertiary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              itemCount: sortedNotifications.length,
              itemBuilder: (context, index) {
                final notification = sortedNotifications[index];
                return GestureDetector(
                  onTap: () {
                    if (!notification.isRead) {
                      notifier.markAsRead(notification.id);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
                    padding: const EdgeInsets.all(AppTheme.spacing16),
                    decoration: BoxDecoration(
                      color: notification.isRead
                          ? AppTheme.backgroundWhite
                          : AppTheme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                      border: notification.isRead
                          ? null
                          : Border.all(
                              color: AppTheme.primary.withOpacity(0.2),
                            ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            color: notification.isRead
                                ? AppTheme.textTertiary
                                : AppTheme.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification.title,
                                style: AppTheme.bodyLarge.copyWith(
                                  fontWeight: notification.isRead
                                      ? FontWeight.w500
                                      : FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                notification.message,
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _formatDate(notification.createdAt),
                                style: AppTheme.labelSmall.copyWith(
                                  color: AppTheme.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day} ${_monthName(dateTime.month)}';
    }
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
