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

                  // Visualization Section
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        const TabBar(
                          tabs: [
                            Tab(text: 'Graph'),
                            Tab(text: 'Table'),
                          ],
                        ),
                        SizedBox(
                          height: 500,
                          child: TabBarView(
                            children: [
                              Card(
                                child: MortgageGraph(
                                  schedule: amortisationSchedule!,
                                ),
                              ),
                              Card(
                                child: AmortisationTable(
                                  schedule: amortisationSchedule!,
                                ),
                              ),
                            ],
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
