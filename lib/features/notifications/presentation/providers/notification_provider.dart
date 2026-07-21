import 'package:riverpod/riverpod.dart';
import '../models/notification.dart';

// Mock notification data
final _mockNotifications = [
  Notification(
    id: '1',
    title: 'Queensland portfolio value increased',
    message: 'Your Queensland portfolio value increased by \$18,000',
    type: NotificationType.portfolioValueChanged,
    category: NotificationCategory.state,
    relatedStateId: 'qld-001',
    isRead: false,
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  Notification(
    id: '2',
    title: 'A nearby property sold',
    message: 'A comparable property sold for \$865,000 near your investment',
    type: NotificationType.comparablePropertySold,
    category: NotificationCategory.portfolio,
    relatedPropertyId: 'prop-001',
    isRead: false,
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
  Notification(
    id: '3',
    title: 'Rental appraisal increased',
    message: 'Rental appraisal increased to \$670 per week',
    type: NotificationType.rentalAppraisalIncreased,
    category: NotificationCategory.property,
    relatedPropertyId: 'prop-002',
    isRead: false,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Notification(
    id: '4',
    title: 'Loan-to-value ratio milestone',
    message: 'Your loan-to-value ratio dropped below 70%',
    type: NotificationType.loanMilestoneReached,
    category: NotificationCategory.property,
    relatedPropertyId: 'prop-003',
    isRead: true,
    createdAt: DateTime.now().subtract(const Duration(weeks: 1)),
    readAt: DateTime.now().subtract(const Duration(weeks: 1)),
  ),
  Notification(
    id: '5',
    title: 'Equity milestone reached',
    message: 'You have reached \$500,000 equity in Queensland',
    type: NotificationType.loanMilestoneReached,
    category: NotificationCategory.state,
    relatedStateId: 'qld-001',
    isRead: true,
    createdAt: DateTime.now().subtract(const Duration(weeks: 2)),
    readAt: DateTime.now().subtract(const Duration(weeks: 2)),
  ),
];

/// State management for notifications using Riverpod
class NotificationNotifier extends StateNotifier<List<Notification>> {
  NotificationNotifier() : super(_mockNotifications);

  void markAsRead(String notificationId) {
    state = state.map((notification) {
      if (notification.id == notificationId) {
        return notification.copyWith(
          isRead: true,
          readAt: DateTime.now(),
        );
      }
      return notification;
    }).toList();
  }

  void markMultipleAsRead(List<String> notificationIds) {
    final now = DateTime.now();
    state = state.map((notification) {
      if (notificationIds.contains(notification.id)) {
        return notification.copyWith(
          isRead: true,
          readAt: now,
        );
      }
      return notification;
    }).toList();
  }

  void markAllAsRead() {
    final now = DateTime.now();
    state = state.map((notification) {
      return notification.copyWith(
        isRead: true,
        readAt: now,
      );
    }).toList();
  }

  int getUnreadCount() {
    return state.where((n) => !n.isRead).length;
  }

  int getUnreadCountForState(String stateId) {
    return state.where((n) => !n.isRead && n.relatedStateId == stateId).length;
  }

  int getUnreadCountForProperty(String propertyId) {
    return state.where((n) => !n.isRead && n.relatedPropertyId == propertyId).length;
  }

  List<Notification> getNotificationsForState(String stateId) {
    return state.where((n) => n.relatedStateId == stateId).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<Notification> getNotificationsForProperty(String propertyId) {
    return state.where((n) => n.relatedPropertyId == propertyId).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<Notification> getAllNotificationsSorted() {
    final sorted = [...state];
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }
}

/// Provider for all notifications
final notificationsProvider = StateNotifierProvider<NotificationNotifier, List<Notification>>(
  (ref) => NotificationNotifier(),
);

/// Provider for unread notification count
final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsProvider);
  return notifications.where((n) => !n.isRead).length;
});

/// Provider for unread count for a specific state
final unreadStateNotificationCountProvider = Provider.family<int, String>((ref, stateId) {
  final notifier = ref.watch(notificationsProvider.notifier);
  return notifier.getUnreadCountForState(stateId);
});

/// Provider for unread count for a specific property
final unreadPropertyNotificationCountProvider = Provider.family<int, String>((ref, propertyId) {
  final notifier = ref.watch(notificationsProvider.notifier);
  return notifier.getUnreadCountForProperty(propertyId);
});

/// Provider for sorted notifications
final sortedNotificationsProvider = Provider<List<Notification>>((ref) {
  final notifier = ref.watch(notificationsProvider.notifier);
  return notifier.getAllNotificationsSorted();
});

/// Provider for notifications for a specific state
final stateNotificationsProvider = Provider.family<List<Notification>, String>((ref, stateId) {
  final notifier = ref.watch(notificationsProvider.notifier);
  return notifier.getNotificationsForState(stateId);
});

/// Provider for notifications for a specific property
final propertyNotificationsProvider = Provider.family<List<Notification>, String>((ref, propertyId) {
  final notifier = ref.watch(notificationsProvider.notifier);
  return notifier.getNotificationsForProperty(propertyId);
});
