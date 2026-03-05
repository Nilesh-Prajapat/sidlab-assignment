import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData get dark {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.base,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.layer1,
        onSurface: AppColors.textMain,
        primary: AppColors.textMain,
        onPrimary: AppColors.base,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.topBar,
        foregroundColor: AppColors.textMain,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.topBar,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: GoogleFonts.spaceGrotesk(
          color: AppColors.textMain,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        iconTheme: const IconThemeData(color: AppColors.textDim, size: 22),

      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textMain,
        displayColor: AppColors.textMain,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.layer1,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide:  const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide:  const BorderSide(color: AppColors.textDead, width: 1),
        ),
        hintStyle: GoogleFonts.spaceGrotesk(color: AppColors.textDead, fontSize: 14),
        labelStyle: GoogleFonts.spaceGrotesk(
          color: AppColors.textDim, fontSize: 11,
          fontWeight: FontWeight.w500, letterSpacing: 1.5,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderMuted, thickness: 1, space: 0),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.topBar,
        indicatorColor: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final active = states.contains(WidgetState.selected);
          return GoogleFonts.spaceGrotesk(
            color: active ? AppColors.textMain : AppColors.textDead,
            fontSize: 9, fontWeight: FontWeight.w500, letterSpacing: 1.5,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final active = states.contains(WidgetState.selected);
          return IconThemeData(
            color: active ? AppColors.textMain : AppColors.textDead, size: 22);
        }),
      ),
    );
  }
}
