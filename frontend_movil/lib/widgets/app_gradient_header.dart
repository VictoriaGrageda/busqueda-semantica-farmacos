import 'package:flutter/material.dart';

import '../app/theme/app_theme.dart';

class AppGradientHeader extends StatelessWidget {
  const AppGradientHeader({
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 20, 20, 28),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, AppTheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}
