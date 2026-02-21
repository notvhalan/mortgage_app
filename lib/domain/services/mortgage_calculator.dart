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
  /// Standard rates effective April 2025 (temporary £250k nil band ended).
  static double _calculateEnglandNIStampDuty(
    double price,
    bool isFirstTimeBuyer,
  ) {
    double duty = 0;

    if (isFirstTimeBuyer && price <= 500000) {
      // First-time buyer relief (April 2025 onward):
      //   0% up to £300,000 | 5% on £300,001–£500,000
      //   If price > £500,000 standard rates apply (fall through below)
      if (price > 300000) {
        duty += (price - 300000) * 0.05;
      }
      return duty;
    }

    // Standard residential rates
    //   0% up to £125,000
    //   2% on £125,001–£250,000
    //   5% on £250,001–£925,000
    //  10% on £925,001–£1,500,000
    //  12% over £1,500,000
    if (price > 125000) {
      duty += (min(price, 250000) - 125000) * 0.02;
    }
    if (price > 250000) {
      duty += (min(price, 925000) - 250000) * 0.05;
    }
    if (price > 925000) {
      duty += (min(price, 1500000) - 925000) * 0.10;
    }
    if (price > 1500000) {
      duty += (price - 1500000) * 0.12;
    }

    return duty;
  }

  /// Scotland Land and Buildings Transaction Tax (LBTT)
  /// First-time buyer relief: full LBTT exemption when price ≤ £175,000.
  static double _calculateScotlandLBTT(double price, bool isFirstTimeBuyer) {
    // Full relief for first-time buyers purchasing at or below £175,000
    if (isFirstTimeBuyer && price <= 175000) return 0;

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
  /// Current residential rates (effective October 2022).
  /// Wales has no first-time buyer relief.
  ///   0%   up to £225,000
  ///   6%   £225,001–£400,000
  ///   7.5% £400,001–£750,000
  ///  10%   £750,001–£1,500,000
  ///  12%   over £1,500,000
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
    double monthlyOverpay = 0,
    double lumpSumOverpay = 0,
    int lumpSumMonth = 0,
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
      if (balance <= 0) break;

      final interest = balance * monthlyRate;
      double payment = monthlyPayment + monthlyOverpay;

      // Apply lump sum overpayment if this is the specified month
      if (lumpSumMonth > 0 && month == lumpSumMonth) {
        payment += lumpSumOverpay;
      }

      // Cap principal at the remaining balance so the final payment is
      // never larger than what is actually owed.
      final rawPrincipal = payment - interest;
      final principal = rawPrincipal.clamp(0.0, balance);
      final actualPayment = principal + interest;
      balance -= principal; // balance is now exactly 0 or positive

      schedule.add(
        AmortisationRow(
          month: month,
          payment: actualPayment,
          interest: interest,
          principal: principal,
          balance: balance,
        ),
      );
    }

    return schedule;
  }

  /// Compare baseline schedule vs overpayment schedule
  static Map<String, dynamic> compareOverpay({
    required List<AmortisationRow> baselineSchedule,
    required List<AmortisationRow> overpaySchedule,
  }) {
    final baselineTotalInterest = baselineSchedule.fold<double>(
      0,
      (sum, row) => sum + row.interest,
    );
    final overpayTotalInterest = overpaySchedule.fold<double>(
      0,
      (sum, row) => sum + row.interest,
    );

    final interestSaved = baselineTotalInterest - overpayTotalInterest;
    final monthsSaved = baselineSchedule.length - overpaySchedule.length;
    final yearsSaved = monthsSaved / 12;

    return {
      'interestSaved': interestSaved,
      'monthsSaved': monthsSaved,
      'yearsSaved': yearsSaved,
      'overpayTotalInterest': overpayTotalInterest,
      'baselineTotalInterest': baselineTotalInterest,
    };
  }

  /// Stress test monthly payments at different interest rates
  static Map<double, double> stressTestRates({
    required double loanAmount,
    required double baseRate,
    required int termYears,
    List<double> rateDeltas = const [0, 0.5, 1.0, 2.0, 3.0],
  }) {
    final Map<double, double> results = {};

    for (final delta in rateDeltas) {
      final testRate = baseRate + delta;
      final payment = calculateMonthlyPayment(
        loanAmount: loanAmount,
        annualInterestRate: testRate,
        termYears: termYears,
      );
      results[testRate] = payment;
    }

    return results;
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
