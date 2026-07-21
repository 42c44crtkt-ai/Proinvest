import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../dashboard/presentation/providers/portfolio_provider.dart';
import '../../../../core/theme/app_theme.dart';

class PropertyDetailScreen extends ConsumerWidget {
  final String propertyId;

  const PropertyDetailScreen({Key? key, required this.propertyId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final property = ref.watch(propertyProvider(propertyId));

    if (property == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Property Details')),
        body: const Center(child: Text('Property not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(property.address),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: AppTheme.backgroundWhite,
              padding: const EdgeInsets.all(AppTheme.spacing24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.address,
                    style: AppTheme.headingLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${property.suburb} ${property.state} ${property.postcode}',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildMetricRow('Estimated Value', _formatCurrency(property.estimatedValue)),
                  const SizedBox(height: 16),
                  _buildMetricRow('Equity', _formatCurrency(property.equity)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: '💰 Financial Summary',
              metrics: [
                ('Weekly Rent', _formatCurrency(property.currentWeeklyRent)),
                ('Rental Appraisal', _formatCurrency(property.currentRentalAppraisal)),
                ('Loan Balance', _formatCurrency(property.loanBalance)),
                ('Loan-to-Value', '${property.loanToValueRatio.toStringAsFixed(1)}%'),
                ('Interest Rate', '${property.interestRate.toStringAsFixed(2)}%'),
                ('Weekly Repayment', _formatCurrency(property.weeklyLoanRepayment)),
                ('Gross Yield', '${property.grossYield.toStringAsFixed(2)}%'),
                ('Net Yield', '${property.netYield.toStringAsFixed(2)}%'),
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: '📈 Growth',
              metrics: [
                ('Purchased', _formatCurrency(property.purchasePrice)),
                ('Current Value', _formatCurrency(property.estimatedValue)),
                ('Capital Gain', '+\$${property.capitalGrowthAmount.toStringAsFixed(0)}'),
                ('Growth %', '+${property.capitalGrowthPercentage.toStringAsFixed(2)}%'),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTheme.headingSmall,
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<(String, String)> metrics,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.labelLarge,
          ),
          const SizedBox(height: 16),
          ...metrics.map((metric) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    metric.$1,
                    style: AppTheme.bodySmall,
                  ),
                  Text(
                    metric.$2,
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(1)}K';
    }
    return '\$${value.toStringAsFixed(0)}';
  }
}
