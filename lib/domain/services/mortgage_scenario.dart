import 'package:flutter/foundation.dart';
import '../models/mortgage_calculation.dart';
import 'mortgage_calculator.dart';

/// Shared state for the current mortgage scenario
/// All tabs subscribe to this to stay synchronized
class MortgageScenario extends ChangeNotifier {
  // Inputs
  double _propertyPrice = 300000;
  double _depositPercentage = 10;
  double _interestRate = 4.5;
  int _termYears = 25;
  String _region = 'England/NI';

  // Calculated outputs
  MortgageCalculation? _calculation;
  List<AmortisationRow>? _amortisationSchedule;

  // Getters for inputs
  double get propertyPrice => _propertyPrice;
  double get depositPercentage => _depositPercentage;
  double get interestRate => _interestRate;
  int get termYears => _termYears;
  String get region => _region;
  double get deposit => _propertyPrice * (_depositPercentage / 100);

  // Getters for outputs
  MortgageCalculation? get calculation => _calculation;
  List<AmortisationRow>? get amortisationSchedule => _amortisationSchedule;

  MortgageScenario() {
    _calculate();
  }

  // Setters that trigger recalculation
  void updatePropertyPrice(double value) {
    _propertyPrice = value;
    _calculate();
    notifyListeners();
  }

  void updateDepositPercentage(double value) {
    _depositPercentage = value;
    _calculate();
    notifyListeners();
  }

  void updateInterestRate(double value) {
    _interestRate = value;
    _calculate();
    notifyListeners();
  }

  void updateTermYears(int value) {
    _termYears = value;
    _calculate();
    notifyListeners();
  }

  void updateRegion(String value) {
    _region = value;
    _calculate();
    notifyListeners();
  }

  void resetToDefaults() {
    _propertyPrice = 300000;
    _depositPercentage = 10;
    _interestRate = 4.5;
    _termYears = 25;
    _region = 'England/NI';
    _calculate();
    notifyListeners();
  }

  void _calculate() {
    final depositAmount = _propertyPrice * (_depositPercentage / 100);

    _calculation = MortgageCalculator.calculate(
      propertyPrice: _propertyPrice,
      deposit: depositAmount,
      interestRate: _interestRate,
      termYears: _termYears,
      region: _region,
    );

    _amortisationSchedule = MortgageCalculator.generateAmortisationSchedule(
      loanAmount: _calculation!.loanAmount,
      annualInterestRate: _interestRate,
      termYears: _termYears,
    );
  }
}
