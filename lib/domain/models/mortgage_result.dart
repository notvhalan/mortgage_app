class MortgageResult {
  final double monthlyPayment;
  final double loanAmount;
  final double stampDuty;
  final double ltv;
  final double totalInterest;
  final double totalPayable;

  MortgageResult({
    required this.monthlyPayment,
    required this.loanAmount,
    required this.stampDuty,
    required this.ltv,
    required this.totalInterest,
    required this.totalPayable,
  });
}
