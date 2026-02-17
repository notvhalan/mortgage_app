import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/services/mortgage_scenario.dart';

class RentVsBuyTab extends StatefulWidget {
  final MortgageScenario scenario;
  
  const RentVsBuyTab({
    super.key,
    required this.scenario,
  });
  
  @override
  State<RentVsBuyTab> createState() => _RentVsBuyTabState();
}

class _RentVsBuyTabState extends State<RentVsBuyTab> {
  double _monthlyRent = 1200;
  double _annualRentIncrease = 3.0;
  double _housePriceGrowth = 2.5;
  double _investmentReturn = 5.0;
  int _horizonYears = 10;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rent vs Buy'),
      ),
      body: ListenableBuilder(
        listenable: widget.scenario,
        builder: (context, _) {
          final calc = widget.scenario.calculation;
          
          if (calc == null) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final results = _calculateComparison(calc);
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Using mortgage scenario card
                Card(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.home,
                              color: AppTheme.primaryBlue,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Using mortgage from Calculator',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '£${calc.monthlyPayment.toStringAsFixed(0)}/month for ${widget.scenario.termYears} years',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Rent assumptions
                Text(
                  'Rent Assumptions',
                  style: Theme.of(context).textTheme.headlineMedium,
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
                  label: 'Time Horizon',
                  value: _horizonYears.toDouble(),
                  min: 1,
                  max: 30,
                  divisions: 29,
                  valueFormatter: (v) => '${v.toStringAsFixed(0)} years',
                  onChanged: (v) => setState(() => _horizonYears = v.toInt()),
                ),
                
                const SizedBox(height: 32),
                
                // Results Summary
                Text(
                  'Comparison Results',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                
                const SizedBox(height: 16),
                
                _buildComparisonCard(results),
                
                const SizedBox(height: 24),
                
                // Chart
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cumulative Cost Over Time',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 250,
                          child: _buildComparisonChart(results),
                        ),
                        const SizedBox(height: 16),
                        _buildLegend(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
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
  
  Widget _buildComparisonCard(Map<String, dynamic> results) {
    final rentCost = results['totalRentCost'] as double;
    final buyCost = results['totalBuyCost'] as double;
    final breakEvenYear = results['breakEvenYear'] as int?;
    final winner = rentCost < buyCost ? 'Renting' : 'Buying';
    final savings = (rentCost - buyCost).abs();
    
    return Card(
      color: winner == 'Buying' 
          ? Colors.green.withValues(alpha: 0.1)
          : Colors.orange.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              winner == 'Buying' ? Icons.trending_down : Icons.trending_up,
              size: 48,
              color: winner == 'Buying' ? Colors.green[700] : Colors.orange[700],
            ),
            const SizedBox(height: 16),
            Text(
              '$winner is cheaper',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: winner == 'Buying' ? Colors.green[700] : Colors.orange[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Save £${savings.toStringAsFixed(0)} over $_horizonYears years',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            
            if (breakEvenYear != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 20,
                      color: AppTheme.primaryBlue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Break-even at year $breakEvenYear',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const Divider(height: 32),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCostColumn('Total Rent Cost', rentCost),
                _buildCostColumn('Total Buy Cost', buyCost),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCostColumn(String label, double value) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          '£${(value / 1000).toStringAsFixed(0)}k',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  Widget _buildComparisonChart(Map<String, dynamic> results) {
    final rentData = results['rentDataPoints'] as List<FlSpot>;
    final buyData = results['buyDataPoints'] as List<FlSpot>;
    
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withValues(alpha: 0.2),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
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
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: rentData,
            isCurved: true,
            color: Colors.orange,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.orange.withValues(alpha: 0.1),
            ),
          ),
          LineChartBarData(
            spots: buyData,
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withValues(alpha: 0.1),
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
        _buildLegendItem(Colors.orange, 'Renting'),
        const SizedBox(width: 24),
        _buildLegendItem(Colors.green, 'Buying'),
      ],
    );
  }
  
  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
  
  Map<String, dynamic> _calculateComparison(calculation) {
    final deposit = widget.scenario.deposit;
    final stampDuty = calculation.stampDuty;
    final monthlyMortgage = calculation.monthlyPayment;
    
    // Calculate costs year by year
    List<FlSpot> rentDataPoints = [];
    List<FlSpot> buyDataPoints = [];
    
    double cumulativeRent = 0;
    double cumulativeBuy = deposit + stampDuty;
    double currentMonthlyRent = _monthlyRent;
    int? breakEvenYear;
    
    for (int year = 0; year <= _horizonYears; year++) {
      rentDataPoints.add(FlSpot(year.toDouble(), cumulativeRent));
      buyDataPoints.add(FlSpot(year.toDouble(), cumulativeBuy));
      
      // Check for break-even
      if (breakEvenYear == null && year > 0 && cumulativeBuy < cumulativeRent) {
        breakEvenYear = year;
      }
      
      if (year < _horizonYears) {
        // Add year's costs
        cumulativeRent += currentMonthlyRent * 12;
        cumulativeBuy += monthlyMortgage * 12;
        
        // Apply increases
        currentMonthlyRent *= (1 + _annualRentIncrease / 100);
      }
    }
    
    return {
      'totalRentCost': cumulativeRent,
      'totalBuyCost': cumulativeBuy,
      'breakEvenYear': breakEvenYear,
      'rentDataPoints': rentDataPoints,
      'buyDataPoints': buyDataPoints,
    };
  }
}
