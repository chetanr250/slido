import 'package:flutter/material.dart';
import '../../core/theme/theme_extension.dart';

class CustomBody extends StatelessWidget {
  final Widget child;
  const CustomBody({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.primaryColor.withValues(alpha: 0.07),
            context.surfaceColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}
