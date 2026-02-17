class MortgageCalculation {
  final double propertyPrice;
  final double deposit;
  final double interestRate;
  final int termYears;
  final String region;

  final double loanAmount;
  final double monthlyPayment;
  final double stampDuty;
  final double ltv;

  MortgageCalculation({
    required this.propertyPrice,
    required this.deposit,
    required this.interestRate,
    required this.termYears,
    required this.region,
    required this.loanAmount,
    required this.monthlyPayment,
    required this.stampDuty,
    required this.ltv,
  });
}

class AmortisationRow {
  final int month;
  final double payment;
  final double interest;
  final double principal;
  final double balance;

  AmortisationRow({
    required this.month,
    required this.payment,
    required this.interest,
    required this.principal,
    required this.balance,
  });
}
