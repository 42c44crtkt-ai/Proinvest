import 'package:riverpod/riverpod.dart';
import '../models/investor_portfolio.dart';
import '../models/state_model.dart';
import '../../properties/domain/models/investment_property.dart';
import '../../dashboard/domain/models/portfolio_value_point.dart';

// Mock portfolio data
final _mockProperties = {
  'prop-001': InvestmentProperty(
    id: 'prop-001',
    address: '42 Macquarie Street',
    suburb: 'Sydney',
    state: 'NSW',
    postcode: '2000',
    imagePath: 'assets/images/property_1.jpg',
    purchasePrice: 550000,
    purchaseDate: DateTime(2020, 7, 21),
    estimatedValue: 650000,
    loanBalance: 400000,
    interestRate: 4.25,
    weeklyLoanRepayment: 325,
    currentWeeklyRent: 450,
    currentRentalAppraisal: 670,
    grossYield: 3.42,
    netYield: 1.95,
    capitalGrowthAmount: 100000,
    capitalGrowthPercentage: 18.18,
    equity: 250000,
    loanToValueRatio: 61.54,
    unreadNotificationCount: 1,
  ),
  'prop-002': InvestmentProperty(
    id: 'prop-002',
    address: 'Suite 5, 100 York Street',
    suburb: 'Sydney',
    state: 'NSW',
    postcode: '2000',
    imagePath: 'assets/images/property_2.jpg',
    purchasePrice: 520000,
    purchaseDate: DateTime(2021, 3, 15),
    estimatedValue: 550000,
    loanBalance: 350000,
    interestRate: 4.35,
    weeklyLoanRepayment: 290,
    currentWeeklyRent: 270,
    currentRentalAppraisal: 320,
    grossYield: 2.53,
    netYield: 0.95,
    capitalGrowthAmount: 30000,
    capitalGrowthPercentage: 5.77,
    equity: 200000,
    loanToValueRatio: 63.64,
    unreadNotificationCount: 0,
  ),
  'prop-003': InvestmentProperty(
    id: 'prop-003',
    address: '1205 Dandenong Road',
    suburb: 'Chadstone',
    state: 'VIC',
    postcode: '3148',
    imagePath: 'assets/images/property_3.jpg',
    purchasePrice: 680000,
    purchaseDate: DateTime(2019, 11, 8),
    estimatedValue: 750000,
    loanBalance: 420000,
    interestRate: 4.15,
    weeklyLoanRepayment: 355,
    currentWeeklyRent: 380,
    currentRentalAppraisal: 410,
    grossYield: 2.88,
    netYield: 1.25,
    capitalGrowthAmount: 70000,
    capitalGrowthPercentage: 10.29,
    equity: 330000,
    loanToValueRatio: 56.0,
    unreadNotificationCount: 0,
  ),
  'prop-004': InvestmentProperty(
    id: 'prop-004',
    address: '50 Market Street',
    suburb: 'Brisbane',
    state: 'QLD',
    postcode: '4000',
    imagePath: 'assets/images/property_4.jpg',
    purchasePrice: 450000,
    purchaseDate: DateTime(2022, 2, 20),
    estimatedValue: 500000,
    loanBalance: 380000,
    interestRate: 4.45,
    weeklyLoanRepayment: 310,
    currentWeeklyRent: 320,
    currentRentalAppraisal: 380,
    grossYield: 3.33,
    netYield: 1.68,
    capitalGrowthAmount: 50000,
    capitalGrowthPercentage: 11.11,
    equity: 120000,
    loanToValueRatio: 76.0,
    unreadNotificationCount: 1,
  ),
};

final _mockValueHistory = [
  PortfolioValuePoint(date: DateTime(2026, 6, 21), value: 2432000),
  PortfolioValuePoint(date: DateTime(2026, 6, 28), value: 2440000),
  PortfolioValuePoint(date: DateTime(2026, 7, 5), value: 2425000),
  PortfolioValuePoint(date: DateTime(2026, 7, 12), value: 2442000),
  PortfolioValuePoint(date: DateTime(2026, 7, 19), value: 2450000),
  PortfolioValuePoint(date: DateTime(2026, 7, 21), value: 2450000),
];

final _mockStates = {
  'nsw-001': AustralianStatePortfolio(
    id: 'nsw-001',
    stateName: 'New South Wales',
    stateAbbreviation: 'NSW',
    propertyCount: 2,
    totalValue: 1200000,
    totalEquity: 450000,
    weeklyRent: 720,
    monthlyGrowthAmount: 8500,
    monthlyGrowthPercentage: 0.71,
    backgroundImagePath: 'assets/images/sydney_skyline.jpg',
    properties: [_mockProperties['prop-001']!, _mockProperties['prop-002']!],
    unreadNotificationCount: 1,
  ),
  'vic-001': AustralianStatePortfolio(
    id: 'vic-001',
    stateName: 'Victoria',
    stateAbbreviation: 'VIC',
    propertyCount: 1,
    totalValue: 750000,
    totalEquity: 330000,
    weeklyRent: 380,
    monthlyGrowthAmount: 5200,
    monthlyGrowthPercentage: 0.70,
    backgroundImagePath: 'assets/images/melbourne_skyline.jpg',
    properties: [_mockProperties['prop-003']!],
    unreadNotificationCount: 0,
  ),
  'qld-001': AustralianStatePortfolio(
    id: 'qld-001',
    stateName: 'Queensland',
    stateAbbreviation: 'QLD',
    propertyCount: 1,
    totalValue: 500000,
    totalEquity: 120000,
    weeklyRent: 320,
    monthlyGrowthAmount: 4300,
    monthlyGrowthPercentage: 0.87,
    backgroundImagePath: 'assets/images/brisbane_skyline.jpg',
    properties: [_mockProperties['prop-004']!],
    unreadNotificationCount: 1,
  ),
};

final _mockPortfolio = InvestorPortfolio(
  id: 'portfolio-001',
  investorName: 'David Chen',
  totalPortfolioValue: 2450000,
  totalEquity: 900000,
  totalWeeklyRent: 1420,
  monthlyGrowthAmount: 18000,
  monthlyGrowthPercentage: 0.73,
  totalProperties: 4,
  valueHistory: _mockValueHistory,
  totalUnreadNotifications: 2,
);

/// Provider for complete investor portfolio
final investorPortfolioProvider = Provider<InvestorPortfolio>((ref) {
  return _mockPortfolio;
});

/// Provider for all state portfolios
final statePortfoliosProvider = Provider<List<AustralianStatePortfolio>>((ref) {
  return _mockStates.values.toList();
});

/// Provider for a single state portfolio
final statePortfolioProvider = Provider.family<AustralianStatePortfolio?, String>((ref, stateId) {
  return _mockStates[stateId];
});

/// Provider for all properties
final allPropertiesProvider = Provider<List<InvestmentProperty>>((ref) {
  return _mockProperties.values.toList();
});

/// Provider for a single property
final propertyProvider = Provider.family<InvestmentProperty?, String>((ref, propertyId) {
  return _mockProperties[propertyId];
});

/// Provider for properties in a specific state
final statePropertiesProvider = Provider.family<List<InvestmentProperty>, String>((ref, stateId) {
  final state = ref.watch(statePortfolioProvider(stateId));
  return state?.properties ?? [];
});
