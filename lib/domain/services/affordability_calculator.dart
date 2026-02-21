import 'mortgage_calculator.dart';

/// Affordability calculator for UK mortgages
class AffordabilityCalculator {
  /// Calculate maximum affordable loan based on income
  static Map<String, dynamic> calculate({
    required double annualIncome,
    required double deposit,
    required double interestRate,
    required int termYears,
    double incomeMultiplier = 4.5,
    double monthlyCommitments = 0,
  }) {
    // Calculate max loan based on income multiplier
    double maxLoan = annualIncome * incomeMultiplier;

    // Reduce for monthly commitments (conservative approach)
    if (monthlyCommitments > 0) {
      final annualCommitments = monthlyCommitments * 12;
      maxLoan -= annualCommitments * 3; // Conservative factor
    }

    // Ensure max loan is positive
    if (maxLoan < 0) maxLoan = 0;

    // Calculate max property price
    final maxPropertyPrice = maxLoan + deposit;

    // Calculate monthly payment at max loan
    final monthlyPayment = MortgageCalculator.calculateMonthlyPayment(
      loanAmount: maxLoan,
      annualInterestRate: interestRate,
      termYears: termYears,
    );

    // Calculate debt-to-income ratio
    final dti = (monthlyPayment / (annualIncome / 12)) * 100;

    return {
      'maxLoan': maxLoan,
      'maxPropertyPrice': maxPropertyPrice,
      'monthlyPayment': monthlyPayment,
      'debtToIncomeRatio': dti,
      'deposit': deposit,
      'incomeMultiplier': incomeMultiplier,
    };
  }

  /// Calculate with different income multipliers
  static List<Map<String, dynamic>> calculateWithMultipliers({
    required double annualIncome,
    required double deposit,
    required double interestRate,
    required int termYears,
    double monthlyCommitments = 0,
    List<double> multipliers = const [4.0, 4.5, 5.0],
  }) {
    return multipliers.map((multiplier) {
      return calculate(
        annualIncome: annualIncome,
        deposit: deposit,
        interestRate: interestRate,
        termYears: termYears,
        incomeMultiplier: multiplier,
        monthlyCommitments: monthlyCommitments,
      );
    }).toList();
  }
}
