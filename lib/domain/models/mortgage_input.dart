class MortgageInput {
  final double propertyPrice;
  final double deposit;
  final double interestRate; // Annual rate as percentage (e.g., 4.5 for 4.5%)
  final int termYears;
  final String region; // 'england_ni', 'scotland', 'wales'

  MortgageInput({
    required this.propertyPrice,
    required this.deposit,
    required this.interestRate,
    required this.termYears,
    required this.region,
  });

  double get loanAmount => propertyPrice - deposit;
  double get ltv => (loanAmount / propertyPrice) * 100;
  double get depositPercentage => (deposit / propertyPrice) * 100;

  MortgageInput copyWith({
    double? propertyPrice,
    double? deposit,
    double? interestRate,
    int? termYears,
    String? region,
  }) {
    return MortgageInput(
      propertyPrice: propertyPrice ?? this.propertyPrice,
      deposit: deposit ?? this.deposit,
      interestRate: interestRate ?? this.interestRate,
      termYears: termYears ?? this.termYears,
      region: region ?? this.region,
    );
  }

  static MortgageInput defaultInput() {
    return MortgageInput(
      propertyPrice: 300000,
      deposit: 30000,
      interestRate: 4.5,
      termYears: 25,
      region: 'england_ni',
    );
  }
}
