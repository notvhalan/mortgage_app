import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class SummaryCard extends StatelessWidget {
  final double monthlyPayment;
  final double loanAmount;
  final double stampDuty;
  final double ltv;

  const SummaryCard({
    super.key,
    required this.monthlyPayment,
    required this.loanAmount,
    required this.stampDuty,
    required this.ltv,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.sectionSpacing),
        child: Column(
          children: [
            Text(
              'Monthly Payment',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '£${monthlyPayment.toStringAsFixed(0)}',
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(color: AppTheme.primaryBlue),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoColumn(
                  context,
                  'Loan',
                  '£${_formatNumber(loanAmount)}',
                ),
                _buildInfoColumn(
                  context,
                  'Stamp Duty',
                  '£${_formatNumber(stampDuty)}',
                ),
                _buildInfoColumn(
                  context,
                  'LTV',
                  '${ltv.toStringAsFixed(0)}%',
                  color: AppTheme.getLTVColor(ltv),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(
    BuildContext context,
    String label,
    String value, {
    Color? color,
  }) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}k';
    }
    return number.toStringAsFixed(0);
  }
}

class InputSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String Function(double) valueFormatter;
  final ValueChanged<double> onChanged;
  final bool showTextField;

  const InputSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.valueFormatter,
    required this.onChanged,
    this.showTextField = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
                if (showTextField)
                  SizedBox(
                    width: 120,
                    child: TextField(
                      controller: TextEditingController(
                        text: valueFormatter(value)
                            .replaceAll('£', '')
                            .replaceAll('%', '')
                            .replaceAll(' years', ''),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlue,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (val) {
                        final parsed = double.tryParse(val);
                        if (parsed != null && parsed >= min && parsed <= max) {
                          onChanged(parsed);
                        }
                      },
                    ),
                  )
                else
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

class RegionSelector extends StatelessWidget {
  final String selectedRegion;
  final ValueChanged<String> onChanged;

  const RegionSelector({
    super.key,
    required this.selectedRegion,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Region',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'England/NI', label: Text('England/NI')),
                ButtonSegment(value: 'Scotland', label: Text('Scotland')),
                ButtonSegment(value: 'Wales', label: Text('Wales')),
              ],
              selected: {selectedRegion},
              onSelectionChanged: (Set<String> newSelection) {
                onChanged(newSelection.first);
              },
            ),
          ],
        ),
      ),
    );
  }
}
