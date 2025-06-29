import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get text => theme.textTheme;

  // Common colors
  Color get primaryColor => colors.primary;
  Color get secondaryColor => colors.secondary;
  Color get backgroundColor => colors.background;
  Color get surfaceColor => colors.surface;
  Color get errorColor => colors.error;

  // Text colors
  Color get textPrimary => colors.onSurface;
  Color get textSecondary => colors.onSurface.withOpacity(0.7);
  Color get textHint => colors.onSurface.withOpacity(0.5);

  // Common text styles
  TextStyle get titleStyle => text.titleLarge!.copyWith(
        color: colors.primary,
        fontWeight: FontWeight.bold,
      );

  TextStyle get subtitleStyle => text.titleMedium!.copyWith(
        color: colors.onSurface,
        fontWeight: FontWeight.w600,
      );

  TextStyle get bodyStyle => text.bodyLarge!.copyWith(
        color: colors.onSurface,
      );

  // Common decorations
  BoxDecoration get cardDecoration => BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );

  InputDecoration get inputDecoration => InputDecoration(
        filled: true,
        fillColor: colors.surface.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.error, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      );

  // Common button styles
  ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      );

  ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: colors.surface,
        foregroundColor: colors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colors.primary),
        ),
        elevation: 0,
      );
}
