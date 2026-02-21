import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/services/mortgage_scenario.dart';
import '../../domain/services/rent_buy_calculator.dart';
import '../widgets/surface_card.dart';

class RentVsBuyTab extends StatefulWidget {
  final MortgageScenario scenario;

  const RentVsBuyTab({super.key, required this.scenario});

  @override
  State<RentVsBuyTab> createState() => _RentVsBuyTabState();
}

class _RentVsBuyTabState extends State<RentVsBuyTab> {
  double _monthlyRent = 1200;
  double _annualRentIncrease = 3.0;
  double _housePriceGrowth = 2.5;
  double _investmentReturn = 5.0;
  int _horizonYears = 10;
  double _buyingCosts = 3000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.scenario,
          builder: (context, _) {
            final calc = widget.scenario.calculation;

            if (calc == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final results = RentBuyCalculator.calculate(
              monthlyRent: _monthlyRent,
              annualRentIncrease: _annualRentIncrease,
              horizonYears: _horizonYears,
              monthlyMortgagePayment: calc.monthlyPayment,
              propertyPrice: calc.propertyPrice,
              deposit: calc.deposit,
              stampDuty: calc.stampDuty,
              loanAmount: calc.loanAmount,
              mortgageTermYears: widget.scenario.termYears,
              housePriceGrowth: _housePriceGrowth,
              investmentReturn: _investmentReturn,
              buyingCosts: _buyingCosts,
            );

            final isBuyCheaper = results['difference'] > 0;
            final accentColor =
                isBuyCheaper ? AppTheme.accentGreen : AppTheme.accentOrange;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──────────────────────────────────────────
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.balance_rounded,
                          size: 22,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rent vs Buy',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            '$_horizonYears-year analysis',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Verdict card ────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accentColor.withValues(alpha: 0.12),
                          accentColor.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.25),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isBuyCheaper
                                  ? Icons.home_rounded
                                  : Icons.apartment_rounded,
                              color: accentColor,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isBuyCheaper
                                  ? 'Buying is cheaper'
                                  : 'Renting is cheaper',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: accentColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '£${_fmt(results['difference'].abs())}',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            color: accentColor,
                            letterSpacing: -1,
                          ),
                        ),
                        Text(
                          'net difference over $_horizonYears years',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        if (results['breakEvenYear'] != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.primaryBlue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.timeline_rounded,
                                  color: AppTheme.primaryBlue,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Buying breaks even at Year ${results['breakEvenYear']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryBlue,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Stat chips ──────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatChip(
                          'Rent Cost',
                          '£${_fmtK(results['totalRentCost'])}',
                          AppTheme.accentOrange,
                          Icons.key_rounded,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatChip(
                          'Buy Cost',
                          '£${_fmtK(results['totalBuyCost'])}',
                          AppTheme.accentGreen,
                          Icons.home_rounded,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatChip(
                          'Future Value',
                          '£${_fmtK(results['futurePropertyValue'])}',
                          AppTheme.primaryBlue,
                          Icons.trending_up_rounded,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ── Chart ───────────────────────────────────────────
                  SurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cumulative Cost',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'How costs accumulate over time',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 220,
                          child: _buildChart(results),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildLegendChip(AppTheme.accentOrange, 'Renting'),
                            const SizedBox(width: 24),
                            _buildLegendChip(AppTheme.accentGreen, 'Buying'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Detailed breakdown ──────────────────────────────
                  SurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Detailed Breakdown',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildBreakdownRow(
                          Icons.key_rounded,
                          'Total Rent Cost',
                          '£${_fmt(results['totalRentCost'])}',
                          AppTheme.accentOrange,
                        ),
                        _buildDivider(),
                        _buildBreakdownRow(
                          Icons.home_rounded,
                          'Total Buy Cost',
                          '£${_fmt(results['totalBuyCost'])}',
                          AppTheme.accentGreen,
                        ),
                        _buildDivider(),
                        _buildBreakdownRow(
                          Icons.show_chart_rounded,
                          'Opportunity Cost',
                          '£${_fmt(results['opportunityCost'])}',
                          AppTheme.textSecondary,
                        ),
                        _buildDivider(),
                        _buildBreakdownRow(
                          Icons.trending_up_rounded,
                          'Equity Gained',
                          '£${_fmt(results['equityGained'])}',
                          AppTheme.primaryBlue,
                        ),
                        _buildDivider(),
                        _buildBreakdownRow(
                          Icons.apartment_rounded,
                          'Future Property Value',
                          '£${_fmt(results['futurePropertyValue'])}',
                          AppTheme.primaryBlue,
                          bold: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Assumptions header ──────────────────────────────
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 12),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.tune_rounded,
                          size: 18,
                          color: AppTheme.textSecondary,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Assumptions',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Sliders ─────────────────────────────────────────
                  SurfaceCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildSlider(
                          icon: Icons.key_rounded,
                          label: 'Monthly Rent',
                          value: _monthlyRent,
                          min: 500,
                          max: 5000,
                          divisions: 90,
                          valueFormatter: (v) => '£${v.toStringAsFixed(0)}',
                          onChanged: (v) => setState(() => _monthlyRent = v),
                        ),
                        _buildSliderDivider(),
                        _buildSlider(
                          icon: Icons.arrow_upward_rounded,
                          label: 'Annual Rent Increase',
                          value: _annualRentIncrease,
                          min: 0,
                          max: 10,
                          divisions: 100,
                          valueFormatter: (v) => '${v.toStringAsFixed(1)}%',
                          onChanged: (v) =>
                              setState(() => _annualRentIncrease = v),
                        ),
                        _buildSliderDivider(),
                        _buildSlider(
                          icon: Icons.home_work_rounded,
                          label: 'House Price Growth',
                          value: _housePriceGrowth,
                          min: -5,
                          max: 15,
                          divisions: 100,
                          valueFormatter: (v) => '${v.toStringAsFixed(1)}%',
                          onChanged: (v) =>
                              setState(() => _housePriceGrowth = v),
                        ),
                        _buildSliderDivider(),
                        _buildSlider(
                          icon: Icons.account_balance_rounded,
                          label: 'Investment Return',
                          value: _investmentReturn,
                          min: 0,
                          max: 15,
                          divisions: 150,
                          valueFormatter: (v) => '${v.toStringAsFixed(1)}%',
                          onChanged: (v) =>
                              setState(() => _investmentReturn = v),
                        ),
                        _buildSliderDivider(),
                        _buildSlider(
                          icon: Icons.calendar_today_rounded,
                          label: 'Time Horizon',
                          value: _horizonYears.toDouble(),
                          min: 1,
                          max: 30,
                          divisions: 29,
                          valueFormatter: (v) => '${v.toInt()} yrs',
                          onChanged: (v) =>
                              setState(() => _horizonYears = v.toInt()),
                        ),
                        _buildSliderDivider(),
                        _buildSlider(
                          icon: Icons.receipt_long_rounded,
                          label: 'Buying Costs',
                          value: _buyingCosts,
                          min: 1000,
                          max: 10000,
                          divisions: 18,
                          valueFormatter: (v) => '£${v.toStringAsFixed(0)}',
                          onChanged: (v) => setState(() => _buyingCosts = v),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  String _fmt(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(2)}m';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}k';
    return v.toStringAsFixed(0);
  }

  String _fmtK(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}m';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}k';
    return v.toStringAsFixed(0);
  }

  Widget _buildStatChip(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.18), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
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

  Widget _buildChart(Map<String, dynamic> results) {
    final rentSpots =
        _generateSpots(results['yearlyRentCosts'] as List<double>);
    final buySpots =
        _generateSpots(results['yearlyBuyCosts'] as List<double>);

    final allY = [...rentSpots, ...buySpots].map((s) => s.y);
    final maxY = allY.isNotEmpty
        ? allY.reduce((a, b) => a > b ? a : b)
        : 100000.0;
    final yInterval = (maxY / 4).ceilToDouble();

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (spot) => spot.barIndex == 0
                ? AppTheme.accentOrange
                : AppTheme.accentGreen,
            tooltipRoundedRadius: 10,
            tooltipPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            getTooltipItems: (spots) => spots.map((spot) {
              final label = spot.barIndex == 0 ? 'Renting' : 'Buying';
              return LineTooltipItem(
                '$label (Yr ${spot.x.toInt()})\n£${_fmtK(spot.y)}',
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
                    '£${_fmtK(value)}',
                    style: const TextStyle(
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
                if (value != value.roundToDouble()) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    'Yr ${value.toInt()}',
                    style: const TextStyle(
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
            spots: rentSpots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: AppTheme.accentOrange,
            barWidth: 2.5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppTheme.accentOrange.withValues(alpha: 0.18),
                  AppTheme.accentOrange.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          LineChartBarData(
            spots: buySpots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: AppTheme.accentGreen,
            barWidth: 2.5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppTheme.accentGreen.withValues(alpha: 0.18),
                  AppTheme.accentGreen.withValues(alpha: 0.0),
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

  List<FlSpot> _generateSpots(List<double> yearly) {
    double cumulative = 0;
    return List.generate(yearly.length, (i) {
      cumulative += yearly[i];
      return FlSpot((i + 1).toDouble(), cumulative);
    });
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
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownRow(
    IconData icon,
    String label,
    String value,
    Color color, {
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              color: color,
              fontSize: bold ? 16 : 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => Divider(
        height: 1,
        color: AppTheme.borderLight.withValues(alpha: 0.6),
      );

  Widget _buildSliderDivider() => Divider(
        height: 24,
        color: AppTheme.borderLight.withValues(alpha: 0.5),
      );

  Widget _buildSlider({
    required IconData icon,
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String Function(double) valueFormatter,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppTheme.textTertiary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              valueFormatter(value),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryBlue,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            thumbRadius: 10,
            overlayRadius: 18,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            activeColor: AppTheme.primaryBlue,
            inactiveColor: AppTheme.borderLight,
          ),
        ),
      ],
    );
  }
}


          if (calc == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final results = RentBuyCalculator.calculate(
            monthlyRent: _monthlyRent,
            annualRentIncrease: _annualRentIncrease,
            horizonYears: _horizonYears,
            monthlyMortgagePayment: calc.monthlyPayment,
            propertyPrice: calc.propertyPrice,
            deposit: calc.deposit,
            stampDuty: calc.stampDuty,
            loanAmount: calc.loanAmount,
            mortgageTermYears: widget.scenario.termYears,
            housePriceGrowth: _housePriceGrowth,
            investmentReturn: _investmentReturn,
            buyingCosts: _buyingCosts,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Comparison summary card
                Card(
                  color: results['difference'] > 0
                      ? AppTheme.accentGreen.withValues(alpha: 0.1)
                      : AppTheme.warning.withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          results['difference'] > 0
                              ? 'Buying is cheaper'
                              : 'Renting is cheaper',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: results['difference'] > 0
                                    ? AppTheme.accentGreen
                                    : AppTheme.warning,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'by £${results['difference'].abs().toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: results['difference'] > 0
                                    ? AppTheme.accentGreen
                                    : AppTheme.warning,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'over $_horizonYears years',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppTheme.textSecondary),
                        ),
                        if (results['breakEvenYear'] != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.timeline,
                                  color: AppTheme.primaryBlue,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Break-even: Year ${results['breakEvenYear']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Chart
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cumulative Cost Comparison',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 250,
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                              ),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 60,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        '£${(value / 1000).toStringAsFixed(0)}k',
                                        style: const TextStyle(fontSize: 10),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        'Y${value.toInt()}',
                                        style: const TextStyle(fontSize: 10),
                                      );
                                    },
                                  ),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(show: true),
                              lineBarsData: [
                                // Rent line
                                LineChartBarData(
                                  spots: _generateSpots(
                                    results['yearlyRentCosts'],
                                  ),
                                  color: AppTheme.warning,
                                  barWidth: 3,
                                  dotData: FlDotData(show: false),
                                ),
                                // Buy line
                                LineChartBarData(
                                  spots: _generateSpots(
                                    results['yearlyBuyCosts'],
                                  ),
                                  color: AppTheme.accentGreen,
                                  barWidth: 3,
                                  dotData: FlDotData(show: false),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildLegend('Rent', AppTheme.warning),
                            const SizedBox(width: 24),
                            _buildLegend('Buy', AppTheme.accentGreen),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'Assumptions',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 16),

                _buildSliderCard(
                  label: 'Monthly Rent',
                  value: _monthlyRent,
                  min: 500,
                  max: 5000,
                  divisions: 90,
                  valueFormatter: (v) => '£${v.toStringAsFixed(0)}',
                  onChanged: (v) => setState(() => _monthlyRent = v),
                ),

                const SizedBox(height: 12),

                _buildSliderCard(
                  label: 'Annual Rent Increase',
                  value: _annualRentIncrease,
                  min: 0,
                  max: 10,
                  divisions: 100,
                  valueFormatter: (v) => '${v.toStringAsFixed(1)}%',
                  onChanged: (v) => setState(() => _annualRentIncrease = v),
                ),

                const SizedBox(height: 12),

                _buildSliderCard(
                  label: 'House Price Growth',
                  value: _housePriceGrowth,
                  min: -5,
                  max: 15,
                  divisions: 100,
                  valueFormatter: (v) => '${v.toStringAsFixed(1)}%',
                  onChanged: (v) => setState(() => _housePriceGrowth = v),
                ),

                const SizedBox(height: 12),

                _buildSliderCard(
                  label: 'Investment Return (if not buying)',
                  value: _investmentReturn,
                  min: 0,
                  max: 15,
                  divisions: 150,
                  valueFormatter: (v) => '${v.toStringAsFixed(1)}%',
                  onChanged: (v) => setState(() => _investmentReturn = v),
                ),

                const SizedBox(height: 12),

                _buildSliderCard(
                  label: 'Time Horizon (years)',
                  value: _horizonYears.toDouble(),
                  min: 1,
                  max: 30,
                  divisions: 29,
                  valueFormatter: (v) => '${v.toInt()} years',
                  onChanged: (v) => setState(() => _horizonYears = v.toInt()),
                ),

                const SizedBox(height: 12),

                _buildSliderCard(
                  label: 'Buying Costs (legal, survey, etc.)',
                  value: _buyingCosts,
                  min: 1000,
                  max: 10000,
                  divisions: 18,
                  valueFormatter: (v) => '£${v.toStringAsFixed(0)}',
                  onChanged: (v) => setState(() => _buyingCosts = v),
                ),

                const SizedBox(height: 24),

                // Detailed breakdown
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detailed Breakdown',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 20),

                        _buildBreakdownRow(
                          'Total Rent Cost',
                          '£${results['totalRentCost'].toStringAsFixed(0)}',
                          AppTheme.warning,
                        ),
                        const Divider(height: 24),

                        _buildBreakdownRow(
                          'Total Buy Cost',
                          '£${results['totalBuyCost'].toStringAsFixed(0)}',
                          AppTheme.accentGreen,
                        ),
                        const Divider(height: 24),

                        _buildBreakdownRow(
                          'Opportunity Cost (foregone investment)',
                          '£${results['opportunityCost'].toStringAsFixed(0)}',
                          AppTheme.accentOrange,
                        ),
                        const Divider(height: 24),

                        _buildBreakdownRow(
                          'Equity Gained (property appreciation)',
                          '£${results['equityGained'].toStringAsFixed(0)}',
                          AppTheme.primaryBlue,
                        ),
                        const Divider(height: 24),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              _buildBreakdownRow(
                                'Future Property Value',
                                '£${results['futurePropertyValue'].toStringAsFixed(0)}',
                                AppTheme.primaryBlue,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

  List<FlSpot> _generateSpots(List<double> yearly) {
    double cumulative = 0;
    return List.generate(yearly.length, (index) {
      cumulative += yearly[index];
      return FlSpot(index.toDouble() + 1, cumulative);
    });
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(width: 20, height: 3, color: color),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  Widget _buildBreakdownRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(label, style: TextStyle(color: AppTheme.textSecondary)),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildSliderCard({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String Function(double) valueFormatter,
    required ValueChanged<double> onChanged,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  valueFormatter(value),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlue,
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
              activeColor: AppTheme.primaryBlue,
            ),
          ],
        ),
      ),
    );
  }
}
