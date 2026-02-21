import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Premium hero card for displaying monthly payment summary
class HeroSummaryCard extends StatelessWidget {
  final double monthlyPayment;
  final double loanAmount;
  final double stampDuty;
  final double ltv;

  const HeroSummaryCard({
    super.key,
    required this.monthlyPayment,
    required this.loanAmount,
    required this.stampDuty,
    required this.ltv,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryBlue.withValues(alpha: 0.08),
            AppTheme.primaryLight.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.8),
            blurRadius: 1,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Payment',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
                fontSize: 14,
                fontWeight: AppTheme.fontWeightMedium,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    '£${monthlyPayment.toStringAsFixed(0)}',
                    key: ValueKey(monthlyPayment.toStringAsFixed(0)),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 48,
                      fontWeight: AppTheme.fontWeightBold,
                      color: AppTheme.textPrimary,
                      height: 1.1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '/month',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                MetricChip(
                  icon: Icons.account_balance_rounded,
                  label: 'Loan',
                  value: '£${_formatNumber(loanAmount)}',
                  color: AppTheme.info,
                ),
                MetricChip(
                  icon: Icons.receipt_rounded,
                  label: 'Stamp Duty',
                  value: '£${_formatNumber(stampDuty)}',
                  color: AppTheme.accentPurple,
                ),
                MetricChip(
                  icon: Icons.pie_chart_rounded,
                  label: 'LTV',
                  value: '${ltv.toStringAsFixed(0)}%',
                  color: AppTheme.getLTVColor(ltv),
                  highlighted: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}k';
    }
    return value.toStringAsFixed(0);
  }
}

/// Compact metric chip with icon
class MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool highlighted;

  const MetricChip({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: highlighted
            ? color.withValues(alpha: 0.15)
            : AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: highlighted
            ? Border.all(color: color.withValues(alpha: 0.3), width: 1.5)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: highlighted ? color : AppTheme.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
              fontWeight: AppTheme.fontWeightMedium,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: highlighted ? color : AppTheme.textPrimary,
              fontWeight: AppTheme.fontWeightSemiBold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Modern control card with title, value chip, and slider
class ControlCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String value;
  final double sliderValue;
  final double min;
  final double max;
  final int? divisions;
  final String? minLabel;
  final String? maxLabel;
  final ValueChanged<double> onChanged;

  const ControlCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.sliderValue,
    required this.min,
    required this.max,
    this.divisions,
    this.minLabel,
    this.maxLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: AppTheme.fontWeightSemiBold,
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              ValueChip(value: value),
            ],
          ),
          const SizedBox(height: 10),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.primaryBlue,
              inactiveTrackColor: AppTheme.borderLight,
              thumbColor: Colors.white,
              overlayColor: AppTheme.primaryLight.withValues(alpha: 0.2),
              trackHeight: 5,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 10,
                elevation: 3,
              ),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            ),
            child: Slider(
              value: sliderValue,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
          if (minLabel != null && maxLabel != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    minLabel!,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.textTertiary,
                      fontWeight: AppTheme.fontWeightRegular,
                    ),
                  ),
                  Text(
                    maxLabel!,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.textTertiary,
                      fontWeight: AppTheme.fontWeightRegular,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Value chip displaying formatted values
class ValueChip extends StatelessWidget {
  final String value;

  const ValueChip({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryBlue.withValues(alpha: 0.12),
            AppTheme.primaryLight.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryBlue.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 18,
          fontWeight: AppTheme.fontWeightSemiBold,
          color: AppTheme.primaryBlue,
        ),
      ),
    );
  }
}

/// Region selector with premium styling
class PremiumRegionSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const PremiumRegionSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 20,
                color: AppTheme.primaryBlue,
              ),
              const SizedBox(width: 8),
              Text(
                'UK Region',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: AppTheme.fontWeightSemiBold,
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppTheme.primaryBlue,
                ),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: AppTheme.fontWeightMedium,
                  color: AppTheme.textPrimary,
                ),
                borderRadius: BorderRadius.circular(16),
                onChanged: onChanged,
                items: ['England/NI', 'Scotland', 'Wales'].map((String region) {
                  return DropdownMenuItem<String>(
                    value: region,
                    child: Text(region),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
