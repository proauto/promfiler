# 🔧 문제 해결 가이드

## Google Fonts 네트워크 에러

### 문제 증상
```
Exception: Failed to load font with url https://fonts.gstatic.com/...
SocketException: Failed host lookup: 'fonts.gstatic.com'
```

### 원인
- 안드로이드 기기가 인터넷에 연결되어 있지 않음
- `google_fonts` 패키지가 폰트를 다운로드하려고 시도하지만 실패

### 해결 방법 ✅

**1. FontUtils 사용 (권장)**

`GoogleFonts.notoSans()` 대신 `FontUtils.notoSans()` 사용:

```dart
// ❌ 직접 사용 (네트워크 에러 발생 가능)
import 'package:google_fonts/google_fonts.dart';

Text(
  '텍스트',
  style: GoogleFonts.notoSans(fontSize: 16),
)

// ✅ FontUtils 사용 (에러 처리 포함)
import '../../../../core/utils/font_utils.dart';

Text(
  '텍스트',
  style: FontUtils.notoSans(fontSize: 16),
)
```

**2. 인터넷 권한 추가 (필수)**

`android/app/src/main/AndroidManifest.xml`:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- 인터넷 권한 추가 -->
    <uses-permission android:name="android.permission.INTERNET" />

    <application ...>
```

**3. 기기 인터넷 연결 확인**
- 안드로이드 기기가 WiFi 또는 모바일 데이터에 연결되어 있는지 확인
- 에뮬레이터의 경우 호스트 PC의 인터넷 연결 확인

---

## 핫 리로드 작동하지 않음

### 문제 증상
```
Error: Could not start Dart VM service HTTP server:
SocketException: Failed to create server socket (OS Error: Operation not permitted, errno = 1)
```

### 원인
- Dart VM 서비스가 포트 바인딩에 실패
- 안드로이드 권한 부족

### 해결 방법 ✅

**1. 인터넷 권한 추가** (위와 동일)

**2. 앱 완전 재시작**
```bash
flutter clean
flutter run
```

**3. USB 디버깅 권한 확인**
- 안드로이드 기기: 설정 > 개발자 옵션 > USB 디버깅 활성화

---

## 폰트가 기본 폰트로 표시됨

### 문제 증상
- Noto Sans 대신 시스템 기본 폰트로 표시됨
- 디자인과 다른 느낌

### 원인
- Google Fonts가 로드되지 않음 (네트워크 에러)
- FontUtils가 Fallback으로 기본 폰트 사용 중

### 해결 방법 (향후)

**로컬 Noto Sans 폰트 추가**:

1. Noto Sans KR 다운로드
   - https://fonts.google.com/noto/specimen/Noto+Sans+KR
   - Regular, Medium, SemiBold, Bold 파일

2. `assets/fonts/` 에 폰트 파일 추가

3. `pubspec.yaml` 업데이트:
```yaml
flutter:
  fonts:
    - family: NotoSans
      fonts:
        - asset: assets/fonts/NotoSansKR-Regular.ttf
        - asset: assets/fonts/NotoSansKR-Medium.ttf
          weight: 500
        - asset: assets/fonts/NotoSansKR-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/NotoSansKR-Bold.ttf
          weight: 700
```

4. FontUtils 업데이트:
```dart
static TextStyle notoSans({...}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    fontFamily: 'NotoSans', // 로컬 폰트 사용
    letterSpacing: letterSpacing,
    shadows: shadows,
  );
}
```

---

## 빌드 에러

### "No such file or directory" 에러

**해결:**
```bash
flutter clean
flutter pub get
flutter run
```

### "Manifest merger failed" 에러

**해결:**
- `android/app/src/main/AndroidManifest.xml` 확인
- XML 문법 오류 수정

---

## 성능 문제

### 앱이 느리게 동작함

**해결:**

1. **릴리즈 모드로 빌드**:
```bash
flutter run --release
```

2. **프로파일 모드로 성능 측정**:
```bash
flutter run --profile
```

3. **불필요한 재빌드 줄이기**:
- `const` 생성자 사용
- `LayoutConstants` 결과 캐싱

---

## 화면 비율 문제

### UI 요소가 너무 크거나 작음

**해결:**

1. **LayoutConstants 확인**:
   - `lib/core/constants/layout_constants.dart`
   - 비율 조정

2. **기기 해상도 확인**:
```dart
debugPrint('화면 크기: ${MediaQuery.of(context).size}');
```

3. **반응형 디자인 가이드 참조**:
   - `lib/core/constants/README.md`

---

## 추가 문제 해결

### Flutter Doctor 실행
```bash
flutter doctor -v
```

### 로그 확인
```bash
flutter logs
```

### 캐시 정리
```bash
flutter clean
flutter pub cache repair
```

---

**업데이트:** 2025-10-06
