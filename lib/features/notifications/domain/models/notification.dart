import 'package:equatable/equatable.dart';

enum NotificationType {
  portfolioValueChanged,
  propertyValueChanged,
  rentalAppraisalIncreased,
  comparablePropertySold,
  loanMilestoneReached,
  ownershipAnniversary,
  stateValueChanged,
}

enum NotificationCategory {
  portfolio,
  state,
  property,
}

class Notification extends Equatable {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final NotificationCategory category;
  final String? relatedPortfolioId;
  final String? relatedStateId;
  final String? relatedPropertyId;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;

  const Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.category,
    this.relatedPortfolioId,
    this.relatedStateId,
    this.relatedPropertyId,
    required this.isRead,
    required this.createdAt,
    this.readAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        message,
        type,
        category,
        relatedPortfolioId,
        relatedStateId,
        relatedPropertyId,
        isRead,
        createdAt,
        readAt,
      ];

  Notification copyWith({
    bool? isRead,
    DateTime? readAt,
  }) {
    return Notification(
      id: id,
      title: title,
      message: message,
      type: type,
      category: category,
      relatedPortfolioId: relatedPortfolioId,
      relatedStateId: relatedStateId,
      relatedPropertyId: relatedPropertyId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      readAt: readAt ?? this.readAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'type': type.toString(),
        'category': category.toString(),
        'relatedPortfolioId': relatedPortfolioId,
        'relatedStateId': relatedStateId,
        'relatedPropertyId': relatedPropertyId,
        'isRead': isRead,
        'createdAt': createdAt.toIso8601String(),
        'readAt': readAt?.toIso8601String(),
      };

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => NotificationType.portfolioValueChanged,
      ),
      category: NotificationCategory.values.firstWhere(
        (e) => e.toString() == json['category'],
        orElse: () => NotificationCategory.portfolio,
      ),
      relatedPortfolioId: json['relatedPortfolioId'] as String?,
      relatedStateId: json['relatedStateId'] as String?,
      relatedPropertyId: json['relatedPropertyId'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt'] as String) : null,
    );
  }
}
