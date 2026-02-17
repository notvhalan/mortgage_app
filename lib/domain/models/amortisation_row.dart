class AmortisationRow {
  final int period; // Month or year number
  final double payment;
  final double interest;
  final double principal;
  final double balance;

  AmortisationRow({
    required this.period,
    required this.payment,
    required this.interest,
    required this.principal,
    required this.balance,
  });
}
