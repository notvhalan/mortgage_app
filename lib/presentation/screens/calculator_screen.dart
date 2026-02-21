import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/mortgage_calculation.dart';
import '../../domain/services/mortgage_calculator.dart';
import '../widgets/calculator_widgets.dart';
import '../widgets/visualization_widgets.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  double propertyPrice = 300000;
  double depositPercentage = 10;
  double interestRate = 4.5;
  int termYears = 25;
  String region = 'England/NI';

  MortgageCalculation? calculation;
  List<AmortisationRow>? amortisationSchedule;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  void _calculate() {
    final deposit = propertyPrice * (depositPercentage / 100);

    setState(() {
      calculation = MortgageCalculator.calculate(
        propertyPrice: propertyPrice,
        deposit: deposit,
        interestRate: interestRate,
        termYears: termYears,
        region: region,
      );

      amortisationSchedule = MortgageCalculator.generateAmortisationSchedule(
        loanAmount: calculation!.loanAmount,
        annualInterestRate: interestRate,
        termYears: termYears,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UK Mortgage Calculator')),
      body: calculation == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Summary Card
                  SummaryCard(
                    propertyPrice: propertyPrice,
                    monthlyPayment: calculation!.monthlyPayment,
                    loanAmount: calculation!.loanAmount,
                    stampDuty: calculation!.stampDuty,
                    ltv: calculation!.ltv,
                  ),

                  const SizedBox(height: AppTheme.sectionSpacing),

                  // Input Controls
                  InputSlider(
                    label: 'Property Price',
                    value: propertyPrice,
                    min: 50000,
                    max: 2000000,
                    divisions: 1950,
                    valueFormatter: (v) => '£${v.toStringAsFixed(0)}',
                    onChanged: (value) {
                      setState(() => propertyPrice = value);
                      _calculate();
                    },
                  ),

                  const SizedBox(height: 12),

                  InputSlider(
                    label: 'Deposit',
                    value: depositPercentage,
                    min: 5,
                    max: 50,
                    divisions: 45,
                    valueFormatter: (v) => '${v.toStringAsFixed(0)}%',
                    onChanged: (value) {
                      setState(() => depositPercentage = value);
                      _calculate();
                    },
                  ),

                  const SizedBox(height: 12),

                  InputSlider(
                    label: 'Interest Rate',
                    value: interestRate,
                    min: 1,
                    max: 8,
                    divisions: 70,
                    valueFormatter: (v) => '${v.toStringAsFixed(1)}%',
                    onChanged: (value) {
                      setState(() => interestRate = value);
                      _calculate();
                    },
                  ),

                  const SizedBox(height: 12),

                  InputSlider(
                    label: 'Term',
                    value: termYears.toDouble(),
                    min: 5,
                    max: 40,
                    divisions: 35,
                    valueFormatter: (v) => '${v.toStringAsFixed(0)} years',
                    onChanged: (value) {
                      setState(() => termYears = value.toInt());
                      _calculate();
                    },
                  ),

                  const SizedBox(height: 12),

                  RegionSelector(
                    selectedRegion: region,
                    onChanged: (value) {
                      setState(() => region = value);
                      _calculate();
                    },
                  ),

                  const SizedBox(height: AppTheme.sectionSpacing),

                  // Visualization Section - 2x2 Grid
                  Container(
                    height: 600,
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.9,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        // Graph
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Text(
                                  'Graph',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: AppTheme.fontWeightSemiBold,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: MortgageGraph(
                                    schedule: amortisationSchedule!,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Table
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Text(
                                  'Table',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: AppTheme.fontWeightSemiBold,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: AmortisationTable(
                                    schedule: amortisationSchedule!,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Placeholder for future features (bottom-left)
                        Card(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.analytics,
                                  size: 48,
                                  color: AppTheme.textTertiary,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Coming Soon',
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Placeholder for future features (bottom-right)
                        Card(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.pie_chart,
                                  size: 48,
                                  color: AppTheme.textTertiary,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Coming Soon',
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
