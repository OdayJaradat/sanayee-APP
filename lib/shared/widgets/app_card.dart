import 'package:flutter/material.dart';
import '../../core/config/app_spacing.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const AppCard({
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      margin: margin,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.md),
          child: child,
        ),
      ),
    );

    return card;
  }
}
