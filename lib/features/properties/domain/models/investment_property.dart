import 'package:equatable/equatable.dart';
import 'portfolio_value_point.dart';

class InvestmentProperty extends Equatable {
  final String id;
  final String address;
  final String suburb;
  final String state;
  final String postcode;
  final String imagePath;
  final double purchasePrice;
  final DateTime purchaseDate;
  final double estimatedValue;
  final double loanBalance;
  final double interestRate;
  final double weeklyLoanRepayment;
  final double currentWeeklyRent;
  final double currentRentalAppraisal;
  final double grossYield;
  final double netYield;
  final double capitalGrowthAmount;
  final double capitalGrowthPercentage;
  final double equity;
  final double loanToValueRatio;
  final int unreadNotificationCount;

  const InvestmentProperty({
    required this.id,
    required this.address,
    required this.suburb,
    required this.state,
    required this.postcode,
    required this.imagePath,
    required this.purchasePrice,
    required this.purchaseDate,
    required this.estimatedValue,
    required this.loanBalance,
    required this.interestRate,
    required this.weeklyLoanRepayment,
    required this.currentWeeklyRent,
    required this.currentRentalAppraisal,
    required this.grossYield,
    required this.netYield,
    required this.capitalGrowthAmount,
    required this.capitalGrowthPercentage,
    required this.equity,
    required this.loanToValueRatio,
    required this.unreadNotificationCount,
  });

  @override
  List<Object?> get props => [
        id,
        address,
        suburb,
        state,
        postcode,
        imagePath,
        purchasePrice,
        purchaseDate,
        estimatedValue,
        loanBalance,
        interestRate,
        weeklyLoanRepayment,
        currentWeeklyRent,
        currentRentalAppraisal,
        grossYield,
        netYield,
        capitalGrowthAmount,
        capitalGrowthPercentage,
        equity,
        loanToValueRatio,
        unreadNotificationCount,
      ];

  Map<String, dynamic> toJson() => {
        'id': id,
        'address': address,
        'suburb': suburb,
        'state': state,
        'postcode': postcode,
        'imagePath': imagePath,
        'purchasePrice': purchasePrice,
        'purchaseDate': purchaseDate.toIso8601String(),
        'estimatedValue': estimatedValue,
        'loanBalance': loanBalance,
        'interestRate': interestRate,
        'weeklyLoanRepayment': weeklyLoanRepayment,
        'currentWeeklyRent': currentWeeklyRent,
        'currentRentalAppraisal': currentRentalAppraisal,
        'grossYield': grossYield,
        'netYield': netYield,
        'capitalGrowthAmount': capitalGrowthAmount,
        'capitalGrowthPercentage': capitalGrowthPercentage,
        'equity': equity,
        'loanToValueRatio': loanToValueRatio,
        'unreadNotificationCount': unreadNotificationCount,
      };

  factory InvestmentProperty.fromJson(Map<String, dynamic> json) {
    return InvestmentProperty(
      id: json['id'] as String,
      address: json['address'] as String,
      suburb: json['suburb'] as String,
      state: json['state'] as String,
      postcode: json['postcode'] as String,
      imagePath: json['imagePath'] as String,
      purchasePrice: (json['purchasePrice'] as num).toDouble(),
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      estimatedValue: (json['estimatedValue'] as num).toDouble(),
      loanBalance: (json['loanBalance'] as num).toDouble(),
      interestRate: (json['interestRate'] as num).toDouble(),
      weeklyLoanRepayment: (json['weeklyLoanRepayment'] as num).toDouble(),
      currentWeeklyRent: (json['currentWeeklyRent'] as num).toDouble(),
      currentRentalAppraisal: (json['currentRentalAppraisal'] as num).toDouble(),
      grossYield: (json['grossYield'] as num).toDouble(),
      netYield: (json['netYield'] as num).toDouble(),
      capitalGrowthAmount: (json['capitalGrowthAmount'] as num).toDouble(),
      capitalGrowthPercentage: (json['capitalGrowthPercentage'] as num).toDouble(),
      equity: (json['equity'] as num).toDouble(),
      loanToValueRatio: (json['loanToValueRatio'] as num).toDouble(),
      unreadNotificationCount: json['unreadNotificationCount'] as int,
    );
  }
}
