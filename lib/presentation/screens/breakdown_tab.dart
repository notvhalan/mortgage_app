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
  String _overpayType = 'Monthly';
  double _monthlyOverpay = 200;
  double _lumpSumOverpay = 10000;
  int _lumpSumMonth = 12;

  // Overpayment text controllers
  late final TextEditingController _monthlyOverpayCtrl;
  late final TextEditingController _lumpSumOverpayCtrl;
  late final TextEditingController _lumpSumMonthCtrl;
  late final FocusNode _monthlyOverpayFocus;
  late final FocusNode _lumpSumOverpayFocus;
  late final FocusNode _lumpSumMonthFocus;

  // Affordability state
  double _annualIncome = 50000;
  double _monthlyCommitments = 0;
  double _incomeMultiplier = 4.5;

  // Remortgage state
  double _newRate = 3.5;
  double _remortgageFees = 999;
  bool _addFeesToLoan = false;

  @override
  void initState() {
    super.initState();
    _monthlyOverpayCtrl = TextEditingController(
      text: _monthlyOverpay.toStringAsFixed(0),
    );
    _lumpSumOverpayCtrl = TextEditingController(
      text: _lumpSumOverpay.toStringAsFixed(0),
    );
    _lumpSumMonthCtrl = TextEditingController(text: _lumpSumMonth.toString());
    _monthlyOverpayFocus = FocusNode();
    _lumpSumOverpayFocus = FocusNode();
    _lumpSumMonthFocus = FocusNode();
    _monthlyOverpayFocus.addListener(() {
      if (!_monthlyOverpayFocus.hasFocus) {
        _submitOverpay(
          _monthlyOverpayCtrl.text,
          50,
          2000,
          (v) => setState(() {
            _monthlyOverpay = v;
            _monthlyOverpayCtrl.text = v.toStringAsFixed(0);
          }),
        );
      }
    });
    _lumpSumOverpayFocus.addListener(() {
      if (!_lumpSumOverpayFocus.hasFocus) {
        _submitOverpay(
          _lumpSumOverpayCtrl.text,
          1000,
          50000,
          (v) => setState(() {
            _lumpSumOverpay = v;
            _lumpSumOverpayCtrl.text = v.toStringAsFixed(0);
          }),
        );
      }
    });
    _lumpSumMonthFocus.addListener(() {
      if (!_lumpSumMonthFocus.hasFocus) {
        final maxMonth =
            (widget.scenario.termYears * 12).clamp(1, 120).toDouble();
        _submitOverpay(
          _lumpSumMonthCtrl.text,
          1,
          maxMonth,
          (v) => setState(() {
            _lumpSumMonth = v.toInt();
            _lumpSumMonthCtrl.text = v.toInt().toString();
          }),
        );
      }
    });
  }

  void _submitOverpay(
    String raw,
    double min,
    double max,
    void Function(double) onValid,
  ) {
    final parsed = double.tryParse(
      raw.replaceAll(',', '').replaceAll('£', '').trim(),
    );
    if (parsed != null) {
      onValid(parsed.clamp(min, max));
    }
  }

  @override
  void dispose() {
    _monthlyOverpayCtrl.dispose();
    _lumpSumOverpayCtrl.dispose();
    _lumpSumMonthCtrl.dispose();
    _monthlyOverpayFocus.dispose();
    _lumpSumOverpayFocus.dispose();
    _lumpSumMonthFocus.dispose();
    super.dispose();
  }

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
          style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSegmentedControl() {
    const tabs = [
      (icon: Icons.show_chart_rounded, label: 'Graph'),
      (icon: Icons.table_rows_rounded, label: 'Table'),
      (icon: Icons.trending_up_rounded, label: 'Overpay'),
      (icon: Icons.build_rounded, label: 'Tools'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(5),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final selected = _selectedSegment == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedSegment = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  gradient: selected
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF9FE6DE), Color(0xFF0D9488)],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tabs[i].icon,
                      size: 16,
                      color: selected ? Colors.white : AppTheme.textTertiary,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      tabs[i].label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: selected ? Colors.white : AppTheme.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
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
    return Column(
      children: [
        SurfaceCard(
          backgroundColor: Colors.transparent,
          border: const Border(),
          shadows: [],
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
              MortgageGraph(schedule: schedule),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildStressTestCard(calc),
      ],
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
      backgroundColor: Colors.transparent,
      border: const Border(),
      shadows: [],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.accentOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.trending_up,
                  size: 18,
                  color: AppTheme.accentOrange,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rate Stress Test',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: AppTheme.fontWeightSemiBold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    'How rate changes affect your payment',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...stressTest.entries.map(
            (e) => _buildStressTestRow(
              '${e.key.toStringAsFixed(1)}%',
              '£${e.value.toStringAsFixed(0)}/mo',
              e.key,
              widget.scenario.interestRate,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStressTestRow(
    String rate,
    String payment,
    double testRate,
    double currentRate,
  ) {
    final isHigher = testRate > currentRate;
    final isCurrent = (testRate - currentRate).abs() < 0.01;
    final rowColor = isCurrent
        ? AppTheme.primaryBlue
        : isHigher
        ? AppTheme.accentOrange
        : AppTheme.accentGreen;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isCurrent
            ? AppTheme.primaryBlue.withValues(alpha: 0.06)
            : AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(14),
        border: isCurrent
            ? Border.all(
                color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                width: 1,
              )
            : null,
        boxShadow: isCurrent
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: rowColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                rate,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
              if (isCurrent) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Current',
                    style: TextStyle(
                      fontSize: 10,
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
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: rowColor,
            ),
          ),
        ],
      ),
    );
  }

  // Overpayment Section
  Widget _buildOverpaySection(calc, baseSchedule) {
    final overpaySchedule = MortgageCalculator.generateAmortisationSchedule(
      loanAmount: calc.loanAmount,
      annualInterestRate: widget.scenario.interestRate,
      termYears: widget.scenario.termYears,
      monthlyOverpay: _overpayType == 'Monthly' ? _monthlyOverpay : 0,
      lumpSumOverpay: _overpayType == 'Lump Sum' ? _lumpSumOverpay : 0,
      lumpSumMonth: _overpayType == 'Lump Sum' ? _lumpSumMonth : 0,
    );

    final comparison = MortgageCalculator.compareOverpay(
      baselineSchedule: baseSchedule,
      overpaySchedule: overpaySchedule,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SurfaceCard(
          backgroundColor: Colors.transparent,
          border: const Border(),
          shadows: [],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.savings_rounded,
                      size: 18,
                      color: AppTheme.accentGreen,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overpayment Calculator',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: AppTheme.fontWeightSemiBold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'See how overpaying reduces your mortgage',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Overpay type selector
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.backgroundWhite,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    for (final tab in [
                      (
                        value: 'Monthly',
                        icon: Icons.repeat_rounded,
                        label: 'Monthly',
                      ),
                      (
                        value: 'Lump Sum',
                        icon: Icons.payments_rounded,
                        label: 'Lump Sum',
                      ),
                    ])
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _overpayType = tab.value),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            decoration: BoxDecoration(
                              gradient: _overpayType == tab.value
                                  ? const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF9FE6DE),
                                        Color(0xFF0D9488),
                                      ],
                                    )
                                  : null,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  tab.icon,
                                  size: 14,
                                  color: _overpayType == tab.value
                                      ? Colors.white
                                      : AppTheme.textTertiary,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  tab.label,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: _overpayType == tab.value
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: _overpayType == tab.value
                                        ? Colors.white
                                        : AppTheme.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                height: 160,
                child: IndexedStack(
                  index: _overpayType == 'Monthly' ? 0 : 1,
                  children: [
                    // Monthly
                    _buildEditableSliderRow(
                      label: 'Monthly overpayment',
                      controller: _monthlyOverpayCtrl,
                      focusNode: _monthlyOverpayFocus,
                      value: _monthlyOverpay,
                      min: 50,
                      max: 2000,
                      divisions: 39,
                      prefix: '£',
                      onChanged: (v) {
                        setState(() => _monthlyOverpay = v);
                        if (!_monthlyOverpayFocus.hasFocus) {
                          _monthlyOverpayCtrl.text = v.toStringAsFixed(0);
                        }
                      },
                    ),
                    // Lump Sum
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildEditableSliderRow(
                          label: 'Lump sum amount',
                          controller: _lumpSumOverpayCtrl,
                          focusNode: _lumpSumOverpayFocus,
                          value: _lumpSumOverpay,
                          min: 1000,
                          max: 50000,
                          divisions: 49,
                          prefix: '£',
                          onChanged: (v) {
                            setState(() => _lumpSumOverpay = v);
                            if (!_lumpSumOverpayFocus.hasFocus) {
                              _lumpSumOverpayCtrl.text = v.toStringAsFixed(0);
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                        _buildEditableSliderRow(
                          label: 'Month to pay',
                          controller: _lumpSumMonthCtrl,
                          focusNode: _lumpSumMonthFocus,
                          value: _lumpSumMonth
                              .clamp(1, (widget.scenario.termYears * 12).clamp(1, 120))
                              .toDouble(),
                          min: 1,
                          max: (widget.scenario.termYears * 12).clamp(1, 120).toDouble(),
                          divisions: (widget.scenario.termYears * 12).clamp(1, 120) - 1,
                          prefix: '',
                          suffix: '',
                          onChanged: (v) {
                            setState(() => _lumpSumMonth = v.toInt());
                            if (!_lumpSumMonthFocus.hasFocus) {
                              _lumpSumMonthCtrl.text = v.toInt().toString();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.accentGreen.withValues(alpha: 0.07),
                      AppTheme.primaryBlue.withValues(alpha: 0.04),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Column(
                  children: [
                    _buildMetric(
                      'Interest Saved',
                      '£${comparison['interestSaved'].toStringAsFixed(0)}',
                      Icons.trending_down_rounded,
                      AppTheme.accentGreen,
                    ),
                    const SizedBox(height: 12),
                    _buildMetric(
                      'Time Saved',
                      '${comparison['yearsSaved'].toStringAsFixed(0)} yrs  ${(comparison['monthsSaved'] as int) % 12} mo',
                      Icons.access_time_rounded,
                      AppTheme.primaryBlue,
                    ),
                  ],
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
      backgroundColor: Colors.transparent,
      border: const Border(),
      shadows: [],
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
                  Icons.account_balance_wallet_rounded,
                  size: 18,
                  color: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Affordability',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: AppTheme.fontWeightSemiBold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    'How much can you borrow?',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          _buildSliderRow(
            label: 'Annual income',
            displayValue: '£${_formatK(_annualIncome)}',
            value: _annualIncome,
            min: 20000,
            max: 200000,
            divisions: 180,
            onChanged: (v) => setState(() => _annualIncome = v),
          ),
          const SizedBox(height: 8),
          _buildSliderRow(
            label: 'Income multiplier',
            displayValue: '${_incomeMultiplier.toStringAsFixed(1)}×',
            value: _incomeMultiplier,
            min: 3.0,
            max: 5.5,
            divisions: 25,
            onChanged: (v) => setState(() => _incomeMultiplier = v),
          ),
          const SizedBox(height: 8),
          _buildSliderRow(
            label: 'Monthly commitments',
            displayValue: '£${_monthlyCommitments.toStringAsFixed(0)}',
            value: _monthlyCommitments,
            min: 0,
            max: 2000,
            divisions: 40,
            onChanged: (v) => setState(() => _monthlyCommitments = v),
          ),

          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryBlue.withValues(alpha: 0.07),
                  AppTheme.accentGreen.withValues(alpha: 0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              children: [
                _buildMetric(
                  'Max Loan',
                  '£${_formatK(result['maxLoan'] as double)}',
                  Icons.money_rounded,
                  AppTheme.primaryBlue,
                ),
                const SizedBox(height: 12),
                _buildMetric(
                  'Max Property Price',
                  '£${_formatK(result['maxPropertyPrice'] as double)}',
                  Icons.home_rounded,
                  AppTheme.accentGreen,
                ),
                const SizedBox(height: 12),
                _buildMetric(
                  'Monthly Payment',
                  '£${(result['monthlyPayment'] as double).toStringAsFixed(0)}',
                  Icons.payments_rounded,
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
      backgroundColor: Colors.transparent,
      border: const Border(),
      shadows: [],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.accentOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.swap_horiz_rounded,
                  size: 18,
                  color: AppTheme.accentOrange,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Remortgage',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: AppTheme.fontWeightSemiBold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    'Compare your new deal',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          _buildSliderRow(
            label: 'New interest rate',
            displayValue: '${_newRate.toStringAsFixed(1)}%',
            value: _newRate,
            min: 1.0,
            max: 8.0,
            divisions: 70,
            onChanged: (v) => setState(() => _newRate = v),
          ),
          const SizedBox(height: 8),
          _buildSliderRow(
            label: 'Remortgage fees',
            displayValue: '£${_remortgageFees.toStringAsFixed(0)}',
            value: _remortgageFees,
            min: 0,
            max: 5000,
            divisions: 50,
            onChanged: (v) => setState(() => _remortgageFees = v),
          ),

          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              title: Text(
                'Add fees to loan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
              value: _addFeesToLoan,
              activeColor: AppTheme.primaryBlue,
              onChanged: (v) => setState(() => _addFeesToLoan = v),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 0,
              ),
              dense: true,
            ),
          ),

          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.accentOrange.withValues(alpha: 0.07),
                  AppTheme.primaryBlue.withValues(alpha: 0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              children: [
                _buildMetric(
                  'New Monthly Payment',
                  '£${(result['newMonthlyPayment'] as double).toStringAsFixed(0)}',
                  Icons.payments_rounded,
                  AppTheme.primaryBlue,
                ),
                if (result['monthlySaving'] != null) ...[
                  const SizedBox(height: 12),
                  _buildMetric(
                    'Monthly Saving',
                    '£${(result['monthlySaving'] as double).toStringAsFixed(0)}',
                    Icons.savings_rounded,
                    AppTheme.accentGreen,
                  ),
                ],
                if (result['breakEvenMonths'] != null) ...[
                  const SizedBox(height: 12),
                  _buildMetric(
                    'Break-even',
                    '${result['breakEvenMonths']} months',
                    Icons.timeline_rounded,
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

  /// Editable slider row — value shown in a tappable text field (used in overpay)
  Widget _buildEditableSliderRow({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    String prefix = '',
    String suffix = '',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
            IntrinsicWidth(
              child: Container(
                constraints: const BoxConstraints(minWidth: 64),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: focusNode.hasFocus
                        ? AppTheme.primaryBlue.withValues(alpha: 0.5)
                        : AppTheme.borderLight,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (prefix.isNotEmpty)
                      Text(
                        prefix,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    IntrinsicWidth(
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                        onSubmitted: (raw) =>
                            _submitOverpay(raw, min, max, (v) {
                              onChanged(v);
                              controller.text = suffix.isEmpty
                                  ? v.toInt().toString()
                                  : v.toStringAsFixed(0);
                            }),
                      ),
                    ),
                    if (suffix.isNotEmpty)
                      Text(
                        suffix,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textTertiary,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }

  /// Shared styled slider row used across all tool sections
  Widget _buildSliderRow({
    required String label,
    required String displayValue,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
            Text(
              displayValue,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }

  String _formatK(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}m';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}k';
    return v.toStringAsFixed(0);
  }

  Widget _buildMetric(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
