import 'package:flutter/material.dart';

/// 반응형 레이아웃 상수
///
/// **설계 원칙**:
/// 1. 고정 dp 값 사용 (모든 기기에서 일관된 물리적 크기)
/// 2. 화면 방향(Landscape/Portrait)별 레이아웃 조정
/// 3. 기기 크기별 분기 (폰/태블릿/PC)
///
/// **Flutter의 논리적 픽셀(dp)**:
/// - 1dp = 물리적 밀도와 무관하게 동일한 크기
/// - iPhone (3x): 1dp = 3 물리 픽셀
/// - Android (2x): 1dp = 2 물리 픽셀
/// - 결과: 모든 기기에서 같은 크기로 보임
class LayoutConstants {
  LayoutConstants._();

  /// 화면이 Landscape인지 확인
  static bool isLandscape(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width > size.height;
  }

  /// 화면 크기 카테고리 판단
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return ScreenSize.phone;
    } else if (width < 1200) {
      return ScreenSize.tablet;
    } else {
      return ScreenSize.desktop;
    }
  }

  // ============================================
  // 메인 화면 레이아웃 (고정 dp 기반)
  // ============================================

  /// 상단바 높이 (고정 48dp - Material 권장)
  static double topBarHeight(BuildContext context) {
    return 48.0;
  }

  /// 아이콘 버튼 크기 (기기별 조정)
  static double iconButtonSize(BuildContext context) {
    final screenSize = getScreenSize(context);

    switch (screenSize) {
      case ScreenSize.phone:
        return 48.0; // 폰: 작게
      case ScreenSize.tablet:
        return 64.0; // 태블릿: 중간
      case ScreenSize.desktop:
        return 72.0; // PC: 크게
    }
  }

  /// 아이콘 간격 (고정)
  static double iconSpacing(BuildContext context) {
    return 16.0;
  }

  /// 아이콘 왼쪽 여백 (고정)
  static double iconLeftMargin(BuildContext context) {
    return 24.0;
  }

  /// 아이콘 상단 여백 (상단바 아래)
  static double iconTopMargin(BuildContext context) {
    return topBarHeight(context) + 16.0; // 48 + 16 = 64dp
  }

  /// AI 프롬프트바 높이 (고정)
  static double aiPromptBarHeight(BuildContext context) {
    return 56.0; // Material 권장
  }

  /// AI 프롬프트바 좌우 여백
  static double aiPromptBarHorizontalMargin(BuildContext context) {
    return 16.0;
  }

  /// AI 프롬프트바 하단 여백
  static double aiPromptBarBottomMargin(BuildContext context) {
    return 16.0;
  }

  /// 아이콘 라벨 폰트 크기
  static double iconLabelFontSize(BuildContext context) {
    return 12.0;
  }

  /// 뱃지 크기
  static double badgeSize(BuildContext context) {
    return 20.0;
  }

  /// 뱃지 폰트 크기
  static double badgeFontSize(BuildContext context) {
    return 12.0;
  }

  // ============================================
  // 상단바 레이아웃
  // ============================================

  /// 상단바 폰트 크기
  static double topBarFontSize(BuildContext context) {
    return 14.0;
  }

  /// 상단바 아이콘 크기
  static double topBarIconSize(BuildContext context) {
    return 24.0;
  }

  // ============================================
  // AI 프롬프트바 레이아웃
  // ============================================

  /// AI 프롬프트 폰트 크기
  static double aiPromptFontSize(BuildContext context) {
    return 14.0;
  }

  /// AI 아이콘 크기
  static double aiIconSize(BuildContext context) {
    return 24.0;
  }

  /// AI 프롬프트바 보더 라디우스
  static double aiPromptBarRadius(BuildContext context) {
    return aiPromptBarHeight(context) * 0.5; // 28dp
  }

  // ============================================
  // 메일 패널 레이아웃
  // ============================================

  /// 메일 패널 왼쪽 여백 (왼쪽 아이콘들이 보이도록)
  ///
  /// 계산식: 왼쪽 마진 + 아이콘 크기 + 여유 공간
  static double emailPanelLeftMargin(BuildContext context) {
    final iconSize = iconButtonSize(context);
    final leftMargin = iconLeftMargin(context);

    // 왼쪽 여백 + 아이콘 크기 + 여유 공간 24dp
    return leftMargin + iconSize + 24.0;
  }
}

/// 화면 크기 카테고리
enum ScreenSize {
  phone,    // < 600dp
  tablet,   // 600-1200dp
  desktop,  // > 1200dp
}
