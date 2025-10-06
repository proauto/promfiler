import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Google Fonts 에러 처리를 위한 유틸리티
class FontUtils {
  FontUtils._();

  /// Noto Sans 폰트를 안전하게 가져옴 (네트워크 에러 시 기본 폰트 사용)
  static TextStyle notoSans({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    List<Shadow>? shadows,
  }) {
    try {
      return GoogleFonts.notoSans(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        shadows: shadows,
      );
    } catch (e) {
      // Google Fonts 로드 실패 시 기본 폰트 사용
      return TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        shadows: shadows,
        fontFamily: 'sans-serif', // Android 기본 폰트
      );
    }
  }
}
