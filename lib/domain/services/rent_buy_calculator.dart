import 'dart:math';

/// Rent vs Buy calculator for long-term cost comparison.
///
/// Net cost model (lower = better):
///   Rent net  = total rent paid  − investment gains on deposit+fees kept by renter
///   Buy  net  = total buy costs  − equity at horizon (property value − remaining balance)
///
/// Break-even = first year where buy net < rent net (using the same model each year).
class RentBuyCalculator {
  /// Calculate comprehensive rent vs buy comparison.
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
    required double interestRate, // annual %, e.g. 4.5
    // Assumption sliders
    double housePriceGrowth = 2.5,
    double investmentReturn = 5.0,
    double buyingCosts = 3000, // legal fees, survey, etc.
  }) {
    // ── Raw outflows ──────────────────────────────────────────────────────────
    final rentCosts = _calculateRentCosts(
      monthlyRent: monthlyRent,
      annualIncrease: annualRentIncrease,
      years: horizonYears,
    );

    final buyCosts = _calculateBuyCosts(
      monthlyPayment: monthlyMortgagePayment,
      stampDuty: stampDuty,
      buyingCosts: buyingCosts,
      horizonYears: horizonYears,
      mortgageTermYears: mortgageTermYears,
    );

    // ── Renter's investment gain ──────────────────────────────────────────────
    // A renter keeps the deposit + upfront costs and can invest them.
    // This gain makes renting cheaper, so we subtract it from rent cost.
    final upfrontInvested = deposit + stampDuty + buyingCosts;
    final investmentGains =
        upfrontInvested *
        (pow(1 + investmentReturn / 100, horizonYears) - 1).toDouble();

    // ── Buyer's equity at horizon ────────────────────────────────────────────
    final futurePropertyValue =
        propertyPrice * pow(1 + housePriceGrowth / 100, horizonYears);

    // Remaining mortgage balance uses the standard amortisation formula.
    final remainingBalance = _remainingMortgageBalance(
      principal: loanAmount,
      annualRatePercent: interestRate,
      termMonths: mortgageTermYears * 12,
      elapsedMonths: horizonYears * 12,
    );

    final equityGained = futurePropertyValue - remainingBalance;

    // ── Net positions (lower = better) ───────────────────────────────────────
    final rentNetCost = rentCosts['totalCost']! - investmentGains;
    final buyNetCost = buyCosts['totalCost']! - equityGained;

    // ── Break-even: first year when buying net < renting net ─────────────────
    int? breakEvenYear;
    for (int year = 1; year <= horizonYears; year++) {
      final rentY =
          _calculateRentCosts(
            monthlyRent: monthlyRent,
            annualIncrease: annualRentIncrease,
            years: year,
          )['totalCost']! -
          upfrontInvested *
              (pow(1 + investmentReturn / 100, year) - 1).toDouble();

      final futValY =
          propertyPrice * pow(1 + housePriceGrowth / 100, year).toDouble();
      final remBalY = _remainingMortgageBalance(
        principal: loanAmount,
        annualRatePercent: interestRate,
        termMonths: mortgageTermYears * 12,
        elapsedMonths: year * 12,
      );
      final buyY =
          _calculateBuyCosts(
            monthlyPayment: monthlyMortgagePayment,
            stampDuty: stampDuty,
            buyingCosts: buyingCosts,
            horizonYears: year,
            mortgageTermYears: mortgageTermYears,
          )['totalCost']! -
          (futValY - remBalY);

      if (buyY < rentY) {
        breakEvenYear = year;
        break;
      }
    }

    return {
      'totalRentCost': rentCosts['totalCost']!,
      'totalBuyCost': buyCosts['totalCost']!,
      'rentNetCost': rentNetCost,
      'buyNetCost': buyNetCost,
      'difference': rentNetCost - buyNetCost, // >0 → buying cheaper
      'investmentGains': investmentGains,
      'equityGained': equityGained,
      'remainingBalance': remainingBalance,
      'futurePropertyValue': futurePropertyValue,
      'breakEvenYear': breakEvenYear,
      'yearlyRentCosts': rentCosts['yearly']!,
      'yearlyBuyCosts': buyCosts['yearly']!,
    };
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  /// Remaining mortgage balance after [elapsedMonths].
  /// Returns 0 once the term is fully served.
  static double _remainingMortgageBalance({
    required double principal,
    required double annualRatePercent,
    required int termMonths,
    required int elapsedMonths,
  }) {
    if (elapsedMonths >= termMonths) return 0;
    final r = annualRatePercent / 100 / 12;
    if (r == 0) {
      // Interest-free: linear reduction
      return principal * (1 - elapsedMonths / termMonths);
    }
    // Standard amortisation formula: B(k) = P·[(1+r)^n − (1+r)^k] / [(1+r)^n − 1]
    final powN = pow(1 + r, termMonths);
    final powK = pow(1 + r, elapsedMonths);
    return principal * (powN - powK) / (powN - 1);
  }

  static Map<String, dynamic> _calculateRentCosts({
    required double monthlyRent,
    required double annualIncrease,
    required int years,
  }) {
    double totalCost = 0;
    final List<double> yearlyCosts = [];
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
    final upfrontCosts = stampDuty + buyingCosts;
    final monthsInHorizon = min(horizonYears * 12, mortgageTermYears * 12);
    final totalMortgagePayments = monthlyPayment * monthsInHorizon;
    final totalCost = upfrontCosts + totalMortgagePayments;

    final List<double> yearlyCosts = [];
    for (int year = 1; year <= horizonYears; year++) {
      if (year == 1) {
        yearlyCosts.add(upfrontCosts + monthlyPayment * 12);
      } else {
        final monthsRemaining = max(
          0,
          mortgageTermYears * 12 - (year - 1) * 12,
        );
        yearlyCosts.add(min(monthsRemaining, 12) * monthlyPayment);
      }
    }

    return {'totalCost': totalCost, 'yearly': yearlyCosts};
  }
}
