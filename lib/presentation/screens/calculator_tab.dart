import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/services/mortgage_scenario.dart';
import '../widgets/premium_widgets.dart';

class CalculatorTab extends StatelessWidget {
  final MortgageScenario scenario;
  final VoidCallback? onViewBreakdown;

  const CalculatorTab({
    super.key,
    required this.scenario,
    this.onViewBreakdown,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: const Color(0xFFF7F8FA),
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: scenario,
        builder: (context, _) {
          final calc = scenario.calculation;

          if (calc == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Hero Summary Card
                HeroSummaryCard(
                  monthlyPayment: calc.monthlyPayment,
                  loanAmount: calc.loanAmount,
                  stampDuty: calc.stampDuty,
                  ltv: calc.ltv,
                  region: scenario.region,
                  onRegionChanged: (v) => scenario.updateRegion(v!),
                ),

                const SizedBox(height: 14),

                // Property Price Control
                ControlCard(
                  title: 'Property Price',
                  subtitle: 'Total purchase price',
                  value: '£${scenario.propertyPrice.toStringAsFixed(0)}',
                  sliderValue: scenario.propertyPrice,
                  min: 50000,
                  max: 2000000,
                  divisions: 1950,
                  minLabel: '£50k',
                  maxLabel: '£2M',
                  onChanged: scenario.updatePropertyPrice,
                ),

                const SizedBox(height: 10),

                // Deposit Control
                ControlCard(
                  title: 'Deposit',
                  subtitle: 'Affects your LTV ratio',
                  value: '£${scenario.deposit.toStringAsFixed(0)}',
                  sliderValue: scenario.deposit.clamp(
                    scenario.propertyPrice * 0.05,
                    scenario.propertyPrice * 0.95,
                  ),
                  min: scenario.propertyPrice * 0.05,
                  max: scenario.propertyPrice * 0.95,
                  minLabel:
                      '£${(scenario.propertyPrice * 0.05 / 1000).toStringAsFixed(0)}k',
                  maxLabel:
                      '£${(scenario.propertyPrice * 0.95 / 1000).toStringAsFixed(0)}k',
                  onChanged: scenario.updateDepositAmount,
                ),

                const SizedBox(height: 10),

                // Interest Rate Control
                ControlCard(
                  title: 'Interest Rate',
                  subtitle: 'Annual interest rate',
                  value: '${scenario.interestRate.toStringAsFixed(2)}%',
                  sliderValue: scenario.interestRate,
                  min: 1,
                  max: 8,
                  divisions: 70,
                  minLabel: '1%',
                  maxLabel: '8%',
                  onChanged: scenario.updateInterestRate,
                ),

                const SizedBox(height: 10),

                // Mortgage Term Control
                ControlCard(
                  title: 'Mortgage Term',
                  subtitle: 'Length of mortgage',
                  value: '${scenario.termYears.toStringAsFixed(0)} years',
                  sliderValue: scenario.termYears.toDouble(),
                  min: 5,
                  max: 35,
                  divisions: 30,
                  minLabel: '5 years',
                  maxLabel: '35 years',
                  onChanged: (v) => scenario.updateTermYears(v.toInt()),
                ),

                const SizedBox(height: 14),

                // View Breakdown Button
                if (onViewBreakdown != null)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: onViewBreakdown,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: AppTheme.primaryBlue.withValues(
                          alpha: 0.3,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'View Detailed Breakdown',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 10),

                // First-Time Buyer Toggle
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppTheme.accentGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.home_rounded,
                          size: 18,
                          color: AppTheme.accentGreen,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'First-Time Buyer',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              scenario.isFirstTimeBuyer
                                  ? 'Stamp duty relief applied'
                                  : 'Standard stamp duty rates',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: scenario.isFirstTimeBuyer,
                        activeColor: AppTheme.accentGreen,
                        onChanged: scenario.updateIsFirstTimeBuyer,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
