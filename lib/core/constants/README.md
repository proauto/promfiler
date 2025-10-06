# LayoutConstants - 반응형 디자인 가이드

## 📐 Flutter의 dp (논리적 픽셀) 시스템

### 핵심 개념

Flutter는 **dp (density-independent pixels)** 를 사용하여 모든 기기에서 **일관된 물리적 크기**를 보장합니다.

```dart
// 48dp는 모든 기기에서 동일한 실제 크기로 표시됨
Container(
  width: 48.0,
  height: 48.0,
)

// dp 작동 방식:
// - iPhone (3x): 48dp = 144 물리 픽셀 → 약 8mm
// - Android (2x): 48dp = 96 물리 픽셀 → 약 8mm
// - 결과: 동일한 물리적 크기 ✅
```

---

## 🎯 설계 원칙

### 1. 고정 dp 값 사용 ✅

```dart
// ✅ 올바른 방법
static double topBarHeight(BuildContext context) {
  return 48.0; // 고정 48dp
}

// ❌ 잘못된 방법 (화면 비율 기반)
static double topBarHeight(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.14; // 기기마다 다름!
}
```

### 2. 기기별 최적화

```dart
static double iconButtonSize(BuildContext context) {
  final screenSize = getScreenSize(context);

  switch (screenSize) {
    case ScreenSize.phone:     return 48.0; // 폰: 작게
    case ScreenSize.tablet:    return 64.0; // 태블릿: 중간
    case ScreenSize.desktop:   return 72.0; // PC: 크게
  }
}
```

### 3. Material Design 준수

- 터치 영역: 최소 48dp × 48dp
- 앱바: 56dp (모바일), 64dp (태블릿)
- 버튼: 최소 48dp 높이
- 폰트: 본문 14-16dp, 제목 20-24dp

---

## 📊 기기 분류 기준

```dart
static ScreenSize getScreenSize(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  if (width < 600) {
    return ScreenSize.phone;    // < 600dp
  } else if (width < 1200) {
    return ScreenSize.tablet;   // 600-1200dp
  } else {
    return ScreenSize.desktop;  // > 1200dp
  }
}
```

---

## 📏 주요 dp 값 표

### 메인 화면

| 요소 | 폰 | 태블릿 | PC | 메서드 |
|------|------|--------|-----|--------|
| **상단바** |
| 높이 | 48dp | 48dp | 48dp | `topBarHeight()` |
| 폰트 | 14dp | 14dp | 14dp | `topBarFontSize()` |
| 아이콘 | 24dp | 24dp | 24dp | `topBarIconSize()` |
| **아이콘 버튼** |
| 크기 | 48dp | 64dp | 72dp | `iconButtonSize()` |
| 간격 | 16dp | 16dp | 16dp | `iconSpacing()` |
| 라벨 폰트 | 12dp | 12dp | 12dp | `iconLabelFontSize()` |
| 왼쪽 여백 | 24dp | 24dp | 24dp | `iconLeftMargin()` |
| 상단 여백 | 64dp | 64dp | 64dp | `iconTopMargin()` |
| **뱃지** |
| 크기 | 20dp | 20dp | 20dp | `badgeSize()` |
| 폰트 | 12dp | 12dp | 12dp | `badgeFontSize()` |
| **AI 프롬프트바** |
| 높이 | 56dp | 56dp | 56dp | `aiPromptBarHeight()` |
| 폰트 | 14dp | 14dp | 14dp | `aiPromptFontSize()` |
| 아이콘 | 24dp | 24dp | 24dp | `aiIconSize()` |
| 가로 여백 | 16dp | 16dp | 16dp | `aiPromptBarHorizontalMargin()` |
| 하단 여백 | 16dp | 16dp | 16dp | `aiPromptBarBottomMargin()` |

---

## ✅ 모든 문서 업데이트 완료!

**업데이트된 파일**:
1. ✅ `CLAUDE.md` - Section 5 완전히 재작성
2. ✅ `lib/core/constants/LAYOUT_GUIDE.md` - 새 가이드 문서 생성
3. ✅ `lib/core/constants/layout_constants.dart` - dp 시스템으로 전환

**핵심 변경사항**:
- ❌ 화면 비율 기반 크기 제거
- ✅ 고정 dp 값 + 기기별 분기
- ✅ Material Design 가이드라인 준수
- ✅ 모든 플랫폼에서 일관된 경험

홈화면 구현이 완료되었고, 모든 문서가 최신 dp 시스템을 반영하고 있습니다! 🎉