import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppColors {
  static const background            = Color(0xFF121212);
  static const surface               = Color(0xFF0E0E0E);
  static const surfaceContainerLow   = Color(0xFF131313);
  static const surfaceContainer      = Color(0xFF1A1A1A);
  static const surfaceContainerHigh  = Color(0xFF1E1E1E);
  static const surfaceContainerHighest = Color(0xFF262626);
  static const primary               = Color(0xFF6BFE9C);
  static const primaryContainer      = Color(0xFF1FC46A);
  static const onPrimary             = Color(0xFF005F2F);
  static const secondary             = Color(0xFF72FBBD);
  static const onSecondary           = Color(0xFF005E3E);
  static const secondaryContainer    = Color(0xFF006C49);
  static const tertiary              = Color(0xFF7EE6FF);
  static const tertiaryContainer     = Color(0xFF00DCFF);
  static const onTertiary            = Color(0xFF005361);
  static const onSurface             = Color(0xFFFFFFFF);
  static const onSurfaceVariant      = Color(0xFFADAAAA);
  static const outline               = Color(0xFF767575);
  static const outlineVariant        = Color(0xFF484847);
  static const error                 = Color(0xFFFF716C);
  static const onError               = Color(0xFF490006);
  static const errorContainer        = Color(0xFF9F0519);
  static const onErrorContainer      = Color(0xFFFFA8A3);
  static const primaryDim            = Color(0xFF5BEF90);
  static const inverseSurface        = Color(0xFFFCF9F8);
  static const inverseOnSurface      = Color(0xFF565555);
  static const inversePrimary        = Color(0xFF006E37);
}

abstract final class AppGradients {
  static const primaryCta = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.primaryContainer],
  );
}

abstract final class AppShadows {
  static const floatingBar = [BoxShadow(color: Colors.black54, blurRadius: 32, offset: Offset(0, -12))];
  static const primaryGlow = [BoxShadow(color: Color(0x336BFE9C), blurRadius: 24, offset: Offset(0, 8))];
  static const modal       = [BoxShadow(color: Color(0x80000000), blurRadius: 32, offset: Offset(0, 12))];
}

abstract final class AppRadius {
  static const double card   = 16;
  static const double button = 12;
  static const double chip   = 10;
  static const double sheet  = 28;
  static final cardAll   = BorderRadius.circular(card);
  static final buttonAll = BorderRadius.circular(button);
  static final chipAll   = BorderRadius.circular(chip);
  static final sheetTop  = const BorderRadius.vertical(top: Radius.circular(sheet));
}

abstract final class AppTheme {
  static ThemeData get dark {
    TextStyle m(double sz, FontWeight w, {double ls = 0}) =>
        GoogleFonts.manrope(fontSize: sz, fontWeight: w, letterSpacing: ls, color: AppColors.onSurface);

    final tt = TextTheme(
      displayLarge:  m(57, FontWeight.w800, ls: -1.14),
      displayMedium: m(45, FontWeight.w800, ls: -0.9),
      displaySmall:  m(36, FontWeight.w800, ls: -0.72),
      headlineLarge: m(40, FontWeight.w800, ls: -0.8),
      headlineMedium:m(28, FontWeight.w800, ls: -0.56),
      headlineSmall: m(24, FontWeight.w800, ls: -0.48),
      titleLarge:    m(20, FontWeight.w700, ls: -0.3),
      titleMedium:   m(16, FontWeight.w700, ls: -0.2),
      titleSmall:    m(14, FontWeight.w600, ls: -0.1),
      bodyLarge:     m(16, FontWeight.w500),
      bodyMedium:    m(14, FontWeight.w500),
      bodySmall:     m(12, FontWeight.w400),
      labelLarge:    m(12, FontWeight.w700, ls: 1.2),
      labelMedium:   m(10, FontWeight.w700, ls: 1.6),
      labelSmall:    m(9,  FontWeight.w700, ls: 1.8),
    );

    const cs = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary, onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer, onPrimaryContainer: Color(0xFF003417),
      secondary: AppColors.secondary, onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer, onSecondaryContainer: Color(0xFFE1FFEB),
      tertiary: AppColors.tertiary, onTertiary: AppColors.onTertiary,
      tertiaryContainer: AppColors.tertiaryContainer, onTertiaryContainer: Color(0xFF004956),
      error: AppColors.error, onError: AppColors.onError,
      errorContainer: AppColors.errorContainer, onErrorContainer: AppColors.onErrorContainer,
      surface: AppColors.surface, onSurface: AppColors.onSurface,
      surfaceContainerHighest: AppColors.surfaceContainerHighest,
      surfaceContainerHigh: AppColors.surfaceContainerHigh,
      surfaceContainer: AppColors.surfaceContainer,
      surfaceContainerLow: AppColors.surfaceContainerLow,
      surfaceContainerLowest: Color(0xFF000000),
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline, outlineVariant: AppColors.outlineVariant,
      inverseSurface: AppColors.inverseSurface, onInverseSurface: AppColors.inverseOnSurface,
      inversePrimary: AppColors.inversePrimary,
      scrim: Color(0xFF000000), shadow: Color(0xFF000000),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: cs,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      splashColor: const Color(0xFF6BFE9C).withValues(alpha: 0.06),
      highlightColor: const Color(0xFF6BFE9C).withValues(alpha: 0.04),
      splashFactory: InkRipple.splashFactory,
      textTheme: tt, primaryTextTheme: tt,
      iconTheme: const IconThemeData(color: AppColors.onSurfaceVariant, size: 24),
      primaryIconTheme: const IconThemeData(color: AppColors.primary, size: 24),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background, elevation: 0,
        scrolledUnderElevation: 0, surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.onSurface),
        iconTheme: const IconThemeData(color: AppColors.onSurface),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerHigh, elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardAll),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: AppColors.surfaceContainerHigh,
        border: OutlineInputBorder(borderRadius: AppRadius.cardAll, borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: AppRadius.cardAll, borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: AppRadius.cardAll,
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.manrope(fontSize: 14, color: AppColors.outline),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceContainerHigh, selectedColor: AppColors.primaryContainer,
        labelStyle: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.8),
        secondaryLabelStyle: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.chipAll, side: BorderSide.none),
        side: BorderSide.none, elevation: 0,
      ),
      dividerTheme: const DividerThemeData(color: Colors.transparent, thickness: 0, space: 0),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceContainerHigh,
        contentTextStyle: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.onSurface),
        actionTextColor: AppColors.primary, behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardAll), elevation: 0,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceContainerHigh, surfaceTintColor: Colors.transparent, elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardAll),
        titleTextStyle: GoogleFonts.manrope(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.onSurface, letterSpacing: -0.44),
        contentTextStyle: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceContainerHigh, surfaceTintColor: Colors.transparent,
        elevation: 0, modalElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheet))),
        clipBehavior: Clip.antiAlias,
        dragHandleColor: AppColors.surfaceContainerHighest, dragHandleSize: Size(48, 4),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.onPrimary : AppColors.outline),
        trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.primary : AppColors.surfaceContainerHighest),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.primary : AppColors.surfaceContainerHighest),
        checkColor: WidgetStateProperty.all(AppColors.onPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(color: AppColors.outlineVariant, width: 1.5),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.primary : AppColors.outlineVariant),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary, foregroundColor: AppColors.onPrimary,
        elevation: 0, focusElevation: 0, hoverElevation: 0, highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppRadius.button))),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      }),
    );
  }
}
