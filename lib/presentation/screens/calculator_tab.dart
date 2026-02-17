import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/services/mortgage_scenario.dart';
import '../widgets/calculator_widgets.dart';

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
      appBar: AppBar(
        title: const Text('Calculator'),
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
                // Summary Card
                SummaryCard(
                  monthlyPayment: calc.monthlyPayment,
                  loanAmount: calc.loanAmount,
                  stampDuty: calc.stampDuty,
                  ltv: calc.ltv,
                ),
                
                const SizedBox(height: AppTheme.sectionSpacing),
                
                // Input Controls
                InputSlider(
                  label: 'Property Price',
                  value: scenario.propertyPrice,
                  min: 50000,
                  max: 2000000,
                  divisions: 1950,
                  valueFormatter: (v) => '£${v.toStringAsFixed(0)}',
                  onChanged: scenario.updatePropertyPrice,
                ),
                
                const SizedBox(height: 12),
                
                InputSlider(
                  label: 'Deposit',
                  value: scenario.depositPercentage,
                  min: 5,
                  max: 50,
                  divisions: 45,
                  valueFormatter: (v) => '${v.toStringAsFixed(0)}%',
                  onChanged: scenario.updateDepositPercentage,
                ),
                
                const SizedBox(height: 12),
                
                InputSlider(
                  label: 'Interest Rate',
                  value: scenario.interestRate,
                  min: 1,
                  max: 8,
                  divisions: 70,
                  valueFormatter: (v) => '${v.toStringAsFixed(1)}%',
                  onChanged: scenario.updateInterestRate,
                ),
                
                const SizedBox(height: 12),
                
                InputSlider(
                  label: 'Term',
                  value: scenario.termYears.toDouble(),
                  min: 5,
                  max: 40,
                  divisions: 35,
                  valueFormatter: (v) => '${v.toStringAsFixed(0)} years',
                  onChanged: (v) => scenario.updateTermYears(v.toInt()),
                ),
                
                const SizedBox(height: 12),
                
                RegionSelector(
                  selectedRegion: scenario.region,
                  onChanged: scenario.updateRegion,
                ),
                
                const SizedBox(height: AppTheme.sectionSpacing),
                
                // Quick Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset'),
                        onPressed: scenario.resetToDefaults,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.bar_chart),
                        label: const Text('View Breakdown'),
                        onPressed: onViewBreakdown,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
