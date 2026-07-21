import 'package:flutter/material.dart';
import '../../domain/models/state_model.dart';

class StateCard extends StatelessWidget {
  final AustralianStatePortfolio state;
  final bool isActive;
  final bool isDragging;

  const StateCard({
    Key? key,
    required this.state,
    required this.isActive,
    required this.isDragging,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
      child: Container(
        height: 320,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _getGradientColors(state.stateAbbreviation),
          ),
        ),
        child: Stack(
          children: [
            // Background pattern/image placeholder
            Positioned.fill(
              child: Opacity(
                opacity: 0.15,
                child: Image.asset(
                  state.backgroundImagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.transparent,
                    );
                  },
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: State name and notification badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.stateName.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${state.propertyCount} properties',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (state.unreadNotificationCount > 0)
                        _buildNotificationBadge(state.unreadNotificationCount),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Total value
                  _buildMetricSection(
                    label: 'Total Value',
                    value: _formatCurrency(state.totalValue),
                  ),
                  const SizedBox(height: 16),
                  // Equity and rent
                  Row(
                    children: [
                      Expanded(
                        child: _buildCompactMetric(
                          label: 'Equity',
                          value: _formatCurrency(state.totalEquity),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildCompactMetric(
                          label: 'Weekly Rent',
                          value: _formatCurrency(state.weeklyRent),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Growth indicator
                  Row(
                    children: [
                      Icon(
                        state.monthlyGrowthPercentage >= 0
                            ? Icons.trending_up
                            : Icons.trending_down,
                        color: Colors.white.withOpacity(0.9),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${state.monthlyGrowthPercentage >= 0 ? '+' : ''}\$${state.monthlyGrowthAmount.toStringAsFixed(0)} (${state.monthlyGrowthPercentage.toStringAsFixed(2)}%) this month',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Tap hint for inactive cards
                  if (!isActive)
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Tap to view',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.6),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  if (isActive)
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Tap for details • Swipe for next',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.6),
                          fontStyle: FontStyle.italic,
                        ),
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

  Widget _buildNotificationBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        count.toString(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0088CC),
        ),
      ),
    );
  }

  Widget _buildMetricSection({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactMetric({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  List<Color> _getGradientColors(String stateAbbr) {
    switch (stateAbbr) {
      case 'NSW':
        return [const Color(0xFF2C5282), const Color(0xFF1a365d)];
      case 'VIC':
        return [const Color(0xFF2D3748), const Color(0xFF1a202c)];
      case 'QLD':
        return [const Color(0xFFB7791F), const Color(0xFF78350f)];
      case 'SA':
        return [const Color(0xFF6B21A8), const Color(0xFF3f0f5c)];
      case 'WA':
        return [const Color(0xFF0369A1), const Color(0xFF0c4a6e)];
      case 'TAS':
        return [const Color(0xFF166534), const Color(0xFF15803d)];
      case 'NT':
        return [const Color(0xFFDC2626), const Color(0xFF7F1D1D)];
      case 'ACT':
        return [const Color(0xFF1E40AF), const Color(0xFF1e3a8a)];
      default:
        return [const Color(0xFF4B5563), const Color(0xFF2D3748)];
    }
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(0)}K';
    }
    return '\$${value.toStringAsFixed(0)}';
  }
}
