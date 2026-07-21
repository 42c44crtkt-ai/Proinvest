import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../dashboard/presentation/providers/portfolio_provider.dart';
import '../../../../core/theme/app_theme.dart';

class StatePortfolioScreen extends ConsumerWidget {
  final String stateId;

  const StatePortfolioScreen({Key? key, required this.stateId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(statePortfolioProvider(stateId));

    if (state == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('State Portfolio')),
        body: const Center(child: Text('State not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text('${state.stateName} Portfolio'),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        state.stateName.toUpperCase(),
                        style: AppTheme.headingLarge,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppTheme.radiusRound),
                        ),
                        child: Text(
                          '${state.propertyCount} properties',
                          style: AppTheme.labelSmall.copyWith(
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildMetric('Total Value', _formatCurrency(state.totalValue)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSmallMetric('Equity', _formatCurrency(state.totalEquity)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSmallMetric('Weekly Rent', _formatCurrency(state.weeklyRent)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.trending_up,
                        color: AppTheme.successGreen,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '+\$${state.monthlyGrowthAmount.toStringAsFixed(0)} (${state.monthlyGrowthPercentage.toStringAsFixed(2)}%)',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.successGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Properties',
                  style: AppTheme.headingMedium,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
              itemCount: state.properties.length,
              itemBuilder: (context, index) {
                final property = state.properties[index];
                return GestureDetector(
                  onTap: () => context.pushNamed(
                    'propertyDetail',
                    pathParameters: {'propertyId': property.id},
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: AppTheme.spacing16),
                    padding: const EdgeInsets.all(AppTheme.spacing16),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundWhite,
                      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    property.address,
                                    style: AppTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${property.suburb} ${property.postcode}',
                                    style: AppTheme.bodySmall.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (property.unreadNotificationCount > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.errorRed,
                                  borderRadius: BorderRadius.circular(AppTheme.radiusRound),
                                ),
                                child: Text(
                                  property.unreadNotificationCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSmallMetric(
                                'Value',
                                _formatCurrency(property.estimatedValue),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildSmallMetric(
                                'Equity',
                                _formatCurrency(property.equity),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSmallMetric(
                                'Weekly Rent',
                                _formatCurrency(property.currentWeeklyRent),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildSmallMetric(
                                'Growth',
                                '+${property.capitalGrowthPercentage.toStringAsFixed(1)}%',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppTheme.displayMedium,
        ),
      ],
    );
  }

  Widget _buildSmallMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.labelSmall,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTheme.bodyMedium,
        ),
      ],
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
