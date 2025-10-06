# 반응형 디자인 가이드

## 📐 핵심 원칙

**모든 UI 요소는 화면 크기에 비례하는 비율 기반으로 크기를 계산합니다.**

- ✅ **절대 고정 크기 사용 금지** (예: `width: 80`, `height: 60`)
- ✅ **항상 `LayoutConstants` 사용** (예: `LayoutConstants.iconButtonSize(context)`)
- ✅ **MediaQuery 직접 사용 최소화** (LayoutConstants에서 중앙 관리)

---

## 🎯 기준 해상도

```dart
baseWidth: 740px (가로 모드)
baseHeight: 360px (가로 모드)
```

**모든 비율은 이 기준 해상도를 기반으로 계산됩니다.**

---

## 📏 주요 비율표

### 메인 화면 비율

| 요소 | 비율 | 계산 방법 | 코드 |
|------|------|-----------|------|
| 상단바 높이 | 14% | 화면 높이 × 0.14 | `LayoutConstants.topBarHeight(context)` |
| 아이콘 버튼 크기 | 15% | 화면 높이 × 0.15 | `LayoutConstants.iconButtonSize(context)` |
| 아이콘 간격 | 10% | 화면 높이 × 0.10 | `LayoutConstants.iconSpacing(context)` |
| 아이콘 왼쪽 여백 | 4% | 화면 너비 × 0.04 | `LayoutConstants.iconLeftMargin(context)` |
| 아이콘 상단 여백 | 19% | 화면 높이 × 0.19 | `LayoutConstants.iconTopMargin(context)` |
| AI 바 높이 | 11% | 화면 높이 × 0.11 | `LayoutConstants.aiPromptBarHeight(context)` |
| AI 바 좌우 여백 | 2% | 화면 너비 × 0.02 | `LayoutConstants.aiPromptBarHorizontalMargin(context)` |
| AI 바 하단 여백 | 4% | 화면 높이 × 0.04 | `LayoutConstants.aiPromptBarBottomMargin(context)` |

### 폰트 크기 비율

| 요소 | 비율 | 코드 |
|------|------|------|
| 상단바 폰트 | 4.5% | `LayoutConstants.topBarFontSize(context)` |
| 아이콘 라벨 | 3.5% | `LayoutConstants.iconLabelFontSize(context)` |
| AI 프롬프트 | 3.5% | `LayoutConstants.aiPromptFontSize(context)` |
| 뱃지 폰트 | 3% | `LayoutConstants.badgeFontSize(context)` |

### 아이콘 크기 비율

| 요소 | 비율 | 코드 |
|------|------|------|
| 상단바 아이콘 | 7% | `LayoutConstants.topBarIconSize(context)` |
| AI 아이콘 | 6% | `LayoutConstants.aiIconSize(context)` |
| 뱃지 크기 | 5% | `LayoutConstants.badgeSize(context)` |

---

## 🛠️ 사용 예시

### ❌ 잘못된 방법 (고정 크기)

```dart
Container(
  width: 80,  // ❌ 화면 크기에 상관없이 항상 80px
  height: 80,
  child: Image.asset('...'),
)
```

### ✅ 올바른 방법 (비율 기반)

```dart
final iconSize = LayoutConstants.iconButtonSize(context); // ✅ 화면 높이의 15%

Container(
  width: iconSize,
  height: iconSize,
  child: Image.asset('...'),
)
```

---

## 📱 새로운 화면 개발 시 체크리스트

### 1. 비율 계산

스크린샷이나 디자인을 보고 기준 해상도(740×360) 기준으로 비율을 계산합니다.

```
요소 크기(px) ÷ 화면 크기(px) = 비율

예시:
아이콘 크기 55px ÷ 화면 높이 360px = 0.153 ≈ 15%
```

### 2. LayoutConstants에 추가

```dart
// lib/core/constants/layout_constants.dart
static double newElementSize(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.15;
}
```

### 3. 위젯에서 사용

```dart
@override
Widget build(BuildContext context) {
  final elementSize = LayoutConstants.newElementSize(context);

  return Container(
    width: elementSize,
    height: elementSize,
    child: ...,
  );
}
```

### 4. 내부 여백/간격도 비율로

```dart
// ✅ 부모 크기 기준 비율
Container(
  width: elementSize,
  padding: EdgeInsets.all(elementSize * 0.1),  // 요소 크기의 10%
  child: Icon(
    Icons.star,
    size: elementSize * 0.6,  // 요소 크기의 60%
  ),
)
```

---

## 🎨 디자인 패턴

### 상대적 크기 계산

```dart
// 부모 요소 크기를 기준으로 자식 크기 계산
final containerSize = LayoutConstants.iconButtonSize(context);
final iconSize = containerSize * 0.7;  // 컨테이너의 70%
final padding = containerSize * 0.1;   // 컨테이너의 10%
final borderRadius = containerSize * 0.15;  // 컨테이너의 15%
```

### 화면 전체 기준 vs 부모 기준

```dart
// 화면 전체 기준 (LayoutConstants 사용)
final screenBasedSize = LayoutConstants.iconButtonSize(context);

// 부모 요소 기준 (비율 곱셈)
final parentBasedSize = parentSize * 0.15;
```

---

## 🔍 디버깅 팁

### 화면 크기 확인

```dart
@override
Widget build(BuildContext context) {
  debugPrint('화면 크기: ${MediaQuery.of(context).size}');
  debugPrint('아이콘 크기: ${LayoutConstants.iconButtonSize(context)}');

  return ...;
}
```

### 다양한 화면 크기 테스트

```
Android Studio > Running Devices > Device Manager
- Pixel 7 Pro (가로)
- Pixel Tablet (가로)
- 다양한 해상도 에뮬레이터
```

---

## ⚠️ 주의사항

### 1. SafeArea 고려

```dart
Positioned(
  top: MediaQuery.of(context).padding.top +  // ✅ SafeArea 상단 여백
       LayoutConstants.iconTopMargin(context),
  child: ...,
)
```

### 2. 최소/최대 크기 제한 (선택적)

```dart
final iconSize = LayoutConstants.iconButtonSize(context).clamp(40.0, 100.0);
```

### 3. 텍스트 오버플로 처리

```dart
Text(
  '긴 텍스트...',
  overflow: TextOverflow.ellipsis,  // ✅ 넘치면 ... 표시
  maxLines: 1,
)
```

---

## 📚 참고

- **LayoutConstants 파일**: `lib/core/constants/layout_constants.dart`
- **적용 예시**: `lib/presentation/screens/main/widgets/` 의 모든 위젯들
- **디자인 기준**: `screenshot/메인화면.png`

---

**중요**: 앞으로 모든 새로운 화면과 위젯은 이 가이드를 따라 개발해야 합니다!
