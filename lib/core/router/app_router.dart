import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/states/presentation/screens/state_portfolio_screen.dart';
import '../features/properties/presentation/screens/property_detail_screen.dart';
import '../features/notifications/presentation/screens/notification_centre_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
      routes: [
        GoRoute(
          path: 'state/:stateId',
          name: 'statePortfolio',
          builder: (context, state) {
            final stateId = state.pathParameters['stateId']!;
            return StatePortfolioScreen(stateId: stateId);
          },
          routes: [
            GoRoute(
              path: 'property/:propertyId',
              name: 'propertyDetail',
              builder: (context, state) {
                final propertyId = state.pathParameters['propertyId']!;
                return PropertyDetailScreen(propertyId: propertyId);
              },
            ),
          ],
        ),
        GoRoute(
          path: 'notifications',
          name: 'notifications',
          builder: (context, state) => const NotificationCentreScreen(),
        ),
      ],
    ),
  ],
);
