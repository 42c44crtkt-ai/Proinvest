import 'package:equatable/equatable.dart';

class PortfolioValuePoint extends Equatable {
  final DateTime date;
  final double value;

  const PortfolioValuePoint({
    required this.date,
    required this.value,
  });

  @override
  List<Object?> get props => [date, value];

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'value': value,
      };

  factory PortfolioValuePoint.fromJson(Map<String, dynamic> json) {
    return PortfolioValuePoint(
      date: DateTime.parse(json['date'] as String),
      value: (json['value'] as num).toDouble(),
    );
  }
}
