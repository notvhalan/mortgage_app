import 'mortgage_calculator.dart';

/// Remortgage calculator for comparing deals
class RemortgageCalculator {
  /// Calculate remortgage details
  static Map<String, dynamic> calculate({
    required double currentBalance,
    required double newRate,
    required int remainingTermYears,
    double oldRate = 0,
    double fees = 0,
    bool addFeesToLoan = false,
  }) {
    // Calculate loan amount (with or without fees)
    final effectiveLoan = addFeesToLoan
        ? currentBalance + fees
        : currentBalance;

    // Calculate new monthly payment
    final newMonthlyPayment = MortgageCalculator.calculateMonthlyPayment(
      loanAmount: effectiveLoan,
      annualInterestRate: newRate,
      termYears: remainingTermYears,
    );

    // Calculate total interest on new deal
    final totalPayments = newMonthlyPayment * remainingTermYears * 12;
    final totalInterest = totalPayments - effectiveLoan;

    // Calculate old monthly payment if old rate provided
    double? oldMonthlyPayment;
    double? monthlySaving;
    int? breakEvenMonths;

    if (oldRate > 0) {
      oldMonthlyPayment = MortgageCalculator.calculateMonthlyPayment(
        loanAmount: currentBalance,
        annualInterestRate: oldRate,
        termYears: remainingTermYears,
      );
      monthlySaving = oldMonthlyPayment - newMonthlyPayment;

      // Calculate break-even if there are upfront fees
      if (fees > 0 && monthlySaving > 0) {
        final upfrontCost = addFeesToLoan ? 0 : fees;
        breakEvenMonths = (upfrontCost / monthlySaving).ceil();
      }
    }

    return {
      'currentBalance': currentBalance,
      'effectiveLoan': effectiveLoan,
      'newMonthlyPayment': newMonthlyPayment,
      'totalInterest': totalInterest,
      'oldMonthlyPayment': oldMonthlyPayment,
      'monthlySaving': monthlySaving,
      'fees': fees,
      'breakEvenMonths': breakEvenMonths,
      'addFeesToLoan': addFeesToLoan,
    };
  }
}
