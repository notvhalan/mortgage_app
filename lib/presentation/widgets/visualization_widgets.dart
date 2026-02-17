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
  bool showBalance = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('Balance')),
              ButtonSegment(value: false, label: Text('Principal vs Interest')),
            ],
            selected: {showBalance},
            onSelectionChanged: (Set<bool> newSelection) {
              setState(() {
                showBalance = newSelection.first;
              });
            },
          ),
        ),
        SizedBox(
          height: 250,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: showBalance ? _buildBalanceChart() : _buildStackedChart(),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceChart() {
    final data = widget.schedule
        .where((row) => row.month % 12 == 0) // Show yearly
        .map((row) => FlSpot(row.month / 12, row.balance))
        .toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 50000,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.withValues(alpha: 0.2), strokeWidth: 1);
          },
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
                  '${value.toInt()}y',
                  style: const TextStyle(fontSize: 10),
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
            color: AppTheme.primaryBlue,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStackedChart() {
    final principalData = widget.schedule
        .where((row) => row.month % 12 == 0)
        .map((row) => FlSpot(row.month / 12, row.principal))
        .toList();

    final interestData = widget.schedule
        .where((row) => row.month % 12 == 0)
        .map((row) => FlSpot(row.month / 12, row.interest))
        .toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.withValues(alpha: 0.2), strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  '£${value.toStringAsFixed(0)}',
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
                  '${value.toInt()}y',
                  style: const TextStyle(fontSize: 10),
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
            color: AppTheme.graphPrincipal,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.graphPrincipal.withValues(alpha: 0.3),
            ),
          ),
          LineChartBarData(
            spots: interestData,
            isCurved: true,
            color: AppTheme.graphInterest,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.graphInterest.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SegmentedButton<bool>(
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
          ),
        ),
        SizedBox(
          height: 400,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                headingRowColor: WidgetStateProperty.all(
                  AppTheme.primaryBlue.withValues(alpha: 0.1),
                ),
                columns: [
                  DataColumn(label: Text(showMonthly ? 'Month' : 'Year')),
                  const DataColumn(label: Text('Payment')),
                  const DataColumn(label: Text('Interest')),
                  const DataColumn(label: Text('Principal')),
                  const DataColumn(label: Text('Balance')),
                ],
                rows: displayData.map((row) {
                  return DataRow(
                    cells: [
                      DataCell(Text('${row.month}')),
                      DataCell(Text('£${row.payment.toStringAsFixed(2)}')),
                      DataCell(Text('£${row.interest.toStringAsFixed(2)}')),
                      DataCell(Text('£${row.principal.toStringAsFixed(2)}')),
                      DataCell(Text('£${row.balance.toStringAsFixed(2)}')),
                    ],
                  );
                }).toList(),
              ),
            ),
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
