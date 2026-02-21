import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/mortgage_calculation.dart';

class MortgageGraph extends StatefulWidget {
  final List<AmortisationRow> schedule;

  const MortgageGraph({super.key, required this.schedule});

  @override
  State<MortgageGraph> createState() => _MortgageGraphState();
}

class _MortgageGraphState extends State<MortgageGraph> {
  int _selectedView = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildToggle(),
        const SizedBox(height: 20),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: SizedBox(
            key: ValueKey(_selectedView),
            height: 240,
            child: _selectedView == 0
                ? _buildBalanceChart()
                : _buildStackedChart(),
          ),
        ),
        const SizedBox(height: 16),
        _selectedView == 1 ? _buildLegend() : const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildToggle() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: SegmentedButton<int>(
        showSelectedIcon: false,
        segments: const [
          ButtonSegment(value: 0, label: Text('Balance')),
          ButtonSegment(value: 1, label: Text('Principal vs Interest')),
        ],
        selected: {_selectedView},
        onSelectionChanged: (s) => setState(() => _selectedView = s.first),
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppTheme.primaryBlue.withValues(alpha: 0.12);
            }
            return Colors.transparent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppTheme.primaryBlue;
            }
            return AppTheme.textSecondary;
          }),
        ),
      ),
    );
  }

  Widget _buildBalanceChart() {
    final yearlyRows = widget.schedule.where((r) => r.month % 12 == 0).toList();
    final initialBalance = widget.schedule.isNotEmpty
        ? widget.schedule.first.balance + widget.schedule.first.principal
        : 0.0;

    final data = <FlSpot>[
      FlSpot(0, initialBalance),
      ...yearlyRows.map((r) => FlSpot(r.month / 12, r.balance)),
    ];

    final yInterval = initialBalance > 0
        ? (initialBalance / 4).ceilToDouble()
        : 50000.0;

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => AppTheme.primaryBlue,
            tooltipRoundedRadius: 10,
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            getTooltipItems: (spots) => spots.map((spot) {
              return LineTooltipItem(
                'Year ${spot.x.toInt()}\n£${(spot.y / 1000).toStringAsFixed(0)}k remaining',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  height: 1.5,
                ),
              );
            }).toList(),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: yInterval,
          getDrawingHorizontalLine: (value) => FlLine(
            color: AppTheme.borderLight.withValues(alpha: 0.7),
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 52,
              interval: yInterval,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    '£${(value / 1000).toStringAsFixed(0)}k',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppTheme.textTertiary,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.right,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                if (value != value.roundToDouble() || value == 0) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    'Yr ${value.toInt()}',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppTheme.textTertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: data,
            isCurved: true,
            curveSmoothness: 0.3,
            color: AppTheme.primaryBlue,
            barWidth: 2.5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryBlue.withValues(alpha: 0.22),
                  AppTheme.primaryBlue.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStackedChart() {
    final principalData = widget.schedule
        .where((r) => r.month % 12 == 0)
        .map((r) => FlSpot(r.month / 12, r.principal))
        .toList();
    final interestData = widget.schedule
        .where((r) => r.month % 12 == 0)
        .map((r) => FlSpot(r.month / 12, r.interest))
        .toList();

    final allVals = [...principalData, ...interestData].map((s) => s.y);
    final maxY = allVals.isNotEmpty
        ? allVals.reduce((a, b) => a > b ? a : b)
        : 2000.0;
    final yInterval = maxY > 0 ? (maxY / 4).ceilToDouble() : 500.0;

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (spot) => spot.barIndex == 0
                ? AppTheme.graphPrincipal
                : AppTheme.graphInterest,
            tooltipRoundedRadius: 10,
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            getTooltipItems: (spots) => spots.map((spot) {
              final label = spot.barIndex == 0 ? 'Principal' : 'Interest';
              return LineTooltipItem(
                '$label\n£${spot.y.toStringAsFixed(0)}/mo',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  height: 1.5,
                ),
              );
            }).toList(),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: yInterval,
          getDrawingHorizontalLine: (value) => FlLine(
            color: AppTheme.borderLight.withValues(alpha: 0.7),
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 52,
              interval: yInterval,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    '£${value.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppTheme.textTertiary,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.right,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                if (value != value.roundToDouble() || value == 0) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    'Yr ${value.toInt()}',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppTheme.textTertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: principalData,
            isCurved: true,
            curveSmoothness: 0.3,
            color: AppTheme.graphPrincipal,
            barWidth: 2.5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppTheme.graphPrincipal.withValues(alpha: 0.22),
                  AppTheme.graphPrincipal.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          LineChartBarData(
            spots: interestData,
            isCurved: true,
            curveSmoothness: 0.3,
            color: AppTheme.graphInterest,
            barWidth: 2.5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppTheme.graphInterest.withValues(alpha: 0.22),
                  AppTheme.graphInterest.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendChip(AppTheme.graphPrincipal, 'Principal'),
        const SizedBox(width: 20),
        _buildLegendChip(AppTheme.graphInterest, 'Interest'),
      ],
    );
  }

  Widget _buildLegendChip(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class AmortisationTable extends StatefulWidget {
  final List<AmortisationRow> schedule;

  const AmortisationTable({super.key, required this.schedule});

  @override
  State<AmortisationTable> createState() => _AmortisationTableState();
}

class _AmortisationTableState extends State<AmortisationTable> {
  bool showMonthly = true;

  @override
  Widget build(BuildContext context) {
    final displayData = showMonthly ? widget.schedule : _getYearlySummary();

    return Column(
      children: [
        // Toggle selector
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(4),
          margin: const EdgeInsets.only(bottom: 16),
          child: SegmentedButton<bool>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: true, label: Text('Monthly')),
              ButtonSegment(value: false, label: Text('Yearly')),
            ],
            selected: {showMonthly},
            onSelectionChanged: (Set<bool> newSelection) {
              setState(() {
                showMonthly = newSelection.first;
              });
            },
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.primaryBlue.withValues(alpha: 0.12);
                }
                return Colors.transparent;
              }),
            ),
          ),
        ),

        // Header row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withValues(alpha: 0.1),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  showMonthly ? 'Month' : 'Year',
                  style: TextStyle(
                    fontWeight: AppTheme.fontWeightSemiBold,
                    fontSize: 13,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Payment',
                  style: TextStyle(
                    fontWeight: AppTheme.fontWeightSemiBold,
                    fontSize: 13,
                    color: AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Interest',
                  style: TextStyle(
                    fontWeight: AppTheme.fontWeightSemiBold,
                    fontSize: 13,
                    color: AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Principal',
                  style: TextStyle(
                    fontWeight: AppTheme.fontWeightSemiBold,
                    fontSize: 13,
                    color: AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Balance',
                  style: TextStyle(
                    fontWeight: AppTheme.fontWeightSemiBold,
                    fontSize: 13,
                    color: AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),

        // Data rows
        Container(
          height: 500,
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.borderLight, width: 1),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(12),
            ),
          ),
          child: ListView.builder(
            itemCount: displayData.length,
            itemBuilder: (context, index) {
              final row = displayData[index];
              final isEven = index % 2 == 0;

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isEven
                      ? AppTheme.backgroundWhite
                      : AppTheme.surfaceLight,
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.borderLight.withValues(alpha: 0.5),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${row.month}',
                          style: TextStyle(
                            fontWeight: AppTheme.fontWeightMedium,
                            fontSize: 13,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        '£${row.payment.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        '£${row.interest.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        '£${row.principal.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        '£${row.balance.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: AppTheme.fontWeightMedium,
                          color: AppTheme.primaryBlue,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<AmortisationRow> _getYearlySummary() {
    final List<AmortisationRow> yearly = [];

    for (int year = 1; year <= widget.schedule.length ~/ 12; year++) {
      final startIdx = (year - 1) * 12;
      final endIdx = year * 12;

      double totalPayment = 0;
      double totalInterest = 0;
      double totalPrincipal = 0;

      for (int i = startIdx; i < endIdx && i < widget.schedule.length; i++) {
        totalPayment += widget.schedule[i].payment;
        totalInterest += widget.schedule[i].interest;
        totalPrincipal += widget.schedule[i].principal;
      }

      yearly.add(
        AmortisationRow(
          month: year,
          payment: totalPayment,
          interest: totalInterest,
          principal: totalPrincipal,
          balance: widget.schedule[endIdx - 1].balance,
        ),
      );
    }

    return yearly;
  }
}
