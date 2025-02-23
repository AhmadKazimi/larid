import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GradientPageLayout extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool useSafeArea;
  final bool useScroll;

  const GradientPageLayout({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24.0),
    this.useSafeArea = true,
    this.useScroll = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.gradientStart,
            AppColors.gradientEnd,
          ],
        ),
      ),
      child: Builder(
        builder: (context) {
          Widget content = child;

          // Apply padding
          if (padding != EdgeInsets.zero) {
            content = Padding(padding: padding, child: content);
          }

          // Wrap with SafeArea if needed
          if (useSafeArea) {
            content = SafeArea(child: content);
          }

          // Wrap with SingleChildScrollView if needed
          if (useScroll) {
            content = SingleChildScrollView(
              child: content,
            );
          }

          return content;
        },
      ),
    );
  }
}

class GradientFormCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const GradientFormCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24.0),
    this.borderRadius = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: (0.1)),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
