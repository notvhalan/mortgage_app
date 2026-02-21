import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Premium surface card with consistent styling across the app
class SurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final Color? backgroundColor;
  final List<BoxShadow>? shadows;
  final Border? border;

  const SurfaceCard({
    super.key,
    required this.child,
    this.padding,
    this.radius,
    this.backgroundColor,
    this.shadows,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(radius ?? 24),
        border: border ?? Border.all(color: AppTheme.borderLight, width: 1),
        boxShadow:
            shadows ??
            [
              BoxShadow(
                color: AppTheme.overlayLight,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.8),
                blurRadius: 1,
                offset: const Offset(0, -1),
              ),
            ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(20),
        child: child,
      ),
    );
  }
}

/// Surface card variant with no border
class SurfaceCardNoBorder extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final Color? backgroundColor;

  const SurfaceCardNoBorder({
    super.key,
    required this.child,
    this.padding,
    this.radius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(radius ?? 24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.overlayLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(20),
        child: child,
      ),
    );
  }
}
