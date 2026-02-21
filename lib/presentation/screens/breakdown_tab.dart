import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/services/mortgage_scenario.dart';
import '../../domain/services/mortgage_calculator.dart';
import '../../domain/services/affordability_calculator.dart';
import '../../domain/services/remortgage_calculator.dart';
import '../widgets/visualization_widgets.dart';
import '../widgets/surface_card.dart';

class BreakdownTab extends StatefulWidget {
  final MortgageScenario scenario;

  const BreakdownTab({super.key, required this.scenario});

  @override
  State<BreakdownTab> createState() => _BreakdownTabState();
}

class _BreakdownTabState extends State<BreakdownTab> {
  int _selectedSegment = 0;

  // Overpayment state
  String _overpayType = 'None';
  double _monthlyOverpay = 200;
  double _lumpSumOverpay = 10000;
  int _lumpSumMonth = 12;

  // Affordability state
  double _annualIncome = 50000;
  double _monthlyCommitments = 0;
  double _incomeMultiplier = 4.5;

  // Remortgage state
  double _newRate = 3.5;
  double _remortgageFees = 999;
  bool _addFeesToLoan = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.scenario,
          builder: (context, _) {
            final schedule = widget.scenario.amortisationSchedule;
            final calc = widget.scenario.calculation;

            if (schedule == null || calc == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(),
                  const SizedBox(height: 16),

                  // Modern Pill Segmented Control
                  _buildSegmentedControl(),
                  const SizedBox(height: 16),

                  // Content with AnimatedSwitcher
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: _buildSegmentContent(schedule, calc),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Breakdown',
          style: TextStyle(
            fontSize: 20,
            fontWeight: AppTheme.fontWeightSemiBold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Updates instantly from your calculator',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(4),
      child: SegmentedButton<int>(
        showSelectedIcon: false,
        segments: const [
          ButtonSegment(
            value: 0,
            label: Text('Graph'),
          ),
          ButtonSegment(
            value: 1,
            label: Text('Table'),
          ),
          ButtonSegment(
            value: 2,
            label: Text('Overpay'),
          ),
          ButtonSegment(
            value: 3,
            label: Text('Tools'),
          ),
        ],
        selected: {_selectedSegment},
        onSelectionChanged: (Set<int> newSelection) {
          setState(() => _selectedSegment = newSelection.first);
        },
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return AppTheme.primaryBlue.withValues(alpha: 0.12);
            }
            return Colors.transparent;
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return AppTheme.primaryBlue;
            }
            return AppTheme.textSecondary;
          }),
        ),
      ),
    );
  }

  Widget _buildSegmentContent(schedule, calc) {
    return SingleChildScrollView(
      key: ValueKey(_selectedSegment),
      child: _selectedSegment == 0
          ? _buildGraphView(schedule, calc)
          : _selectedSegment == 1
              ? _buildTableView(schedule)
              : _selectedSegment == 2
                  ? _buildOverpaySection(calc, schedule)
                  : _buildToolsSection(calc),
    );
  }

  Widget _buildGraphView(schedule, calc) {
    final totalPaid = calc.monthlyPayment * calc.termYears * 12;
    final totalInterest = totalPaid - calc.loanAmount;

    String fmtK(double v) {
      if (v >= 1000000) return '£${(v / 1000000).toStringAsFixed(1)}m';
      if (v >= 1000) return '£${(v / 1000).toStringAsFixed(0)}k';
      return '£${v.toStringAsFixed(0)}';
    }

    return Column(
      children: [
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.show_chart_rounded,
                      size: 20,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mortgage Overview',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: AppTheme.fontWeightSemiBold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        '${calc.termYears}-year term',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildGraphStat(
                      'Total Interest',
                      fmtK(totalInterest),
                      AppTheme.graphInterest,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildGraphStat(
                      'Total Repaid',
                      fmtK(totalPaid),
                      AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildGraphStat(
                      'Monthly',
                      '£${calc.monthlyPayment.toStringAsFixed(0)}',
                      AppTheme.accentGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              MortgageGraph(schedule: schedule),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildStressTestCard(calc),
      ],
    );
  }

  Widget _buildGraphStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableView(schedule) {
    return AmortisationTable(schedule: schedule);
  }

  Widget _buildStressTestCard(calc) {
    final stressTest = MortgageCalculator.stressTestRates(
      loanAmount: calc.loanAmount,
      baseRate: widget.scenario.interestRate,
      termYears: widget.scenario.termYears,
    );

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, size: 20, color: AppTheme.accentOrange),
              const SizedBox(width: 8),
              Text(
                'Interest Rate Stress Test',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: AppTheme.fontWeightSemiBold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'See how rate changes affect your monthly payment',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          ...stressTest.entries.map((e) => _buildStressTestRow(
            '${e.key.toStringAsFixed(1)}%',
            '£${e.value.toStringAsFixed(0)}/mo',
            e.key,
            widget.scenario.interestRate,
          )),
        ],
      ),
    );
  }

  Widget _buildStressTestRow(String rate, String payment, double testRate, double currentRate) {
    final isHigher = testRate > currentRate;
    final isCurrent = (testRate - currentRate).abs() < 0.01;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isCurrent 
                    ? AppTheme.primaryBlue.withValues(alpha: 0.1)
                    : AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  rate,
                  style: TextStyle(
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                    color: isCurrent ? AppTheme.primaryBlue : AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (isCurrent) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Current',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
          Text(
            payment,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isCurrent 
                ? AppTheme.primaryBlue
                : isHigher 
                  ? AppTheme.accentOrange 
                  : AppTheme.accentGreen,
            ),
          ),
        ],
      ),
    );
  }

  // Overpayment Section
  Widget _buildOverpaySection(calc, baseSchedule) {
    Map<String, dynamic>? comparison;

    if (_overpayType != 'None') {
      final overpaySchedule = MortgageCalculator.generateAmortisationSchedule(
        loanAmount: calc.loanAmount,
        annualInterestRate: widget.scenario.interestRate,
        termYears: widget.scenario.termYears,
        monthlyOverpay: _overpayType == 'Monthly' ? _monthlyOverpay : 0,
        lumpSumOverpay: _overpayType == 'Lump Sum' ? _lumpSumOverpay : 0,
        lumpSumMonth: _overpayType == 'Lump Sum' ? _lumpSumMonth : 0,
      );

      comparison = MortgageCalculator.compareOverpay(
        baselineSchedule: baseSchedule,
        overpaySchedule: overpaySchedule,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.savings, size: 20, color: AppTheme.accentGreen),
                  const SizedBox(width: 8),
                  Text(
                    'Overpayment Calculator',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: AppTheme.fontWeightSemiBold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Overpay type selector
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: SegmentedButton<String>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(value: 'None', label: Text('None')),
                    ButtonSegment(value: 'Monthly', label: Text('Monthly')),
                    ButtonSegment(value: 'Lump Sum', label: Text('Lump Sum')),
                  ],
                  selected: {_overpayType},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() => _overpayType = newSelection.first);
                  },
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    backgroundColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return AppTheme.accentGreen.withValues(alpha: 0.12);
                      }
                      return Colors.transparent;
                    }),
                  ),
                ),
              ),

              // Fixed-height controls area - always same height regardless of selection
              const SizedBox(height: 24),
              SizedBox(
                height: 160,
                child: IndexedStack(
                  index: _overpayType == 'None' ? 0 : _overpayType == 'Monthly' ? 1 : 2,
                  children: [
                    // None - empty placeholder
                    Center(
                      child: Text(
                        'Select a payment type above to\ncalculate your savings',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ),
                    // Monthly
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monthly overpayment: £${_monthlyOverpay.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Slider(
                          value: _monthlyOverpay,
                          min: 50,
                          max: 2000,
                          divisions: 39,
                          onChanged: (v) => setState(() => _monthlyOverpay = v),
                        ),
                      ],
                    ),
                    // Lump Sum
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lump sum amount: £${_lumpSumOverpay.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Slider(
                          value: _lumpSumOverpay,
                          min: 1000,
                          max: 50000,
                          divisions: 49,
                          onChanged: (v) => setState(() => _lumpSumOverpay = v),
                        ),
                        Text(
                          'Month to pay: ${_lumpSumMonth}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Slider(
                          value: _lumpSumMonth.toDouble(),
                          min: 1,
                          max: 60,
                          divisions: 59,
                          onChanged: (v) => setState(() => _lumpSumMonth = v.toInt()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Divider(height: 32),

              // Results area - always same height, shows placeholder when no comparison
              SizedBox(
                height: 160,
                child: comparison != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildMetric(
                            'Interest Saved',
                            '£${comparison['interestSaved'].toStringAsFixed(0)}',
                            Icons.trending_down,
                            AppTheme.accentGreen,
                          ),
                          const Divider(height: 1),
                          _buildMetric(
                            'Time Saved',
                            '${comparison['yearsSaved'].toStringAsFixed(0)} years',
                            Icons.access_time,
                            AppTheme.primaryBlue,
                          ),
                          const Divider(height: 1),
                          _buildMetric(
                            'Months Saved',
                            '${comparison['monthsSaved']} months',
                            Icons.calendar_today,
                            AppTheme.accentOrange,
                          ),
                        ],
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calculate_outlined, size: 36, color: AppTheme.textTertiary),
                            const SizedBox(height: 8),
                            Text(
                              'Savings will appear here',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textTertiary,
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
    );
  }

  // Tools Section
  Widget _buildToolsSection(calc) {
    return Column(
      children: [
        _buildAffordabilityTool(),
        const SizedBox(height: 16),
        _buildRemortgageTool(calc),
      ],
    );
  }

  Widget _buildAffordabilityTool() {
    final result = AffordabilityCalculator.calculate(
      annualIncome: _annualIncome,
      deposit: widget.scenario.deposit,
      interestRate: widget.scenario.interestRate,
      termYears: widget.scenario.termYears,
      incomeMultiplier: _incomeMultiplier,
      monthlyCommitments: _monthlyCommitments,
    );

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_balance_wallet, size: 20, color: AppTheme.primaryBlue),
              const SizedBox(width: 8),
              Text(
                'Affordability Calculator',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: AppTheme.fontWeightSemiBold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Text(
            'Annual income: £${_annualIncome.toStringAsFixed(0)}',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Slider(
            value: _annualIncome,
            min: 20000,
            max: 200000,
            divisions: 180,
            onChanged: (v) => setState(() => _annualIncome = v),
          ),

          const SizedBox(height: 12),
          Text(
            'Income multiplier: ${_incomeMultiplier}x',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Slider(
            value: _incomeMultiplier,
            min: 3.0,
            max: 5.5,
            divisions: 25,
            onChanged: (v) => setState(() => _incomeMultiplier = v),
          ),

          const SizedBox(height: 12),
          Text(
            'Monthly commitments: £${_monthlyCommitments.toStringAsFixed(0)}',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Slider(
            value: _monthlyCommitments,
            min: 0,
            max: 2000,
            divisions: 40,
            onChanged: (v) => setState(() => _monthlyCommitments = v),
          ),

          const Divider(height: 32),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.accentGreen.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildMetric(
                  'Max Loan',
                  '£${result['maxLoan'].toStringAsFixed(0)}',
                  Icons.money,
                  AppTheme.accentGreen,
                ),
                const Divider(height: 20),
                _buildMetric(
                  'Max Property Price',
                  '£${result['maxPropertyPrice'].toStringAsFixed(0)}',
                  Icons.home,
                  AppTheme.primaryBlue,
                ),
                const Divider(height: 20),
                _buildMetric(
                  'Monthly Payment',
                  '£${result['monthlyPayment'].toStringAsFixed(0)}',
                  Icons.payment,
                  AppTheme.accentOrange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemortgageTool(calc) {
    final remainingTerm = widget.scenario.termYears;
    final result = RemortgageCalculator.calculate(
      currentBalance: calc.loanAmount,
      newRate: _newRate,
      remainingTermYears: remainingTerm,
      oldRate: widget.scenario.interestRate,
      fees: _remortgageFees,
      addFeesToLoan: _addFeesToLoan,
    );

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.refresh, size: 20, color: AppTheme.accentOrange),
              const SizedBox(width: 8),
              Text(
                'Remortgage Calculator',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: AppTheme.fontWeightSemiBold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Text(
            'New interest rate: ${_newRate.toStringAsFixed(0)}%',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Slider(
            value: _newRate,
            min: 1.0,
            max: 8.0,
            divisions: 70,
            onChanged: (v) => setState(() => _newRate = v),
          ),

          const SizedBox(height: 12),
          Text(
            'Remortgage fees: £${_remortgageFees.toStringAsFixed(0)}',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Slider(
            value: _remortgageFees,
            min: 0,
            max: 5000,
            divisions: 50,
            onChanged: (v) => setState(() => _remortgageFees = v),
          ),

          SwitchListTile(
            title: const Text('Add fees to loan'),
            value: _addFeesToLoan,
            onChanged: (v) => setState(() => _addFeesToLoan = v),
            contentPadding: EdgeInsets.zero,
          ),

          const Divider(height: 32),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildMetric(
                  'New Monthly Payment',
                  '£${result['newMonthlyPayment'].toStringAsFixed(0)}',
                  Icons.payment,
                  AppTheme.primaryBlue,
                ),
                if (result['monthlySaving'] != null) ...[
                  const Divider(height: 20),
                  _buildMetric(
                    'Monthly Saving',
                    '£${result['monthlySaving'].toStringAsFixed(0)}',
                    Icons.savings,
                    AppTheme.accentGreen,
                  ),
                ],
                if (result['breakEvenMonths'] != null) ...[
                  const Divider(height: 20),
                  _buildMetric(
                    'Break-even',
                    '${result['breakEvenMonths']} months',
                    Icons.timeline,
                    AppTheme.accentOrange,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
