// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:mortgage_app/domain/services/mortgage_calculator.dart';

void main() {
  group('Mortgage Calculator Tests', () {
    test('Calculate monthly payment correctly', () {
      final payment = MortgageCalculator.calculateMonthlyPayment(
        loanAmount: 240000,
        annualInterestRate: 4.5,
        termYears: 25,
      );
      
      expect(payment, closeTo(1333.58, 1.0));
    });
    
    test('Calculate LTV correctly', () {
      final ltv = MortgageCalculator.calculateLTV(
        propertyPrice: 300000,
        deposit: 60000,
      );
      
      expect(ltv, equals(80.0));
    });
    
    test('Calculate stamp duty for England/NI', () {
      final stampDuty = MortgageCalculator.calculateStampDuty(
        propertyPrice: 300000,
        region: 'England/NI',
      );
      
      expect(stampDuty, equals(2500.0));
    });
  });
}

