import 'dart:math';

/// Rent vs Buy calculator for long-term cost comparison
class RentBuyCalculator {
  /// Calculate comprehensive rent vs buy comparison
  static Map<String, dynamic> calculate({
    // Rent parameters
    required double monthlyRent,
    required double annualRentIncrease,
    required int horizonYears,
    // Buy parameters (from mortgage scenario)
    required double monthlyMortgagePayment,
    required double propertyPrice,
    required double deposit,
    required double stampDuty,
    required double loanAmount,
    required int mortgageTermYears,
    // Optional parameters
    double housePriceGrowth = 2.5,
    double investmentReturn = 5.0,
    double buyingCosts = 3000, // Legal fees, survey, etc.
  }) {
    // Calculate total rent costs over horizon
    final rentCosts = _calculateRentCosts(
      monthlyRent: monthlyRent,
      annualIncrease: annualRentIncrease,
      years: horizonYears,
    );

    // Calculate total buying costs over horizon
    final buyCosts = _calculateBuyCosts(
      monthlyPayment: monthlyMortgagePayment,
      stampDuty: stampDuty,
      buyingCosts: buyingCosts,
      horizonYears: horizonYears,
      mortgageTermYears: mortgageTermYears,
    );

    // Calculate opportunity cost of deposit
    final opportunityCost = _calculateOpportunityCost(
      deposit: deposit + stampDuty + buyingCosts,
      returnRate: investmentReturn,
      years: horizonYears,
    );

    // Calculate property value growth
    final futurePropertyValue =
        propertyPrice * pow(1 + housePriceGrowth / 100, horizonYears);
    final equityGained = futurePropertyValue - loanAmount;

    // Calculate net positions
    final rentNetCost = rentCosts['totalCost']! + opportunityCost;
    final buyNetCost = buyCosts['totalCost']! - equityGained;

    // Find break-even year
    int? breakEvenYear;
    for (int year = 1; year <= horizonYears; year++) {
      final rentAtYear = _calculateRentCosts(
        monthlyRent: monthlyRent,
        annualIncrease: annualRentIncrease,
        years: year,
      )['totalCost']!;

      final buyAtYear = _calculateBuyCosts(
        monthlyPayment: monthlyMortgagePayment,
        stampDuty: stampDuty,
        buyingCosts: buyingCosts,
        horizonYears: year,
        mortgageTermYears: mortgageTermYears,
      )['totalCost']!;

      if (buyAtYear < rentAtYear) {
        breakEvenYear = year;
        break;
      }
    }

    return {
      'totalRentCost': rentCosts['totalCost']!,
      'totalBuyCost': buyCosts['totalCost']!,
      'rentNetCost': rentNetCost,
      'buyNetCost': buyNetCost,
      'difference': rentNetCost - buyNetCost,
      'opportunityCost': opportunityCost,
      'equityGained': equityGained,
      'futurePropertyValue': futurePropertyValue,
      'breakEvenYear': breakEvenYear,
      'yearlyRentCosts': rentCosts['yearly']!,
      'yearlyBuyCosts': buyCosts['yearly']!,
    };
  }

  static Map<String, dynamic> _calculateRentCosts({
    required double monthlyRent,
    required double annualIncrease,
    required int years,
  }) {
    double totalCost = 0;
    List<double> yearlyCosts = [];
    double currentRent = monthlyRent;

    for (int year = 1; year <= years; year++) {
      final yearCost = currentRent * 12;
      totalCost += yearCost;
      yearlyCosts.add(yearCost);
      currentRent *= (1 + annualIncrease / 100);
    }

    return {'totalCost': totalCost, 'yearly': yearlyCosts};
  }

  static Map<String, dynamic> _calculateBuyCosts({
    required double monthlyPayment,
    required double stampDuty,
    required double buyingCosts,
    required int horizonYears,
    required int mortgageTermYears,
  }) {
    // Upfront costs
    final upfrontCosts = stampDuty + buyingCosts;

    // Mortgage payments over horizon
    final monthsInHorizon = min(horizonYears * 12, mortgageTermYears * 12);
    final totalMortgagePayments = monthlyPayment * monthsInHorizon;

    // Total cost
    final totalCost = upfrontCosts + totalMortgagePayments;

    // Yearly breakdown
    List<double> yearlyCosts = [];
    for (int year = 1; year <= horizonYears; year++) {
      if (year == 1) {
        yearlyCosts.add(upfrontCosts + (monthlyPayment * 12));
      } else {
        final monthsRemaining = max(
          0,
          mortgageTermYears * 12 - (year - 1) * 12,
        );
        final yearPayment = min(monthsRemaining, 12) * monthlyPayment;
        yearlyCosts.add(yearPayment);
      }
    }

    return {'totalCost': totalCost, 'yearly': yearlyCosts};
  }

  static double _calculateOpportunityCost({
    required double deposit,
    required double returnRate,
    required int years,
  }) {
    // Calculate what the deposit could have grown to if invested
    final futureValue = deposit * pow(1 + returnRate / 100, years);
    return futureValue - deposit; // Opportunity cost is the foregone gains
  }
}
