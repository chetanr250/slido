import 'package:flutter/material.dart';

class FancyButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool filled;
  final Color? color;
  final double fontSize;

  const FancyButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.filled = true,
    this.color,
    this.fontSize = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = color ?? theme.colorScheme.primary;
    return filled
        ? ElevatedButton.icon(
            icon: Icon(icon, size: 22),
            label: Text(label,
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
            ),
            onPressed: onPressed,
          )
        : OutlinedButton.icon(
            icon: Icon(icon, size: 22, color: buttonColor),
            label: Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                    color: buttonColor)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: buttonColor, width: 2),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: onPressed,
          );
  }
}
