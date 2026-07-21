import 'package:equatable/equatable.dart';
import 'investment_property.dart';

class AustralianStatePortfolio extends Equatable {
  final String id;
  final String stateName;
  final String stateAbbreviation;
  final int propertyCount;
  final double totalValue;
  final double totalEquity;
  final double weeklyRent;
  final double monthlyGrowthAmount;
  final double monthlyGrowthPercentage;
  final String backgroundImagePath;
  final List<InvestmentProperty> properties;
  final int unreadNotificationCount;

  const AustralianStatePortfolio({
    required this.id,
    required this.stateName,
    required this.stateAbbreviation,
    required this.propertyCount,
    required this.totalValue,
    required this.totalEquity,
    required this.weeklyRent,
    required this.monthlyGrowthAmount,
    required this.monthlyGrowthPercentage,
    required this.backgroundImagePath,
    required this.properties,
    required this.unreadNotificationCount,
  });

  @override
  List<Object?> get props => [
        id,
        stateName,
        stateAbbreviation,
        propertyCount,
        totalValue,
        totalEquity,
        weeklyRent,
        monthlyGrowthAmount,
        monthlyGrowthPercentage,
        backgroundImagePath,
        properties,
        unreadNotificationCount,
      ];

  Map<String, dynamic> toJson() => {
        'id': id,
        'stateName': stateName,
        'stateAbbreviation': stateAbbreviation,
        'propertyCount': propertyCount,
        'totalValue': totalValue,
        'totalEquity': totalEquity,
        'weeklyRent': weeklyRent,
        'monthlyGrowthAmount': monthlyGrowthAmount,
        'monthlyGrowthPercentage': monthlyGrowthPercentage,
        'backgroundImagePath': backgroundImagePath,
        'properties': properties.map((p) => p.toJson()).toList(),
        'unreadNotificationCount': unreadNotificationCount,
      };

  factory AustralianStatePortfolio.fromJson(Map<String, dynamic> json) {
    return AustralianStatePortfolio(
      id: json['id'] as String,
      stateName: json['stateName'] as String,
      stateAbbreviation: json['stateAbbreviation'] as String,
      propertyCount: json['propertyCount'] as int,
      totalValue: (json['totalValue'] as num).toDouble(),
      totalEquity: (json['totalEquity'] as num).toDouble(),
      weeklyRent: (json['weeklyRent'] as num).toDouble(),
      monthlyGrowthAmount: (json['monthlyGrowthAmount'] as num).toDouble(),
      monthlyGrowthPercentage: (json['monthlyGrowthPercentage'] as num).toDouble(),
      backgroundImagePath: json['backgroundImagePath'] as String,
      properties: (json['properties'] as List<dynamic>)
          .map((p) => InvestmentProperty.fromJson(p as Map<String, dynamic>))
          .toList(),
      unreadNotificationCount: json['unreadNotificationCount'] as int,
    );
  }
}
