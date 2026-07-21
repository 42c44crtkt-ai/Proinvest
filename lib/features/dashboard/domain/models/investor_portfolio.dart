import 'package:equatable/equatable.dart';
import 'portfolio_value_point.dart';

class InvestorPortfolio extends Equatable {
  final String id;
  final String investorName;
  final double totalPortfolioValue;
  final double totalEquity;
  final double totalWeeklyRent;
  final double monthlyGrowthAmount;
  final double monthlyGrowthPercentage;
  final int totalProperties;
  final List<PortfolioValuePoint> valueHistory;
  final int totalUnreadNotifications;

  const InvestorPortfolio({
    required this.id,
    required this.investorName,
    required this.totalPortfolioValue,
    required this.totalEquity,
    required this.totalWeeklyRent,
    required this.monthlyGrowthAmount,
    required this.monthlyGrowthPercentage,
    required this.totalProperties,
    required this.valueHistory,
    required this.totalUnreadNotifications,
  });

  @override
  List<Object?> get props => [
        id,
        investorName,
        totalPortfolioValue,
        totalEquity,
        totalWeeklyRent,
        monthlyGrowthAmount,
        monthlyGrowthPercentage,
        totalProperties,
        valueHistory,
        totalUnreadNotifications,
      ];

  Map<String, dynamic> toJson() => {
        'id': id,
        'investorName': investorName,
        'totalPortfolioValue': totalPortfolioValue,
        'totalEquity': totalEquity,
        'totalWeeklyRent': totalWeeklyRent,
        'monthlyGrowthAmount': monthlyGrowthAmount,
        'monthlyGrowthPercentage': monthlyGrowthPercentage,
        'totalProperties': totalProperties,
        'valueHistory': valueHistory.map((p) => p.toJson()).toList(),
        'totalUnreadNotifications': totalUnreadNotifications,
      };

  factory InvestorPortfolio.fromJson(Map<String, dynamic> json) {
    return InvestorPortfolio(
      id: json['id'] as String,
      investorName: json['investorName'] as String,
      totalPortfolioValue: (json['totalPortfolioValue'] as num).toDouble(),
      totalEquity: (json['totalEquity'] as num).toDouble(),
      totalWeeklyRent: (json['totalWeeklyRent'] as num).toDouble(),
      monthlyGrowthAmount: (json['monthlyGrowthAmount'] as num).toDouble(),
      monthlyGrowthPercentage: (json['monthlyGrowthPercentage'] as num).toDouble(),
      totalProperties: json['totalProperties'] as int,
      valueHistory: (json['valueHistory'] as List<dynamic>)
          .map((p) => PortfolioValuePoint.fromJson(p as Map<String, dynamic>))
          .toList(),
      totalUnreadNotifications: json['totalUnreadNotifications'] as int,
    );
  }
}
