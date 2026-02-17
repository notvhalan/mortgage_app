import 'dart:math';
import '../models/mortgage_calculation.dart';

class MortgageCalculator {
  /// Calculate monthly mortgage payment using standard formula
  /// P = L * [ r(1+r)^n ] / [ (1+r)^n − 1 ]
  static double calculateMonthlyPayment({
    required double loanAmount,
    required double annualInterestRate,
    required int termYears,
  }) {
    if (loanAmount <= 0 || termYears <= 0) return 0;
    if (annualInterestRate <= 0) return loanAmount / (termYears * 12);

    final monthlyRate = annualInterestRate / 100 / 12;
    final numberOfPayments = termYears * 12;

    final payment =
        loanAmount *
        (monthlyRate * pow(1 + monthlyRate, numberOfPayments)) /
        (pow(1 + monthlyRate, numberOfPayments) - 1);

    return payment;
  }

  /// Calculate Loan to Value percentage
  static double calculateLTV({
    required double propertyPrice,
    required double deposit,
  }) {
    if (propertyPrice <= 0) return 0;
    final loanAmount = propertyPrice - deposit;
    return (loanAmount / propertyPrice) * 100;
  }

  /// Calculate stamp duty based on region
  static double calculateStampDuty({
    required double propertyPrice,
    required String region,
    bool isFirstTimeBuyer = false,
  }) {
    switch (region) {
      case 'England/NI':
        return _calculateEnglandNIStampDuty(propertyPrice, isFirstTimeBuyer);
      case 'Scotland':
        return _calculateScotlandLBTT(propertyPrice, isFirstTimeBuyer);
      case 'Wales':
        return _calculateWalesLTT(propertyPrice, isFirstTimeBuyer);
      default:
        return _calculateEnglandNIStampDuty(propertyPrice, isFirstTimeBuyer);
    }
  }

  /// England and Northern Ireland Stamp Duty Land Tax (SDLT)
  static double _calculateEnglandNIStampDuty(
    double price,
    bool isFirstTimeBuyer,
  ) {
    double duty = 0;

    if (isFirstTimeBuyer && price <= 625000) {
      // First-time buyer relief
      if (price <= 425000) {
        return 0;
      } else {
        duty += (price - 425000) * 0.05;
      }
    } else {
      // Standard rates
      if (price > 250000) {
        duty += (min(price, 925000) - 250000) * 0.05;
      }
      if (price > 925000) {
        duty += (min(price, 1500000) - 925000) * 0.10;
      }
      if (price > 1500000) {
        duty += (price - 1500000) * 0.12;
      }
    }

    return duty;
  }

  /// Scotland Land and Buildings Transaction Tax (LBTT)
  static double _calculateScotlandLBTT(double price, bool isFirstTimeBuyer) {
    double duty = 0;

    if (price > 145000) {
      duty += (min(price, 250000) - 145000) * 0.02;
    }
    if (price > 250000) {
      duty += (min(price, 325000) - 250000) * 0.05;
    }
    if (price > 325000) {
      duty += (min(price, 750000) - 325000) * 0.10;
    }
    if (price > 750000) {
      duty += (price - 750000) * 0.12;
    }

    return duty;
  }

  /// Wales Land Transaction Tax (LTT)
  static double _calculateWalesLTT(double price, bool isFirstTimeBuyer) {
    double duty = 0;

    if (price > 225000) {
      duty += (min(price, 400000) - 225000) * 0.06;
    }
    if (price > 400000) {
      duty += (min(price, 750000) - 400000) * 0.075;
    }
    if (price > 750000) {
      duty += (min(price, 1500000) - 750000) * 0.10;
    }
    if (price > 1500000) {
      duty += (price - 1500000) * 0.12;
    }

    return duty;
  }

  /// Generate full mortgage calculation
  static MortgageCalculation calculate({
    required double propertyPrice,
    required double deposit,
    required double interestRate,
    required int termYears,
    required String region,
    bool isFirstTimeBuyer = false,
  }) {
    final loanAmount = propertyPrice - deposit;
    final monthlyPayment = calculateMonthlyPayment(
      loanAmount: loanAmount,
      annualInterestRate: interestRate,
      termYears: termYears,
    );
    final stampDuty = calculateStampDuty(
      propertyPrice: propertyPrice,
      region: region,
      isFirstTimeBuyer: isFirstTimeBuyer,
    );
    final ltv = calculateLTV(propertyPrice: propertyPrice, deposit: deposit);

    return MortgageCalculation(
      propertyPrice: propertyPrice,
      deposit: deposit,
      interestRate: interestRate,
      termYears: termYears,
      region: region,
      loanAmount: loanAmount,
      monthlyPayment: monthlyPayment,
      stampDuty: stampDuty,
      ltv: ltv,
    );
  }

  /// Generate amortisation schedule
  static List<AmortisationRow> generateAmortisationSchedule({
    required double loanAmount,
    required double annualInterestRate,
    required int termYears,
  }) {
    final List<AmortisationRow> schedule = [];
    final monthlyPayment = calculateMonthlyPayment(
      loanAmount: loanAmount,
      annualInterestRate: annualInterestRate,
      termYears: termYears,
    );

    final monthlyRate = annualInterestRate / 100 / 12;
    double balance = loanAmount;

    for (int month = 1; month <= termYears * 12; month++) {
      final interest = balance * monthlyRate;
      final principal = monthlyPayment - interest;
      balance -= principal;

      // Avoid negative balance due to rounding
      if (balance < 0) balance = 0;

      schedule.add(
        AmortisationRow(
          month: month,
          payment: monthlyPayment,
          interest: interest,
          principal: principal,
          balance: balance,
        ),
      );
    }

    return schedule;
  }

  /// Generate yearly summary from amortisation schedule
  static List<AmortisationRow> generateYearlySummary(
    List<AmortisationRow> schedule,
  ) {
    final List<AmortisationRow> yearlySummary = [];

    for (int year = 1; year <= schedule.length ~/ 12; year++) {
      final startMonth = (year - 1) * 12;
      final endMonth = min(year * 12, schedule.length);

      double totalPayment = 0;
      double totalInterest = 0;
      double totalPrincipal = 0;

      for (int i = startMonth; i < endMonth; i++) {
        totalPayment += schedule[i].payment;
        totalInterest += schedule[i].interest;
        totalPrincipal += schedule[i].principal;
      }

      yearlySummary.add(
        AmortisationRow(
          month: year,
          payment: totalPayment,
          interest: totalInterest,
          principal: totalPrincipal,
          balance: schedule[endMonth - 1].balance,
        ),
      );
    }

    return yearlySummary;
  }
}
