// app_theme.dart — Simple Instagram-style theme
// Usage: MaterialApp(theme: AppTheme.light, darkTheme: AppTheme.dark)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Colors ──────────────────────────────────────────────────────────────────
class IGColors {
  static const Color splashBg = Color(0xFF000000);
  static const Color gray = Color(0xFF8E8E8E);
  static const Color purple = Color(0xFF8134AF);
  static const Color green = const Color(0xFF58C472);

  // Brand
  static const Color pink = Color(0xFFE1306C);
  static const Color blue = Color(0xFF0095F6);
  static const Color like = Color(0xFFED4956);
  // Light mode
  static const Color bgLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFAFAFA);
  static const Color lineLight = Color(0xFFDBDBDB);
  // Dark mode
  static const Color bgDark = Color(0xFF000000);
  static const Color cardDark = Color(0xFF1C1C1C);
  static const Color lineDark = Color(0xFF262626);
  // Text
  static const Color textDark = Color(0xFF262626);
  static const Color textMuted = Color(0xFF8E8E8E);
  static const Color textLight = Color(0xFFFFFFFF);

  /// The Instagram story ring gradient
  static const LinearGradient storyRingGradient = LinearGradient(
    colors: [
      Color(0xFFFCAF45),
      Color(0xFFF77737),
      Color(0xFFE1306C),
      Color(0xFF833AB4),
    ],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [
      Color(0xFFF58529),
      Color(0xFFED4956),
      Color(0xFF8134AF),
      Color(0xFF0095F6),
    ],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );
}

// ── Text Theme ───────────────────────────────────────────────────────────────
// Instagram uses SF Pro (iOS) / Roboto (Android). The closest Google Font
// is Nunito Sans — clean, geometric, same humanist proportions as SF Pro.
TextTheme _buildTextTheme(Color primary, Color secondary) {
  return TextTheme(
    // Large titles — profile name, screen headers
    displayLarge: GoogleFonts.nunitoSans(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: primary,
      height: 1.2,
    ),
    displayMedium: GoogleFonts.nunitoSans(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: primary,
      height: 1.2,
    ),
    displaySmall: GoogleFonts.nunitoSans(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: primary,
      height: 1.2,
    ),
    // Section titles, post usernames
    headlineLarge: GoogleFonts.nunitoSans(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: primary,
    ),
    headlineMedium: GoogleFonts.nunitoSans(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: primary,
    ),
    headlineSmall: GoogleFonts.nunitoSans(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: primary,
    ),
    // App bar title, story label
    titleLarge: GoogleFonts.nunitoSans(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: primary,
    ),
    titleMedium: GoogleFonts.nunitoSans(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: primary,
    ),
    titleSmall: GoogleFonts.nunitoSans(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: primary,
    ),
    // Captions, bios, comments
    bodyLarge: GoogleFonts.nunitoSans(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: primary,
      height: 1.4,
    ),
    bodyMedium: GoogleFonts.nunitoSans(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: primary,
      height: 1.4,
    ),
    bodySmall: GoogleFonts.nunitoSans(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: secondary,
      height: 1.4,
    ),
    // Buttons, tab labels, timestamps
    labelLarge: GoogleFonts.nunitoSans(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: primary,
    ),
    labelMedium: GoogleFonts.nunitoSans(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: secondary,
    ),
    labelSmall: GoogleFonts.nunitoSans(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      color: secondary,
    ),
  );
}

// ── Theme ────────────────────────────────────────────────────────────────────
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(dark: false);
  static ThemeData get dark => _build(dark: true);

  static ThemeData _build({required bool dark}) {
    final bg = dark ? IGColors.bgDark : IGColors.bgLight;
    final card = dark ? IGColors.cardDark : IGColors.cardLight;
    final line = dark ? IGColors.lineDark : IGColors.lineLight;
    final onBg = dark ? IGColors.textLight : IGColors.textDark;
    final muted = dark ? const Color(0xFFA8A8A8) : IGColors.textMuted;

    final cs = ColorScheme(
      brightness: dark ? Brightness.dark : Brightness.light,
      primary: IGColors.pink,
      onPrimary: Colors.white,
      secondary: IGColors.blue,
      onSecondary: Colors.white,
      error: IGColors.like,
      onError: Colors.white,
      surface: bg,
      onSurface: onBg,
      surfaceContainerHighest: card,
      onSurfaceVariant: muted,
      outline: line,
      outlineVariant: line.withValues(alpha: 0.5),
    );

    final tt = _buildTextTheme(onBg, muted);

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: bg,
      textTheme: tt,
      primaryTextTheme: tt,

      // App bar
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: onBg,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunitoSans(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: onBg,
        ),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: IGColors.pink,
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: GoogleFonts.nunitoSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(64, 44),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: onBg,
          side: BorderSide(color: line),
          textStyle: GoogleFonts.nunitoSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(64, 44),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: IGColors.blue,
          textStyle: GoogleFonts.nunitoSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text field
      inputDecorationTheme: InputDecorationTheme(
        filled: true,

        fillColor: card,
        hintStyle: GoogleFonts.nunitoSans(fontSize: 14, color: muted),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: IGColors.gray, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: IGColors.blue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: IGColors.like, width: 1.5),
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: line.withValues(alpha: 0.5), width: 0.5),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // Bottom nav
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: bg,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        elevation: 0,
        height: 56,
      ),

      // Divider
      dividerTheme: DividerThemeData(color: line, thickness: 0.5, space: 0),
    );
  }
}
