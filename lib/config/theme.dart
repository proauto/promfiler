import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 앱 테마 (무채색 기반)
class AppTheme {
  // 무채색 팔레트
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color gray95 = Color(0xFFF2F2F2);
  static const Color gray80 = Color(0xFFCCCCCC);
  static const Color grayD9 = Color(0xFFD9D9D9);
  static const Color gray22 = Color(0xFF222222);

  // 배경/표면
  static const Color backgroundColor = black;
  static const Color surfaceColor = gray22;

  // 텍스트
  static const Color textPrimary = white;
  static const Color textSecondary = gray80;

  // 읽음/안읽음 구분 (불투명도)
  static const double unreadOpacity = 1.0;
  static const double readOpacity = 0.5;

  // 강조색 (최소한으로만 사용)
  static const Color primaryColor = Color(0xFF00D9FF); // AI, 링크용
  static const Color accentColor = Color(0xFFFF6B9D);  // 긴급 알림용
  static const Color successColor = Color(0xFF00E676); // 성공 메시지용
  static const Color errorColor = Color(0xFFFF5252);   // 에러 메시지용

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
      ),

      // Typography
      textTheme: TextTheme(
        displayLarge: GoogleFonts.notoSans(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displayMedium: GoogleFonts.notoSans(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.notoSans(
          fontSize: 16,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.notoSans(
          fontSize: 14,
          color: textSecondary,
        ),
      ),

      // Card Theme
      cardTheme: const CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        elevation: 0,
        titleTextStyle: GoogleFonts.notoSans(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: white,
        size: 24,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: gray22,
          foregroundColor: white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.notoSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
