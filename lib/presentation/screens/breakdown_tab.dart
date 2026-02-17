import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/services/mortgage_scenario.dart';
import '../widgets/visualization_widgets.dart';

class BreakdownTab extends StatefulWidget {
  final MortgageScenario scenario;
  
  const BreakdownTab({
    super.key,
    required this.scenario,
  });
  
  @override
  State<BreakdownTab> createState() => _BreakdownTabState();
}

class _BreakdownTabState extends State<BreakdownTab> {
  int _selectedSegment = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breakdown'),
      ),
      body: ListenableBuilder(
        listenable: widget.scenario,
        builder: (context, _) {
          final schedule = widget.scenario.amortisationSchedule;
          final calc = widget.scenario.calculation;
          
          if (schedule == null || calc == null) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return Column(
            children: [
              // Segmented Control
              Padding(
                padding: const EdgeInsets.all(16),
                child: SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(
                      value: 0,
                      label: Text('Graph'),
                      icon: Icon(Icons.show_chart),
                    ),
                    ButtonSegment(
                      value: 1,
                      label: Text('Amortisation'),
                      icon: Icon(Icons.table_chart),
                    ),
                    ButtonSegment(
                      value: 2,
                      label: Text('Stamp Duty'),
                      icon: Icon(Icons.receipt_long),
                    ),
                  ],
                  selected: {_selectedSegment},
                  onSelectionChanged: (Set<int> newSelection) {
                    setState(() => _selectedSegment = newSelection.first);
                  },
                ),
              ),
              
              // Content based on segment
              Expanded(
                child: IndexedStack(
                  index: _selectedSegment,
                  children: [
                    // Graph View
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Card(
                        child: MortgageGraph(schedule: schedule),
                      ),
                    ),
                    
                    // Amortisation Table
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Card(
                        child: AmortisationTable(schedule: schedule),
                      ),
                    ),
                    
                    // Stamp Duty Breakdown
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: _buildStampDutyBreakdown(calc),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildStampDutyBreakdown(calculation) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stamp Duty Land Tax',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              widget.scenario.region,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            
            // Total Stamp Duty (highlighted)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Stamp Duty',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '£${calculation.stampDuty.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Property Price
            _buildInfoRow(
              'Property Price',
              '£${calculation.propertyPrice.toStringAsFixed(0)}',
            ),
            
            const Divider(height: 32),
            
            // Band Breakdown
            Text(
              'How it\'s calculated',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            ..._getStampDutyBands(),
            
            const SizedBox(height: 24),
            
            // Disclaimer
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.orange.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: Colors.orange[700],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Rates shown are for residential properties. Additional charges may apply for second homes or buy-to-let properties.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
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
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  List<Widget> _getStampDutyBands() {
    final region = widget.scenario.region;
    
    if (region == 'England/NI') {
      return [
        _buildBandRow('Up to £250,000', '0%'),
        _buildBandRow('£250,001 - £925,000', '5%'),
        _buildBandRow('£925,001 - £1,500,000', '10%'),
        _buildBandRow('Above £1,500,000', '12%'),
      ];
    } else if (region == 'Scotland') {
      return [
        _buildBandRow('Up to £145,000', '0%'),
        _buildBandRow('£145,001 - £250,000', '2%'),
        _buildBandRow('£250,001 - £325,000', '5%'),
        _buildBandRow('£325,001 - £750,000', '10%'),
        _buildBandRow('Above £750,000', '12%'),
      ];
    } else { // Wales
      return [
        _buildBandRow('Up to £225,000', '0%'),
        _buildBandRow('£225,001 - £400,000', '6%'),
        _buildBandRow('£400,001 - £750,000', '7.5%'),
        _buildBandRow('£750,001 - £1,500,000', '10%'),
        _buildBandRow('Above £1,500,000', '12%'),
      ];
    }
  }
  
  Widget _buildBandRow(String range, String rate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            range,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              rate,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
