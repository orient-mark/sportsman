import 'package:flutter/material.dart';

/// The application's visual settings. Widgets inherit component styles from
/// ThemeData and use these shared dimensions for their layout.
abstract final class AppTheme {
  static const primary = Color(0xFFFF8400);
  static const foreground = Colors.black;
  static const surface = Colors.white;
  static const disabled = Colors.grey;
  static const qrForeground = Colors.black;
  static const qrBackground = Colors.white;

  static const spaceSmall = 8.0;
  static const spaceMedium = 12.0;
  static const spaceLarge = 16.0;
  static const spaceField = 20.0;
  static const spaceSection = 24.0;
  static const pagePadding = EdgeInsets.all(spaceLarge);
  static const iconSize = 32.0;
  static const fieldRadius = 16.0;
  static const scannerControlsHeight = 48.0;
  static const qrMinSize = 120.0;
  static const qrMaxSize = 440.0;

  static ThemeData get light {
    final colors =
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: primary,
          onPrimary: foreground,
          surface: surface,
          onSurface: foreground,
        );
    final base = ThemeData(useMaterial3: true, colorScheme: colors);
    final text = base.textTheme
        .apply(bodyColor: foreground, displayColor: foreground)
        .copyWith(titleLarge: const TextStyle(fontSize: 20, color: primary));
    return base.copyWith(
      scaffoldBackgroundColor: surface,
      textTheme: text,
      disabledColor: disabled,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: foreground,
        titleTextStyle: text.titleLarge,
      ),
      iconTheme: const IconThemeData(color: foreground, size: iconSize),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: foreground,
          iconSize: iconSize,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: foreground,
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(foregroundColor: foreground),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: primary),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primary,
        labelTextStyle: WidgetStatePropertyAll(text.labelMedium),
      ),
      dataTableTheme: DataTableThemeData(
        headingTextStyle: text.titleSmall,
        dataTextStyle: text.bodyMedium,
        columnSpacing: spaceSection,
      ),
    );
  }
}
