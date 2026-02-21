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
  int _chartMode = 0; // 0 = cumulative cost, 1 = net position

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
              interestRate: widget.scenario.interestRate,
              housePriceGrowth: _housePriceGrowth,
              investmentReturn: _investmentReturn,
              buyingCosts: _buyingCosts,
            );

            final isBuyCheaper = results['difference'] > 0;
            final accentColor = isBuyCheaper
                ? AppTheme.accentGreen
                : AppTheme.accentOrange;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildVerdictBanner(results, isBuyCheaper, accentColor),
                  const SizedBox(height: 12),
                  _buildMetricsStrip(results),
                  const SizedBox(height: 14),
                  _buildChartCard(results),
                  const SizedBox(height: 14),
                  _buildBreakdownCard(results),
                  const SizedBox(height: 14),
                  _buildAssumptionsSection(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  //  Header

  Widget _buildHeader() {
    return Row(
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
                letterSpacing: -0.5,
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
    );
  }

  //  Verdict banner

  Widget _buildVerdictBanner(
    Map<String, dynamic> results,
    bool isBuyCheaper,
    Color accentColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentColor.withValues(alpha: 0.13),
            accentColor.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.22),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isBuyCheaper ? Icons.home_rounded : Icons.apartment_rounded,
              color: accentColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBuyCheaper ? 'Buying is cheaper' : 'Renting is cheaper',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'over $_horizonYears years',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\u00a3${_fmtK(results['difference'].abs())}',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                  letterSpacing: -0.5,
                ),
              ),
              if (results['breakEvenYear'] != null)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.timeline_rounded,
                        color: AppTheme.primaryBlue,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Break-even Yr ${results['breakEvenYear']}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  //  Metrics strip

  Widget _buildMetricsStrip(Map<String, dynamic> results) {
    return Row(
      children: [
        Expanded(
          child: _metricTile(
            'Rent Total',
            '\u00a3${_fmtK(results['totalRentCost'])}',
            AppTheme.accentOrange,
            Icons.key_rounded,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _metricTile(
            'Buy Total',
            '\u00a3${_fmtK(results['totalBuyCost'])}',
            AppTheme.accentGreen,
            Icons.home_rounded,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _metricTile(
            'Property',
            '\u00a3${_fmtK(results['futurePropertyValue'])}',
            AppTheme.primaryBlue,
            Icons.trending_up_rounded,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _metricTile(
            'Equity',
            '\u00a3${_fmtK(results['equityGained'])}',
            AppTheme.accentIndigo,
            Icons.account_balance_rounded,
          ),
        ),
      ],
    );
  }

  Widget _metricTile(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  //  Chart card

  Widget _buildChartCard(Map<String, dynamic> results) {
    return SurfaceCard(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cumulative Cost',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _chartMode == 0
                          ? 'Total outgoings over time'
                          : 'Net financial position',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _buildChartToggle(),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 210,
            child: _chartMode == 0
                ? _buildCumulativeChart(results)
                : _buildNetChart(results),
          ),
          const SizedBox(height: 12),
          if (_chartMode == 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendChip(AppTheme.accentOrange, 'Renting'),
                const SizedBox(width: 20),
                _buildLegendChip(AppTheme.accentGreen, 'Buying'),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildChartToggle() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _togglePill(0, Icons.stacked_line_chart_rounded, 'Cost'),
          _togglePill(1, Icons.area_chart_rounded, 'Net'),
        ],
      ),
    );
  }

  Widget _togglePill(int index, IconData icon, String label) {
    final selected = _chartMode == index;
    return GestureDetector(
      onTap: () => setState(() => _chartMode = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: selected ? Colors.white : AppTheme.textTertiary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppTheme.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  Breakdown card

  Widget _buildBreakdownCard(Map<String, dynamic> results) {
    return SurfaceCard(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detailed Breakdown',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildBreakdownGrid([
            _BreakdownItem(
              Icons.key_rounded,
              'Total Rent Cost',
              '\u00a3${_fmt(results['totalRentCost'])}',
              AppTheme.accentOrange,
            ),
            _BreakdownItem(
              Icons.home_rounded,
              'Total Buy Cost',
              '\u00a3${_fmt(results['totalBuyCost'])}',
              AppTheme.accentGreen,
            ),
            _BreakdownItem(
              Icons.show_chart_rounded,
              'Renter Inv. Gains',
              '+\u00a3${_fmt(results['investmentGains'])}',
              AppTheme.accentGreen,
            ),
            _BreakdownItem(
              Icons.account_balance_rounded,
              'Equity at Horizon',
              '\u00a3${_fmt(results['equityGained'])}',
              AppTheme.primaryBlue,
            ),
          ]),
          const SizedBox(height: 12),
          Divider(
            height: 1,
            color: AppTheme.borderLight.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 12),
          _buildHighlightRow(
            Icons.apartment_rounded,
            'Future Property Value',
            '\u00a3${_fmt(results['futurePropertyValue'])}',
            AppTheme.primaryBlue,
          ),
          const SizedBox(height: 10),
          _buildHighlightRow(
            Icons.credit_card_rounded,
            'Remaining Mortgage',
            '\u00a3${_fmt(results['remainingBalance'])}',
            AppTheme.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownGrid(List<_BreakdownItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: item.color.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: item.color.withValues(alpha: 0.14),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(item.icon, size: 15, color: item.color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppTheme.textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.value,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: item.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHighlightRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 15, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  //  Assumptions section

  Widget _buildAssumptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.tune_rounded, size: 16, color: AppTheme.textSecondary),
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
        const SizedBox(height: 12),
        _buildSliderGroup(
          label: 'Renting',
          icon: Icons.key_rounded,
          color: AppTheme.accentOrange,
          children: [
            _buildSliderRow(
              label: 'Monthly Rent',
              displayValue: '\u00a3${_monthlyRent.toStringAsFixed(0)}',
              value: _monthlyRent,
              min: 500,
              max: 5000,
              divisions: 90,
              onChanged: (v) => setState(() => _monthlyRent = v),
            ),
            _dividerLine(),
            _buildSliderRow(
              label: 'Annual Rent Increase',
              displayValue: '${_annualRentIncrease.toStringAsFixed(1)}%',
              value: _annualRentIncrease,
              min: 0,
              max: 10,
              divisions: 100,
              onChanged: (v) => setState(() => _annualRentIncrease = v),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildSliderGroup(
          label: 'Property',
          icon: Icons.home_rounded,
          color: AppTheme.accentGreen,
          children: [
            _buildSliderRow(
              label: 'House Price Growth',
              displayValue: '${_housePriceGrowth.toStringAsFixed(1)}%',
              value: _housePriceGrowth,
              min: -5,
              max: 15,
              divisions: 100,
              onChanged: (v) => setState(() => _housePriceGrowth = v),
            ),
            _dividerLine(),
            _buildSliderRow(
              label: 'Buying Costs',
              displayValue: '\u00a3${_buyingCosts.toStringAsFixed(0)}',
              value: _buyingCosts,
              min: 1000,
              max: 10000,
              divisions: 18,
              onChanged: (v) => setState(() => _buyingCosts = v),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildSliderGroup(
          label: 'Financial',
          icon: Icons.account_balance_rounded,
          color: AppTheme.primaryBlue,
          children: [
            _buildSliderRow(
              label: 'Investment Return',
              displayValue: '${_investmentReturn.toStringAsFixed(1)}%',
              value: _investmentReturn,
              min: 0,
              max: 15,
              divisions: 150,
              onChanged: (v) => setState(() => _investmentReturn = v),
            ),
            _dividerLine(),
            _buildSliderRow(
              label: 'Time Horizon',
              displayValue: '$_horizonYears yrs',
              value: _horizonYears.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              onChanged: (v) => setState(() => _horizonYears = v.toInt()),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSliderGroup({
    required String label,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.06),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(17),
              ),
              border: Border(
                bottom: BorderSide(
                  color: color.withValues(alpha: 0.12),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 14, color: color),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

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
      children: [
        const SizedBox(height: 10),
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
            Text(
              displayValue,
              style: const TextStyle(
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
        const SizedBox(height: 2),
      ],
    );
  }

  Widget _dividerLine() =>
      Divider(height: 1, color: AppTheme.borderLight.withValues(alpha: 0.6));

  //  Charts

  Widget _buildCumulativeChart(Map<String, dynamic> results) {
    final rentSpots = _cumSpots(results['yearlyRentCosts'] as List<double>);
    final buySpots = _cumSpots(results['yearlyBuyCosts'] as List<double>);
    return _baseLineChart(
      bars: [
        _lineBar(rentSpots, AppTheme.accentOrange),
        _lineBar(buySpots, AppTheme.accentGreen),
      ],
      tooltipLabels: ['Renting', 'Buying'],
      tooltipColors: [AppTheme.accentOrange, AppTheme.accentGreen],
    );
  }

  Widget _buildNetChart(Map<String, dynamic> results) {
    final rentYearly = results['yearlyRentCosts'] as List<double>;
    final buyYearly = results['yearlyBuyCosts'] as List<double>;
    double rentCum = 0, buyCum = 0;
    final netSpots = <FlSpot>[];
    for (int i = 0; i < rentYearly.length; i++) {
      rentCum += rentYearly[i];
      buyCum += buyYearly[i];
      netSpots.add(FlSpot((i + 1).toDouble(), rentCum - buyCum));
    }
    final hasNegative = netSpots.any((s) => s.y < 0);
    final hasPositive = netSpots.any((s) => s.y > 0);
    final lineColor = hasPositive && !hasNegative
        ? AppTheme.accentGreen
        : AppTheme.primaryBlue;
    return _baseLineChart(
      bars: [_lineBar(netSpots, lineColor)],
      tooltipLabels: ['Saving (Buy)'],
      tooltipColors: [lineColor],
      showZeroLine: true,
    );
  }

  Widget _baseLineChart({
    required List<LineChartBarData> bars,
    required List<String> tooltipLabels,
    required List<Color> tooltipColors,
    bool showZeroLine = false,
  }) {
    final allY = bars.expand((b) => b.spots.map((s) => s.y)).toList();
    if (allY.isEmpty) return const SizedBox.shrink();
    final maxY = allY.reduce((a, b) => a > b ? a : b);
    final minY = allY.reduce((a, b) => a < b ? a : b);
    final range = (maxY - minY).abs();
    final yInterval = range > 0 ? (range / 4).abs() : 10000.0;

    return LineChart(
      LineChartData(
        minY: minY < 0 ? minY * 1.15 : 0,
        maxY: maxY * 1.12,
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (spot) =>
                tooltipColors[spot.barIndex % tooltipColors.length],
            tooltipRoundedRadius: 10,
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            getTooltipItems: (spots) => spots.map((spot) {
              final label = tooltipLabels[spot.barIndex % tooltipLabels.length];
              return LineTooltipItem(
                '$label (Yr ${spot.x.toInt()})\n\u00a3${_fmtK(spot.y.abs())}',
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
            color: value == 0 && showZeroLine
                ? AppTheme.textTertiary.withValues(alpha: 0.5)
                : AppTheme.borderLight.withValues(alpha: 0.7),
            strokeWidth: value == 0 && showZeroLine ? 1.5 : 1,
            dashArray: value == 0 && showZeroLine ? null : [5, 5],
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              interval: yInterval,
              getTitlesWidget: (value, meta) {
                if (value == meta.min || value == meta.max) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    '\u00a3${_fmtK(value)}',
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
              reservedSize: 26,
              getTitlesWidget: (value, meta) {
                if (value != value.roundToDouble())
                  return const SizedBox.shrink();
                final y = value.toInt();
                if (y < 1) return const SizedBox.shrink();
                final step = _horizonYears > 15 ? 5 : 2;
                if (y % step != 0 && y != 1 && y != _horizonYears) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    'Yr $y',
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
        lineBarsData: bars,
      ),
    );
  }

  LineChartBarData _lineBar(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.35,
      color: color,
      barWidth: 2.5,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.16), color.withValues(alpha: 0.0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  List<FlSpot> _cumSpots(List<double> yearly) {
    double cum = 0;
    return List.generate(yearly.length, (i) {
      cum += yearly[i];
      return FlSpot((i + 1).toDouble(), cum);
    });
  }

  //  Legend

  Widget _buildLegendChip(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 22,
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

  //  Formatters

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
}

//  Data class

class _BreakdownItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _BreakdownItem(this.icon, this.label, this.value, this.color);
}
