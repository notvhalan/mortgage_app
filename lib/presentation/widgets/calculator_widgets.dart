import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class SummaryCard extends StatelessWidget {
  final double propertyPrice;
  final double monthlyPayment;
  final double loanAmount;
  final double stampDuty;
  final double ltv;

  const SummaryCard({
    super.key,
    required this.propertyPrice,
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
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: AppTheme.spacingSmall),
            Text(
              '£${monthlyPayment.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppTheme.primaryBlue,
                fontWeight: AppTheme.fontWeightBold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoColumn(
                  context,
                  'Property Price',
                  '£${_formatNumber(propertyPrice)}',
                ),
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
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: AppTheme.textSecondary),
        ),
        const SizedBox(height: AppTheme.spacingXSmall),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: AppTheme.fontWeightSemiBold,
            color: color ?? AppTheme.textPrimary,
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

class InputSlider extends StatefulWidget {
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
  State<InputSlider> createState() => _InputSliderState();
}

class _InputSliderState extends State<InputSlider> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  String _rawValue(double v) => widget.valueFormatter(v)
      .replaceAll('£', '')
      .replaceAll('%', '')
      .replaceAll(' years', '');

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _rawValue(widget.value));
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) _handleSubmit(_controller.text);
    });
  }

  @override
  void didUpdateWidget(InputSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync text field when slider moves (but not while user is typing)
    if (oldWidget.value != widget.value && !_focusNode.hasFocus) {
      _controller.text = _rawValue(widget.value);
    }
  }

  void _handleSubmit(String val) {
    final parsed = double.tryParse(val.trim());
    if (parsed != null) {
      final clamped = parsed.clamp(widget.min, widget.max);
      widget.onChanged(clamped);
      _controller.text = _rawValue(clamped);
    } else {
      // Reset to current valid value
      _controller.text = _rawValue(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

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
                  widget.label,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                if (widget.showTextField)
                  SizedBox(
                    width: 120,
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
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
                      onSubmitted: _handleSubmit,
                    ),
                  )
                else
                  Text(
                    widget.valueFormatter(widget.value),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
              ],
            ),
            Slider(
              value: widget.value,
              min: widget.min,
              max: widget.max,
              divisions: widget.divisions,
              onChanged: widget.onChanged,
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
