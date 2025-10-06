# build_runner 실행 가이드

> **작성일**: 2025-10-06
> **목적**: Phase 2 Week 4 완료 후 코드 생성 및 빌드 실행

---

## 📋 Phase 2 Week 4 완료 상태

### ✅ 완료된 작업

**1. 데이터 모델 작성**
- ✅ `lib/data/models/email.dart` (Email, EmailSender, EmailBody, EmailSection, EmailAttachment)
- ✅ `lib/data/models/game_state.dart` (GameState with 보강수사 필드)
- ✅ `lib/data/models/enhanced_mapping.dart` (EnhancedMapping)

**2. Repository 레이어**
- ✅ `lib/data/repositories/email_repository.dart`
- ✅ `lib/data/repositories/enhanced_investigation_repository.dart`

**3. Service 레이어**
- ✅ `lib/data/services/asset_loader.dart`
- ✅ `lib/data/services/storage_service.dart`

**4. 매핑 테이블**
- ✅ `assets/data/attachment_mappings.json`
- ✅ `assets/data/enhanced_mappings.json` (이미 작성됨)

**5. Assets 경로 설정**
- ✅ `pubspec.yaml` 업데이트 (day1-5, enhanced 경로 추가)

---

## 🔧 build_runner 실행

### Step 1: 코드 생성 실행

**명령어:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**설명:**
- `build_runner build`: json_serializable, hive_generator가 코드 생성
- `--delete-conflicting-outputs`: 기존 생성 파일이 있으면 삭제하고 재생성

**생성되는 파일:**
```
lib/data/models/email.g.dart
lib/data/models/game_state.g.dart
lib/data/models/enhanced_mapping.g.dart
```

### Step 2: 코드 생성 확인

**확인 사항:**
1. ✅ `.g.dart` 파일 3개 생성됨
2. ✅ 에러 메시지 없음
3. ✅ `part 'xxx.g.dart'` 경고 없음

**예상 출력:**
```
[INFO] Generating build script...
[INFO] Generating build script completed, took 524ms

[INFO] Initializing inputs
[INFO] Building new asset graph...
[INFO] Building new asset graph completed, took 1.2s

[INFO] Checking for unexpected pre-existing outputs...
[INFO] Deleting 3 declared outputs which already existed on disk.
[INFO] Checking for unexpected pre-existing outputs completed, took 12ms

[INFO] Running build...
[INFO] Running build completed, took 3.1s

[INFO] Caching finalized dependency graph...
[INFO] Caching finalized dependency graph completed, took 32ms

[INFO] Succeeded after 3.1s with 3 outputs (6 actions)
```

### Step 3: 빌드 테스트

**명령어:**
```bash
flutter clean
flutter pub get
flutter run
```

**설명:**
- `flutter clean`: 이전 빌드 캐시 삭제
- `flutter pub get`: 패키지 재설치
- `flutter run`: 앱 실행 및 에러 확인

---

## ⚠️ 예상 가능한 에러 및 해결

### 에러 1: build_runner not found

**증상:**
```
The Flutter tool cannot access the file or directory.
Please ensure that the SDK and/or project is installed in a location
that has read/write permissions for the current user.
```

**해결:**
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 에러 2: part 파일을 찾을 수 없음

**증상:**
```
lib/data/models/email.dart:3:6: Error:
Can't use 'email.g.dart' as a part, because it has no 'part of' declaration.
```

**원인:** build_runner 실행 전에 빌드하려고 함

**해결:** build_runner 먼저 실행

### 에러 3: Conflicting outputs

**증상:**
```
[SEVERE] Conflicting outputs were detected and the build is unable to continue
```

**해결:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 에러 4: Hive TypeAdapter not found

**증상:**
```
Error: Method not found: 'GameStateAdapter'.
```

**원인:** build_runner가 GameStateAdapter 생성 안 함

**해결:**
1. `game_state.dart`에서 `@HiveType(typeId: 0)` 확인
2. `part 'game_state.g.dart';` 확인
3. build_runner 재실행

---

## 🎯 다음 단계 (Phase 2 Week 5)

**Week 5 목표: Hive 로컬 저장소 완성**

### Step 1: main.dart에서 Hive 초기화

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // StorageService 초기화
  final storageService = StorageService();
  await storageService.init();

  runApp(MyApp());
}
```

### Step 2: GameState 저장/로드 테스트

```dart
// 저장
final gameState = GameState.initial();
await storageService.saveGameState(gameState);

// 로드
final loadedState = storageService.loadGameState();
print('로드된 Day: ${loadedState?.currentDay}');
```

### Step 3: Email 로드 테스트

```dart
// AssetLoader 생성
final assetLoader = AssetLoader();

// Day 1 이메일 로드
final emails = await assetLoader.loadEmailsForDay(1);
print('Day 1 이메일 개수: ${emails.length}');

for (final email in emails) {
  print('- ${email.id}: ${email.subject}');
}
```

---

## 📝 테스트 체크리스트

**build_runner 실행 후 확인:**
- [ ] email.g.dart 생성됨
- [ ] game_state.g.dart 생성됨
- [ ] enhanced_mapping.g.dart 생성됨
- [ ] 컴파일 에러 없음
- [ ] flutter run 성공

**기능 테스트 (Week 5에서 진행):**
- [ ] Hive 초기화 성공
- [ ] GameState 저장/로드 성공
- [ ] Day 1 이메일 3개 로드 성공
- [ ] 첨부파일 Markdown 로드 성공
- [ ] Enhanced 매핑 테이블 로드 성공

---

## 🚀 실행 순서 요약

```bash
# 1. 코드 생성
flutter pub run build_runner build --delete-conflicting-outputs

# 2. 빌드 테스트
flutter clean
flutter pub get
flutter run

# 3. 에러 확인
# - 콘솔에 에러 메시지 확인
# - 생성된 .g.dart 파일 확인

# 4. Week 5로 진행
# - main.dart에서 Hive 초기화
# - 데이터 로드 테스트
```

---

**작성자**: Claude Code Assistant
**작성일**: 2025-10-06
**Phase**: 2 Week 4 완료 → Week 5 시작

build_runner를 실행하고, 에러가 있으면 알려주세요!
