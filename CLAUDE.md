# 🎮 밤의 침입자 (The Night Intruder) - 게임 개발 마스터플랜

> **작성일**: 2025-01-06 (수정: 템플릿 기반 AI 시스템)
> **프로젝트**: AI 추리 게임 - Flutter 기반 멀티플랫폼
> **목표**: 3-5개월 내 MVP 출시

---

## 📋 목차

1. [프로젝트 개요](#1-프로젝트-개요)
2. [기술 아키텍처](#2-기술-아키텍처)
3. [핵심 게임 시스템](#3-핵심-게임-시스템)
4. [UI/UX 구현 전략](#4-uiux-구현-전략)
5. [반응형 디자인 원칙](#5-반응형-디자인-원칙)
6. [데이터 구조 설계](#6-데이터-구조-설계)
7. [AI 템플릿 시스템](#7-ai-템플릿-시스템)
8. [개발 로드맵](#8-개발-로드맵)
9. [우선순위 매트릭스](#9-우선순위-매트릭스)
10. [리스크 및 대응 전략](#10-리스크-및-대응-전략)
11. [품질 보증 계획](#11-품질-보증-계획)

---

## 1. 프로젝트 개요

### 1.1 게임 컨셉

**장르**: 추리 어드벤처 / 인터랙티브 픽션
**플랫폼**: Android, iOS, Steam (Flutter Desktop)
**타겟**: 추리 게임 팬, 성인 (15세 이상)
**플레이 타임**: 3-5시간 (1회차)
**재플레이**: 다양한 증거물 조합으로 새로운 AI 응답 발견

### 1.2 핵심 게임플레이

```
경찰청 프로파일링센터 AI 전담 수사관
    ↓
5일 동안 이메일/증거 분석 (총 15개 이메일)
    ↓
AI 분석 요청: 증거물 3개 선택 + 분석 레벨 선택
    ↓
템플릿 기반 AI 응답 (사전 제작된 시나리오)
    ↓
3명의 용의자 중 진범 찾기
    ↓
최종 제출 → 엔딩 (S/A/B/C/F 등급)
```

### 1.3 차별화 포인트

- ✅ **완벽한 밀실 미스터리**: 미끄럼 매듭 트릭 (낚싯줄)
- ✅ **강력한 레드헤링**: 김수현 소설 원고 (Day 5 반전)
- ✅ **템플릿 기반 AI 시스템**: 증거물 조합별 맞춤 응답 (오프라인 플레이 가능)
- ✅ **복잡한 인간관계**: 공모 가능성, 불륜, 횡령 등 현실적 동기
- ✅ **몰입형 UI**: 실제 수사관의 PC 환경 시뮬레이션

### 1.4 AI 시스템 설계 철학

**템플릿 기반 응답 시스템 (Not Real-time API)**:
- ✅ **오프라인 플레이 가능**: 네트워크 불필요
- ✅ **비용 제로**: API 호출 비용 없음
- ✅ **일관된 품질**: 게임 디자이너가 의도한 힌트만 제공
- ✅ **즉각 응답**: 로딩 없음 (대기 시간은 연출)
- ✅ **재플레이 가치**: 증거물 조합별 다양한 응답

---

## 2. 기술 아키텍처

### 2.1 핵심 기술 스택

```yaml
Framework: Flutter 3.24+ (Stable)
Language: Dart 3.0+
State Management: Riverpod 2.x (추천) 또는 Provider 6.x
Local Storage:
  - SharedPreferences: 게임 진행 상태, 설정
  - Hive: 이메일, 증거, 메모, AI 응답 템플릿
Platform Support:
  - Android: minSdkVersion 21 (Android 5.0+)
  - iOS: iOS 13.0+
  - Desktop: Windows 10+, macOS 10.14+
```

### 2.2 주요 라이브러리

```yaml
dependencies:
  # Core
  flutter_riverpod: ^2.4.0  # 상태 관리
  hive: ^2.2.3              # 로컬 DB
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.2

  # UI/UX
  google_fonts: ^6.1.0      # Noto Sans KR
  cached_network_image: ^3.3.0  # 이미지 캐싱
  flutter_animate: ^4.3.0   # 애니메이션
  flutter_markdown: ^0.6.18 # Markdown 렌더링

  # Utilities
  intl: ^0.18.0             # 다국어/날짜
  path_provider: ^2.1.1     # 파일 경로
  json_annotation: ^4.8.1   # JSON 직렬화

  # Desktop (옵션)
  window_manager: ^0.3.7    # 창 관리

dev_dependencies:
  build_runner: ^2.4.6
  json_serializable: ^6.7.1
  hive_generator: ^2.0.1
  riverpod_generator: ^2.3.0
```

**주요 변경사항**:
- ❌ `dio`, `http` 제거 (API 호출 불필요)
- ✅ `flutter_markdown` 추가 (AI 응답 렌더링)

### 2.3 프로젝트 구조

```
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── constants/
│   │   ├── colors.dart
│   │   ├── text_styles.dart
│   │   └── game_constants.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       └── helpers.dart
│
├── data/
│   ├── models/
│   │   ├── email.dart
│   │   ├── suspect.dart
│   │   ├── evidence.dart
│   │   ├── game_state.dart
│   │   ├── ai_template.dart          # ⭐ 신규
│   │   └── ai_response.dart
│   │
│   ├── repositories/
│   │   ├── email_repository.dart
│   │   ├── suspect_repository.dart
│   │   ├── evidence_repository.dart
│   │   ├── ai_template_repository.dart  # ⭐ 신규
│   │   └── game_state_repository.dart
│   │
│   └── services/
│       ├── ai_template_service.dart   # ⭐ 신규 (템플릿 매칭)
│       ├── storage_service.dart
│       └── asset_loader.dart
│
├── domain/
│   ├── use_cases/
│   │   ├── unlock_email_use_case.dart
│   │   ├── submit_answer_use_case.dart
│   │   └── ai_analysis_use_case.dart  # ⭐ 수정 (템플릿 기반)
│   └── validators/
│       └── submission_validator.dart
│
├── presentation/
│   ├── providers/
│   │   ├── game_state_provider.dart
│   │   ├── token_provider.dart
│   │   ├── email_provider.dart
│   │   ├── suspect_provider.dart
│   │   └── ai_provider.dart
│   │
│   ├── screens/
│   │   ├── splash/
│   │   ├── main/
│   │   ├── case_files/
│   │   ├── emails/
│   │   ├── evidence/
│   │   ├── ai/
│   │   │   ├── ai_panel_bottom_sheet.dart
│   │   │   ├── evidence_selector_dialog.dart  # ⭐ 신규
│   │   │   └── ai_response_screen.dart
│   │   └── submission/
│   │
│   └── widgets/
│       ├── folder_icon.dart
│       ├── email_card.dart
│       ├── suspect_card.dart
│       ├── evidence_card.dart
│       ├── evidence_selector_item.dart  # ⭐ 신규
│       ├── ai_input_panel.dart
│       └── day_timer.dart
│
└── assets/
    ├── data/
    │   ├── core/
    │   ├── day1/
    │   ├── day2/
    │   ├── day3/
    │   ├── day4/
    │   ├── day5/
    │   └── ai_templates/               # ⭐ 신규
    │       ├── question_templates.json
    │       ├── think_templates.json
    │       └── ultra_think_templates.json
    │
    ├── images/
    └── fonts/
```

---

## 3. 핵심 게임 시스템

### 3.1 Day 시스템

```dart
// lib/data/models/game_state.dart
@HiveType(typeId: 0)
class GameState {
  @HiveField(0)
  int currentDay;           // 1-5

  @HiveField(1)
  DateTime currentTime;

  @HiveField(2)
  int tokenBalance;         // 초기 500

  @HiveField(3)
  List<String> readEmailIds;

  @HiveField(4)
  List<String> unlockedEvidenceIds;

  @HiveField(5)
  Map<String, String> suspectNotes;

  @HiveField(6)
  List<String> completedEnhancedInvestigations;

  @HiveField(7)
  bool canSubmitAnswer;    // Day 5만 true

  @HiveField(8)
  String? submittedSuspect;
}
```

### 3.2 토큰 시스템

```dart
// lib/data/models/ai_action.dart
enum AIAction {
  question(cost: 10, duration: Duration.zero),
  think(cost: 50, duration: Duration(seconds: 30)),      // ⭐ 연출용 대기
  ultraThink(cost: 100, duration: Duration(minutes: 2)); // ⭐ 연출용 대기

  final int cost;
  final Duration duration;  // 실제 AI 호출 아님, 연출용

  const AIAction({required this.cost, required this.duration});
}
```

**주요 변경사항**:
- ✅ `duration`은 연출용 대기 시간 (실제 처리는 즉시)
- ✅ Think: 30초 대기 (원래 1분 → 체감 개선)
- ✅ Ultra Think: 2분 대기 (원래 5분 → 체감 개선)

### 3.3 엔딩 시스템

```dart
// lib/data/models/ending.dart
enum EndingGrade {
  sPlus,  // 한지은 단독, AI 반대했지만 옳은 판단
  s,      // 한지은 단독, AI 동의
  aPlus,  // 한지은+박준영 공모, AI 반대했지만 신중
  a,      // 한지은+박준영 공모, AI 동의
  b,      // 김수현, AI도 속았음
  c,      // 김수현, AI 무시
  f,      // 박준영 또는 불기소
}

class EndingResult {
  final EndingGrade grade;
  final String title;
  final String description;
  final bool isCorrect;
  final bool agreedWithAI;

  static EndingResult determine({
    required String selectedSuspectId,
    required AIResponse? lastAIAnalysis,
  }) {
    final aiSuggestion = lastAIAnalysis?.topSuspect;
    final agreedWithAI = (selectedSuspectId == aiSuggestion);

    if (selectedSuspectId == 'hanJiEun') {
      if (agreedWithAI) {
        return EndingResult.s();
      } else {
        return EndingResult.sPlus();
      }
    } else if (selectedSuspectId == 'kimSuHyun') {
      if (agreedWithAI) {
        return EndingResult.b();
      } else {
        return EndingResult.c();
      }
    } else {
      return EndingResult.f();
    }
  }
}
```

---

## 4. UI/UX 구현 전략

### 4.1 다크 테마 디자인 시스템

```dart
// lib/core/constants/colors.dart
class GameColors {
  // 배경
  static const background = Color(0xFF1a1a1a);
  static const surface = Color(0xFF2d2d2d);
  static const surfaceVariant = Color(0xFF3a3a3a);

  // 강조색
  static const primary = Color(0xFF4a9eff);         // AI, 링크
  static const accent = Color(0xFFff6b6b);          // 긴급, 경고
  static const success = Color(0xFF4ade80);         // 성공, 새 항목

  // 텍스트
  static const textPrimary = Color(0xFFffffff);
  static const textSecondary = Color(0xFFb0b0b0);
  static const textHint = Color(0xFF6d6d6d);

  // 상태
  static const unread = Color(0xFF4a9eff);
  static const newItem = Color(0xFF4ade80);
  static const urgent = Color(0xFFff6b6b);
}
```

### 4.2 AI 패널 UI (수정)

#### 증거물 선택 다이얼로그 (신규)

```dart
// lib/presentation/screens/ai/evidence_selector_dialog.dart
class EvidenceSelectorDialog extends ConsumerStatefulWidget {
  final AIAction action;

  @override
  _EvidenceSelectorDialogState createState() => _EvidenceSelectorDialogState();
}

class _EvidenceSelectorDialogState extends ConsumerState<EvidenceSelectorDialog> {
  List<String> selectedEvidenceIds = [];

  @override
  Widget build(BuildContext context) {
    final allEvidences = ref.watch(evidenceProvider);

    return Dialog(
      child: Container(
        width: 600,
        height: 700,
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'AI 분석에 사용할 증거물을 3개 선택하세요',
              style: GameTextStyles.title,
            ),
            SizedBox(height: 8),
            Text(
              '선택한 증거물을 바탕으로 AI가 분석합니다',
              style: GameTextStyles.caption,
            ),

            SizedBox(height: 24),

            // 증거물 그리드
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: allEvidences.length,
                itemBuilder: (context, index) {
                  final evidence = allEvidences[index];
                  final isSelected = selectedEvidenceIds.contains(evidence.id);

                  return EvidenceSelectorItem(
                    evidence: evidence,
                    isSelected: isSelected,
                    onTap: () => _toggleSelection(evidence.id),
                    enabled: selectedEvidenceIds.length < 3 || isSelected,
                  );
                },
              ),
            ),

            SizedBox(height: 24),

            // 선택 완료 버튼
            ElevatedButton(
              onPressed: selectedEvidenceIds.length == 3
                  ? () => _confirmSelection(context)
                  : null,
              child: Text('선택 완료 (${selectedEvidenceIds.length}/3)'),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleSelection(String evidenceId) {
    setState(() {
      if (selectedEvidenceIds.contains(evidenceId)) {
        selectedEvidenceIds.remove(evidenceId);
      } else if (selectedEvidenceIds.length < 3) {
        selectedEvidenceIds.add(evidenceId);
      }
    });
  }

  Future<void> _confirmSelection(BuildContext context) async {
    Navigator.pop(context, selectedEvidenceIds);
  }
}
```

#### AI 패널 Bottom Sheet (수정)

```dart
// lib/presentation/screens/ai/ai_panel_bottom_sheet.dart
class AIPanelBottomSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokenBalance = ref.watch(tokenProvider).balance;

    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('VIT AI 분석 도구', style: GameTextStyles.title),
          SizedBox(height: 8),
          Text(
            '증거물 3개를 선택하여 AI 분석을 요청하세요',
            style: GameTextStyles.caption,
          ),
          SizedBox(height: 24),

          // 질문하기 (10토큰)
          AIActionButton(
            icon: Icons.chat_bubble_outline,
            title: '질문하기',
            cost: AIAction.question.cost,
            description: '선택한 증거물 3개를 기반으로 간단한 분석',
            enabled: tokenBalance >= AIAction.question.cost,
            onPressed: () => _startAnalysis(context, ref, AIAction.question),
          ),

          SizedBox(height: 16),

          // Think (50토큰)
          AIActionButton(
            icon: Icons.psychology,
            title: 'Think',
            cost: AIAction.think.cost,
            description: '선택한 증거물 3개를 종합 분석 (30초)',
            enabled: tokenBalance >= AIAction.think.cost,
            onPressed: () => _startAnalysis(context, ref, AIAction.think),
          ),

          SizedBox(height: 16),

          // Ultra Think (100토큰)
          AIActionButton(
            icon: Icons.lightbulb_outline,
            title: 'Ultra Think',
            cost: AIAction.ultraThink.cost,
            description: '선택한 증거물 3개를 심층 분석 및 레드헤링 탐지 (2분)',
            enabled: tokenBalance >= AIAction.ultraThink.cost,
            onPressed: () => _startAnalysis(context, ref, AIAction.ultraThink),
          ),

          SizedBox(height: 24),
          Text('현재 토큰: $tokenBalance', style: GameTextStyles.body),
        ],
      ),
    );
  }

  Future<void> _startAnalysis(
    BuildContext context,
    WidgetRef ref,
    AIAction action,
  ) async {
    // 1. 증거물 선택 다이얼로그
    final selectedEvidences = await showDialog<List<String>>(
      context: context,
      builder: (context) => EvidenceSelectorDialog(action: action),
    );

    if (selectedEvidences == null || selectedEvidences.length != 3) {
      return; // 취소됨
    }

    // 2. 로딩 다이얼로그 표시 (연출용 대기)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AIAnalysisLoadingDialog(action: action),
    );

    try {
      // 3. 템플릿 기반 AI 분석 (즉시 실행, duration은 연출용)
      final response = await ref.read(aiAnalysisUseCaseProvider).execute(
        action,
        selectedEvidences,
      );

      // 연출용 대기 (실제 처리는 이미 완료됨)
      await Future.delayed(action.duration);

      // 4. 로딩 닫기
      Navigator.of(context).pop();

      // 5. 결과 화면으로 이동
      context.push('/ai-response', extra: response);
    } catch (e) {
      Navigator.of(context).pop();
      _showError(context, e.toString());
    }
  }
}
```

---

## 5. 반응형 디자인 원칙 ⭐ 중요

### 5.1 Flutter의 dp (논리적 픽셀) 시스템

**핵심 개념**: Flutter는 **dp (density-independent pixels)** 를 사용하여 모든 기기에서 일관된 물리적 크기를 보장합니다.

```dart
// ✅ 올바른 방법 (고정 dp 값)
Container(
  width: 48.0,  // 48dp = 모든 기기에서 동일한 실제 크기
  height: 48.0,
  child: Image.asset('icon.png'),
)

// dp 시스템 작동 방식:
// - iPhone (3x): 48dp = 144 물리 픽셀 → 약 8mm
// - Android (2x): 48dp = 96 물리 픽셀 → 약 8mm
// - 결과: 모든 기기에서 동일한 물리적 크기 ✅
```

**절대 규칙:**
- ✅ **고정 dp 값 사용** (예: `48.0`, `56.0`, `14.0`)
- ✅ **LayoutConstants 사용** (기기별 최적화된 dp 값 제공)
- ❌ **화면 비율 기반 크기 금지** (기기마다 다른 경험 제공)

### 5.2 기기별 크기 전략

**아이콘 크기 (기기 타입별 분기)**:
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

**기기 분류 기준**:
- 폰: 화면 너비 < 600dp
- 태블릿: 600dp ~ 1200dp
- 데스크탑: > 1200dp

### 5.3 주요 dp 값 표

| 요소 | 폰 | 태블릿 | PC | 코드 |
|------|------|--------|-----|------|
| 상단바 높이 | 48dp | 48dp | 48dp | `LayoutConstants.topBarHeight(context)` |
| 아이콘 크기 | 48dp | 64dp | 72dp | `LayoutConstants.iconButtonSize(context)` |
| 아이콘 간격 | 16dp | 16dp | 16dp | `LayoutConstants.iconSpacing(context)` |
| AI 바 높이 | 56dp | 56dp | 56dp | `LayoutConstants.aiPromptBarHeight(context)` |
| 폰트 (상단바) | 14dp | 14dp | 14dp | `LayoutConstants.topBarFontSize(context)` |
| 폰트 (라벨) | 12dp | 12dp | 12dp | `LayoutConstants.iconLabelFontSize(context)` |

**전체 dp 값표**: `lib/core/constants/layout_constants.dart` 참조

### 5.4 왜 이 방식을 사용하는가?

**❌ 이전 방식 (화면 비율 기반)의 문제**:
- 작은 폰: 아이콘 너무 작음
- 큰 태블릿: 아이콘 너무 큼
- PC: 아이콘 거대해짐
- **결과**: 기기마다 완전히 다른 경험

**✅ 새 방식 (고정 dp + 기기별 분기)의 장점**:
- 모든 기기에서 일관된 물리적 크기
- 기기 타입별 최적화 (폰은 작게, PC는 크게)
- Material Design 가이드라인 준수
- **결과**: 모든 플랫폼에서 동일한 게임 경험

### 5.5 새로운 화면 개발 시 순서

1. **Material Design 가이드라인 확인**
   - 터치 영역: 최소 48dp × 48dp
   - 앱바: 56dp (모바일), 64dp (태블릿)
   - 버튼: 최소 48dp 높이
   - 폰트: 본문 14-16dp, 제목 20-24dp

2. **기기별 최적 크기 결정**
   ```dart
   // 폰: 작게 (48dp)
   // 태블릿: 중간 (64dp)
   // PC: 크게 (72dp)
   ```

3. **LayoutConstants에 추가**
   ```dart
   // lib/core/constants/layout_constants.dart
   static double newElementSize(BuildContext context) {
     final screenSize = getScreenSize(context);

     switch (screenSize) {
       case ScreenSize.phone:
         return 48.0;
       case ScreenSize.tablet:
         return 64.0;
       case ScreenSize.desktop:
         return 72.0;
     }
   }
   ```

4. **위젯에서 사용**
   ```dart
   final elementSize = LayoutConstants.newElementSize(context);

   Container(
     width: elementSize,
     height: elementSize,
     padding: EdgeInsets.all(8.0),  // 고정 8dp
     child: Icon(
       Icons.star,
       size: 24.0,  // 고정 24dp
       size: elementSize * 0.6,  // 요소의 60%
     ),
   )
   ```

### 5.5 상대적 크기 계산 패턴

```dart
// 화면 전체 기준
final containerSize = LayoutConstants.iconButtonSize(context);

// 부모 요소 기준 (비율 곱셈)
final iconSize = containerSize * 0.7;        // 컨테이너의 70%
final padding = containerSize * 0.1;         // 컨테이너의 10%
final borderRadius = containerSize * 0.15;   // 컨테이너의 15%
```

### 5.6 참고 자료

- **가이드 문서**: `lib/core/constants/README.md`
- **구현 예시**: `lib/presentation/screens/main/widgets/`
- **디자인 기준**: `screenshot/메인화면.png`

---

## 6. 데이터 구조 설계

### 5.1 핵심 모델

#### Evidence 모델

```dart
// lib/data/models/evidence.dart
@JsonSerializable()
class Evidence {
  final String id;                // "E001", "E002", ...
  final String name;              // "낚싯줄"
  final String description;       // "미끄럼 매듭 트릭 가능"
  final String type;              // "physical", "digital", "circumstantial"
  final String? imagePath;        // 이미지 경로
  final int unlockedDay;          // 해금되는 Day
  final List<String> relatedSuspects; // 관련 용의자 ID

  Evidence({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.imagePath,
    required this.unlockedDay,
    required this.relatedSuspects,
  });

  factory Evidence.fromJson(Map<String, dynamic> json) => _$EvidenceFromJson(json);
  Map<String, dynamic> toJson() => _$EvidenceToJson(this);
}
```

#### AI Template 모델 (신규)

```dart
// lib/data/models/ai_template.dart
@JsonSerializable()
class AITemplate {
  final String id;                        // "T001", "T002", ...
  final AIAction action;                  // question, think, ultraThink
  final List<String> evidenceIds;         // 증거물 조합 (정렬됨)
  final int? minDay;                      // 최소 Day (옵션)
  final int? maxDay;                      // 최대 Day (옵션)

  final String content;                   // AI 응답 텍스트 (Markdown)
  final Map<String, double>? probabilities; // 용의자별 확률 (Think/Ultra Think)
  final List<String>? keyEvidence;        // 핵심 증거 ID
  final List<String>? redHerrings;        // 레드헤링 경고
  final String? recommendation;           // AI 추천

  AITemplate({
    required this.id,
    required this.action,
    required this.evidenceIds,
    this.minDay,
    this.maxDay,
    required this.content,
    this.probabilities,
    this.keyEvidence,
    this.redHerrings,
    this.recommendation,
  });

  // 증거물 조합이 일치하는지 확인
  bool matchesEvidences(List<String> selectedIds) {
    final sortedSelected = List<String>.from(selectedIds)..sort();
    final sortedTemplate = List<String>.from(evidenceIds)..sort();
    return listEquals(sortedSelected, sortedTemplate);
  }

  factory AITemplate.fromJson(Map<String, dynamic> json) => _$AITemplateFromJson(json);
  Map<String, dynamic> toJson() => _$AITemplateToJson(this);
}
```

#### AI Response 모델

```dart
// lib/data/models/ai_response.dart
@JsonSerializable()
class AIResponse {
  final AIAction action;
  final DateTime timestamp;
  final List<String> selectedEvidenceIds; // 선택한 증거물
  final String content;                   // AI 응답 (Markdown)
  final Map<String, double>? probabilities;
  final List<String>? keyEvidence;
  final List<String>? redHerrings;
  final String? recommendation;

  AIResponse({
    required this.action,
    required this.timestamp,
    required this.selectedEvidenceIds,
    required this.content,
    this.probabilities,
    this.keyEvidence,
    this.redHerrings,
    this.recommendation,
  });

  String get topSuspect {
    if (probabilities == null) return '';
    return probabilities!.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  factory AIResponse.fromJson(Map<String, dynamic> json) => _$AIResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AIResponseToJson(this);
}
```

### 5.2 JSON 템플릿 예시

```json
// assets/data/ai_templates/ultra_think_templates.json
{
  "templates": [
    {
      "id": "UT_001",
      "action": "ultraThink",
      "evidenceIds": ["E003", "E006", "E009"],
      "minDay": 5,
      "content": "# 🧠 Ultra Think 심층 분석 결과\n\n## 선택한 증거물 분석\n\n### E003 - 낚싯줄 (미끄럼 매듭)\n- **물리적 증거의 핵심!**\n- 한지은 아버지 유품 (낚시 동호회 20년)\n- 재현 실험: 경험자 90% 성공률\n\n### E006 - 변기 디곡신 1정\n- 한지은 집 압수수색에서 발견\n- 증거 인멸 시도의 결정적 증거\n\n### E009 - 한지은 회사 방문 (토 10:30)\n- 유언장 정보 엿듣기\n- **범행 동기 확정**\n\n---\n\n## 용의자별 확률 분석\n\n### 한지은 (단독): **70.0%**\n물리적 증거 압도적:\n- 낚싯줄 트릭 실행 가능 (아버지와 평생 낚시)\n- 디곡신 증거 인멸 실패\n- 유언장 정보로 동기 확정\n\n타임라인 완벽:\n- 토 10:30 회사 방문 → 유언장 정보\n- 12:00 정원 사전 답사\n- 18:00 침입 추정\n\n동기 최강:\n- 500억 vs 0원\n- 월요일 10시가 마지막 기회\n\n### 한지은 + 박준영 (공모): **10.0%**\n- 이수진 매개 (정황 증거)\n- 직접 증거 없음\n\n### 김수현: **5.0%**\n- ⚠️ **레드헤링 확정**\n- 소설 원고 47페이지 발견\n- 편집자 교신 3개월\n- 비타민 영수증 복구\n\n### 박준영 (단독): **5.0%**\n- 알리바이 강함\n- 물리적 불가능\n\n---\n\n## 레드헤링 경고\n\n⚠️ **김수현의 모든 디지털 증거는 소설 작업이었습니다!**\n- 검색 기록 (10/18~22) → 소설 자료 조사\n- 이메일 \"실행\" → 소설 캐릭터 대사\n- $300 결제 → 비타민 구매\n\n\"너무 완벽한 증거\"는 오히려 의심해야 합니다.\n\n---\n\n## AI 최종 판단\n\n**범인: 한지은 (80% = 70% 단독 + 10% 공모)**\n\n핵심 근거:\n1. 토요일 10:30 회사 방문 → 유언장 정보 엿듣기\n2. 물리적 증거 압도적 (낚싯줄, 발자국, 디곡신)\n3. 동기의 시간적 압박 (월요일 10시 = 마지막)\n4. 알리바이 전체 조작 추정\n\n**권장: 한지은 단독 범행으로 제출**",
      "probabilities": {
        "hanJiEun": 70.0,
        "hanJiEun_parkJunYoung": 10.0,
        "kimSuHyun": 5.0,
        "parkJunYoung": 5.0,
        "unknown": 10.0
      },
      "keyEvidence": ["E003", "E006", "E009", "E013"],
      "redHerrings": [
        "김수현 검색 기록은 소설 자료 조사",
        "김수현 이메일은 소설 캐릭터 대사",
        "김수현 $300 결제는 비타민 구매"
      ],
      "recommendation": "한지은 (단독 범행)"
    },
    {
      "id": "UT_002",
      "action": "ultraThink",
      "evidenceIds": ["E004-1", "E004-2", "E011"],
      "minDay": 5,
      "content": "# 🧠 Ultra Think 심층 분석 결과\n\n## 선택한 증거물 분석\n\n### E004-1 - 김수현 검색 기록\n### E004-2 - 김수현 이메일 \"실행\"\n### E011 - 김수현 소설 원고 47페이지\n\n---\n\n⚠️ **레드헤링 경고!**\n\n이 3가지 증거는 모두 **김수현의 소설 작업**과 관련되어 있습니다.\n\n### E011 소설 원고 발견으로 모든 의심 해소\n- 제목: \"완벽한 밀실\"\n- 3개월간 작업 (8월~10월)\n- 편집자와 정식 교신\n- 10/23 완성본 47페이지 전송\n\n### 검색 기록 (E004-1)은 소설 자료 조사\n- 10/18~22: 디곡신, 심장마비 등 검색\n- 소설 집필을 위한 리서치\n\n### 이메일 \"실행\" (E004-2)은 소설 캐릭터 대사\n- \"오늘 밤 실행하기로 했어\"\n- 소설 속 비서 '수진'의 독백\n\n---\n\n## 용의자별 확률 분석\n\n### 김수현: **5.0%**\n- ⚠️ **완벽한 레드헤링**\n- 소설 원고로 무죄 입증\n\n### 한지은: **70.0%**\n- 물리적 증거 압도적\n- 낚싯줄, 발자국, 디곡신\n\n---\n\n## AI 최종 판단\n\n**김수현이 아니라 한지은입니다!**\n\n선택하신 증거물만으로는 김수현의 레드헤링만 확인됩니다.\n진범을 찾으려면 **물리적 증거**를 중심으로 분석하세요.\n\n**권장: E003 낚싯줄, E006 변기 디곡신, E009 회사 방문을 다시 분석해보세요.**",
      "probabilities": {
        "hanJiEun": 70.0,
        "kimSuHyun": 5.0,
        "parkJunYoung": 5.0,
        "unknown": 20.0
      },
      "keyEvidence": ["E011"],
      "redHerrings": [
        "김수현의 모든 디지털 증거는 소설 작업"
      ],
      "recommendation": "물리적 증거 재분석 필요"
    }
  ]
}
```

---

## 6. AI 템플릿 시스템

### 6.1 템플릿 매칭 서비스

```dart
// lib/data/services/ai_template_service.dart
class AITemplateService {
  final AITemplateRepository _templateRepository;

  AITemplateService(this._templateRepository);

  // 증거물 조합에 맞는 템플릿 찾기
  Future<AITemplate?> findTemplate({
    required AIAction action,
    required List<String> evidenceIds,
    required int currentDay,
  }) async {
    // 1. 모든 템플릿 로드
    final allTemplates = await _templateRepository.getTemplatesForAction(action);

    // 2. 증거물 조합이 정확히 일치하는 템플릿 찾기
    final exactMatch = allTemplates.firstWhereOrNull((template) {
      // Day 범위 체크
      if (template.minDay != null && currentDay < template.minDay!) {
        return false;
      }
      if (template.maxDay != null && currentDay > template.maxDay!) {
        return false;
      }

      // 증거물 조합 체크 (순서 무관)
      return template.matchesEvidences(evidenceIds);
    });

    if (exactMatch != null) {
      return exactMatch;
    }

    // 3. 정확히 일치하는 템플릿이 없으면 기본 템플릿 반환
    return _getDefaultTemplate(action, evidenceIds, currentDay);
  }

  // 기본 템플릿 (fallback)
  AITemplate _getDefaultTemplate(
    AIAction action,
    List<String> evidenceIds,
    int currentDay,
  ) {
    String content = '';

    switch (action) {
      case AIAction.question:
        content = _generateDefaultQuestionResponse(evidenceIds);
        break;
      case AIAction.think:
        content = _generateDefaultThinkResponse(evidenceIds, currentDay);
        break;
      case AIAction.ultraThink:
        content = _generateDefaultUltraThinkResponse(evidenceIds, currentDay);
        break;
    }

    return AITemplate(
      id: 'DEFAULT',
      action: action,
      evidenceIds: evidenceIds,
      content: content,
    );
  }

  String _generateDefaultQuestionResponse(List<String> evidenceIds) {
    return """
# AI 분석 결과

선택하신 증거물:
${evidenceIds.map((id) => '- $id').join('\n')}

## 분석

현재까지의 증거로는 명확한 결론을 내리기 어렵습니다.

더 많은 증거를 수집하거나, 다른 증거물 조합을 시도해보세요.

**권장: 물리적 증거와 디지털 증거를 함께 분석**
""";
  }

  String _generateDefaultThinkResponse(List<String> evidenceIds, int currentDay) {
    // Day별 기본 확률 (간단한 휴리스틱)
    Map<String, double> probabilities;

    if (currentDay <= 3) {
      probabilities = {
        'hanJiEun': 40.0,
        'kimSuHyun': 40.0,
        'parkJunYoung': 20.0,
      };
    } else if (currentDay == 4) {
      probabilities = {
        'hanJiEun': 50.0,
        'kimSuHyun': 40.0,
        'parkJunYoung': 10.0,
      };
    } else {
      // Day 5
      probabilities = {
        'hanJiEun': 70.0,
        'kimSuHyun': 5.0,
        'parkJunYoung': 5.0,
        'unknown': 20.0,
      };
    }

    return """
# Think 분석 결과

## 용의자별 확률

${probabilities.entries.map((e) => '- ${e.key}: ${e.value}%').join('\n')}

## 분석

선택하신 증거물 조합에 대한 특정 분석이 없습니다.

더 핵심적인 증거물을 선택하시거나, Ultra Think를 사용하세요.
""";
  }

  String _generateDefaultUltraThinkResponse(List<String> evidenceIds, int currentDay) {
    return """
# Ultra Think 심층 분석 결과

## 용의자별 확률

- 한지은: 70.0%
- 김수현: 5.0%
- 박준영: 5.0%
- 기타: 20.0%

## 분석

선택하신 증거물 조합에 대한 특정 분석이 없습니다.

**권장 증거물 조합:**
- E003 낚싯줄 + E006 변기 디곡신 + E009 회사 방문
- E004-1 검색 + E004-2 이메일 + E011 소설 원고

핵심 증거를 중심으로 다시 분석해보세요.
""";
  }
}
```

### 6.2 AI Analysis Use Case

```dart
// lib/domain/use_cases/ai_analysis_use_case.dart
class AIAnalysisUseCase {
  final AITemplateService _templateService;
  final TokenProvider _tokenProvider;
  final GameStateProvider _gameStateProvider;

  Future<AIResponse> execute(
    AIAction action,
    List<String> selectedEvidenceIds,
  ) async {
    // 1. 토큰 체크
    if (!_tokenProvider.canAfford(action.cost)) {
      throw InsufficientTokenException();
    }

    // 2. 토큰 차감
    _tokenProvider.spend(action.cost);

    // 3. 현재 Day 가져오기
    final currentDay = _gameStateProvider.currentDay;

    // 4. 템플릿 찾기 (즉시 실행)
    final template = await _templateService.findTemplate(
      action: action,
      evidenceIds: selectedEvidenceIds,
      currentDay: currentDay,
    );

    if (template == null) {
      throw AITemplateNotFoundException();
    }

    // 5. AI Response 생성
    return AIResponse(
      action: action,
      timestamp: DateTime.now(),
      selectedEvidenceIds: selectedEvidenceIds,
      content: template.content,
      probabilities: template.probabilities,
      keyEvidence: template.keyEvidence,
      redHerrings: template.redHerrings,
      recommendation: template.recommendation,
    );

    // 주의: 실제 처리는 즉시 완료됨
    // UI에서 action.duration만큼 연출용 대기 표시
  }
}
```

### 6.3 템플릿 작성 전략

**템플릿 개수 산정**:

```
증거물 총 개수: ~15개
3개 조합: C(15, 3) = 455개

하지만 모든 조합을 작성할 필요는 없음:

1. 핵심 조합 (필수): ~20개
   - 정답 루트 조합
   - 레드헤링 조합
   - 주요 분기점 조합

2. 일반 조합 (옵션): ~30개
   - 자주 선택될 만한 조합

3. 기본 템플릿 (fallback): 3개
   - question, think, ultraThink 각 1개
   - 매칭되는 템플릿이 없을 때 사용

총: 50-60개 템플릿
```

**우선순위별 템플릿 작성**:

| 우선순위 | 템플릿 타입 | 개수 | 비고 |
|---------|-----------|------|------|
| ⭐⭐⭐⭐⭐ | Ultra Think 핵심 조합 | 5개 | E003+E006+E009 등 정답 루트 |
| ⭐⭐⭐⭐⭐ | Ultra Think 레드헤링 | 3개 | E004+E011 등 김수현 조합 |
| ⭐⭐⭐⭐ | Think 핵심 조합 | 10개 | Day별 주요 조합 |
| ⭐⭐⭐ | Question 주요 조합 | 15개 | 자주 사용될 조합 |
| ⭐⭐ | Think 일반 조합 | 20개 | 추가 조합 |
| ⭐ | Fallback | 3개 | 매칭 실패 시 |

---

## 7. 개발 로드맵

### 7.1 Phase 1: 기본 프레임워크 (Week 1-3)

**목표**: 앱 뼈대 구축, 화면 네비게이션, 기본 UI

```
Week 1: 프로젝트 초기 설정
✓ Flutter 프로젝트 생성 (3.24+)
✓ Riverpod, Hive, 기타 라이브러리 설치
✓ 폴더 구조 구성
✓ 다크 테마 설정
✓ 더미 모델 클래스 작성

Week 2: 메인 화면 및 네비게이션
✓ MainScreen 구현
✓ 화면 라우팅 설정
✓ AppBar 및 DayTimer
✓ FolderIcon 위젯

Week 3: 기본 화면 스캐폴딩
✓ EmailListScreen
✓ CaseFilesScreen
✓ EvidenceScreen
✓ 더미 데이터로 테스트
```

---

### 7.2 Phase 2: 데이터 시스템 (Week 4-6)

**목표**: JSON 파싱, Hive 연동, 상태 관리

```
Week 4: 데이터 모델 및 JSON
✓ Email, Suspect, Evidence 모델
✓ json_serializable 적용
✓ AssetLoader 구현
✓ Day 1 이메일 3개 JSON

Week 5: Hive 로컬 저장소
✓ Hive TypeAdapter
✓ GameState 저장/로드
✓ StorageService 구현

Week 6: Riverpod 상태 관리
✓ GameStateProvider
✓ EmailProvider
✓ TokenProvider
✓ 화면 연결
```

---

### 7.3 Phase 3: 핵심 게임 로직 (Week 7-9)

**목표**: Day 시스템, 토큰 시스템, 이메일 해금

```
Week 7: Day 시스템
✓ Day 진행 로직
✓ 이메일 자동 해금
✓ Day 5 제출 버튼
✓ 타이머 표시

Week 8: 토큰 시스템 및 보강 수사
✓ 토큰 차감/복원
✓ 보강 수사 시스템
✓ 다음 날 파일 해금

Week 9: 이메일 상세 화면
✓ EmailDetailScreen
✓ Markdown 렌더링
✓ 첨부파일 뷰어
✓ 읽음 처리
```

---

### 7.4 Phase 4: AI 템플릿 시스템 (Week 10-12) ⭐ 수정

**목표**: 템플릿 기반 AI 응답 시스템 구축

```
Week 10: 템플릿 데이터 구조
✓ AITemplate 모델 작성
✓ AITemplateRepository 구현
✓ JSON 템플릿 파일 구조 설계
✓ 템플릿 로드 테스트

Week 11: 증거물 선택 UI
✓ EvidenceSelectorDialog 구현
✓ EvidenceSelectorItem 위젯
✓ 3개 선택 제한 로직
✓ 선택 완료 버튼

Week 12: 템플릿 매칭 및 응답
✓ AITemplateService 구현 (템플릿 매칭)
✓ AIAnalysisUseCase 수정 (템플릿 기반)
✓ AIResponseScreen (Markdown 렌더링)
✓ 연출용 로딩 애니메이션 (duration)
✓ 기본 템플릿 5개 작성 (테스트용)
```

**주요 변경사항**:
- ❌ Claude API 연동 제거
- ✅ 템플릿 기반 시스템으로 대체
- ✅ 증거물 선택 UI 추가
- ✅ 로컬에서 즉시 응답

---

### 7.5 Phase 5: 콘텐츠 통합 (Week 13-16) ⭐ 확장

**목표**: 15개 이메일, 증거물, AI 템플릿 작성

```
Week 13: 이메일 콘텐츠
✓ Day 1-5 이메일 15개 JSON
✓ 첨부파일 Markdown
✓ 이미지/증거 사진 에셋
✓ 모든 이메일 테스트

Week 14: 용의자 시스템
✓ SuspectDetailScreen
✓ 용의자 프로필 카드
✓ 관련 증거 필터링
✓ 플레이어 메모 기능

Week 15: 증거 시스템
✓ EvidenceScreen 완성
✓ 증거 카드 GridView
✓ 증거 상세 화면
✓ 증거 분류

Week 16: AI 템플릿 작성 ⭐ 신규
✓ Ultra Think 핵심 템플릿 8개
✓ Think 템플릿 15개
✓ Question 템플릿 20개
✓ Fallback 템플릿 3개
✓ 모든 템플릿 테스트
```

---

### 7.6 Phase 6: 엔딩 시스템 (Week 17-18)

**목표**: 최종 제출, 엔딩 판정, 컷신

```
Week 17: 최종 제출 화면
✓ FinalSubmissionScreen
✓ 용의자 선택
✓ 근거 작성
✓ 제출 확인

Week 18: 엔딩 판정 및 화면
✓ EndingResult 판정
✓ AI 의견 일치 체크
✓ EndingScreen 구현
✓ 범행 재현 텍스트
```

---

### 7.7 Phase 7: 테스트 및 버그 수정 (Week 19-20)

**목표**: QA, 버그 수정, 성능 최적화

```
Week 19: 기능 테스트
✓ 모든 화면 동작 테스트
✓ Day 1-5 전체 플레이
✓ AI 템플릿 매칭 검증
✓ 엔딩 분기 테스트

Week 20: 버그 수정 및 최적화
✓ 메모리 누수 체크
✓ 로딩 시간 개선
✓ 애니메이션 최적화
✓ 템플릿 미스매칭 처리
```

---

### 7.8 Phase 8: 플랫폼별 빌드 및 출시 (Week 21-22)

**목표**: Android/iOS/Steam 빌드, 스토어 등록

```
Week 21: Android/iOS 빌드
✓ APK/AAB 빌드
✓ IPA 빌드
✓ 스토어 등록
✓ 스크린샷 제작

Week 22: Steam 빌드 (옵션)
✓ Windows/macOS 빌드
✓ 스팀워크스 연동
✓ 스토어 페이지 작성
```

---

## 8. 우선순위 매트릭스

### 8.1 필수 기능 (MVP)

| 기능 | 중요도 | 구현 난이도 | Phase |
|------|--------|-------------|-------|
| 메인 화면 및 네비게이션 | ⭐⭐⭐⭐⭐ | 쉬움 | 1 |
| Day 시스템 및 이메일 해금 | ⭐⭐⭐⭐⭐ | 중간 | 3 |
| 토큰 시스템 | ⭐⭐⭐⭐⭐ | 쉬움 | 3 |
| 이메일 15개 + 첨부파일 | ⭐⭐⭐⭐⭐ | 중간 | 5 |
| **증거물 선택 UI** | ⭐⭐⭐⭐⭐ | 중간 | 4 |
| **AI 템플릿 시스템** | ⭐⭐⭐⭐⭐ | 중간 | 4 |
| **AI 템플릿 작성 (50개)** | ⭐⭐⭐⭐⭐ | 중간 | 5 |
| 최종 제출 및 엔딩 | ⭐⭐⭐⭐⭐ | 쉬움 | 6 |
| Hive 세이브/로드 | ⭐⭐⭐⭐⭐ | 중간 | 2 |

### 8.2 중요 기능

| 기능 | 중요도 | 구현 난이도 | Phase |
|------|--------|-------------|-------|
| 용의자 상세 화면 | ⭐⭐⭐⭐ | 쉬움 | 5 |
| 증거 갤러리 | ⭐⭐⭐⭐ | 쉬움 | 5 |
| 플레이어 메모 기능 | ⭐⭐⭐⭐ | 쉬움 | 5 |
| AI 응답 히스토리 | ⭐⭐⭐⭐ | 중간 | 4 |
| 보강 수사 시스템 | ⭐⭐⭐⭐ | 중간 | 3 |
| 애니메이션 효과 | ⭐⭐⭐ | 중간 | 1-7 |

### 8.3 추가 기능 (Post-MVP)

| 기능 | 중요도 | 구현 난이도 | 비고 |
|------|--------|-------------|------|
| 다크/라이트 테마 전환 | ⭐⭐ | 쉬움 | 설정 메뉴 |
| 다국어 지원 (영어) | ⭐⭐⭐ | 어려움 | 해외 출시용 |
| 범행 재현 영상 | ⭐⭐ | 어려움 | 엔딩 컷신 |
| 도전과제 시스템 | ⭐⭐ | 중간 | Steam 연동 |
| 하드 모드 (토큰 300) | ⭐⭐ | 쉬움 | 난이도 옵션 |

---

## 9. 리스크 및 대응 전략

### 9.1 기술적 리스크

| 리스크 | 확률 | 영향도 | 대응 전략 |
|--------|------|--------|-----------|
| ~~Claude API 비용 초과~~ | ❌ 제거 | - | 템플릿 시스템으로 해결 |
| **템플릿 매칭 실패** | 중간 | 중간 | - Fallback 템플릿 준비<br>- 기본 응답 로직 구현 |
| **템플릿 작성 시간 부족** | 높음 | 중간 | - 우선순위 템플릿부터 작성<br>- Fallback으로 커버 |
| Flutter Desktop 안정성 | 낮음 | 중간 | - 모바일 우선 개발 |
| Hive 데이터 손실 | 낮음 | 높음 | - 백업 메커니즘<br>- SharedPreferences 이중화 |

### 9.2 일정 리스크

| 리스크 | 확률 | 영향도 | 대응 전략 |
|--------|------|--------|-----------|
| **AI 템플릿 작성 지연** | 높음 | 높음 | - 핵심 템플릿 우선 (20개)<br>- Fallback으로 나머지 커버 |
| 콘텐츠 작업 지연 | 중간 | 중간 | - 이메일 템플릿화<br>- 우선순위 재조정 |
| 테스트 시간 부족 | 중간 | 중간 | - 유닛 테스트 자동화<br>- 베타 테스터 모집 |

### 9.3 콘텐츠 리스크

| 리스크 | 확률 | 영향도 | 대응 전략 |
|--------|------|--------|-----------|
| **템플릿 품질 저하** | 중간 | 높음 | - 핵심 템플릿 집중 작성<br>- 베타 테스트로 검증 |
| **증거물 조합 밸런스** | 중간 | 중간 | - 플레이테스트로 조정<br>- 힌트 시스템 추가 고려 |

---

## 10. 품질 보증 계획

### 10.1 테스트 체크리스트

```yaml
기능 테스트:
  - [ ] Day 1-5 모든 이메일 정상 도착
  - [ ] 토큰 소비/잔액 정확
  - [ ] 증거물 3개 선택 UI 동작
  - [ ] AI 템플릿 매칭 정확도 (핵심 조합)
  - [ ] Fallback 템플릿 동작
  - [ ] 보강 수사 → 다음 날 파일 제공
  - [ ] 최종 제출 및 엔딩 분기 (7종)
  - [ ] 세이브/로드 정상 작동

AI 템플릿 테스트:
  - [ ] 핵심 템플릿 20개 매칭 검증
  - [ ] Fallback 템플릿 동작 확인
  - [ ] Markdown 렌더링 확인
  - [ ] 확률 계산 정확도
  - [ ] 레드헤링 경고 표시

UI/UX 테스트:
  - [ ] 다크 테마 일관성
  - [ ] 폰트 가독성 (Noto Sans KR)
  - [ ] 증거물 선택 UI 사용성
  - [ ] 터치 영역 충분 (최소 44x44)
  - [ ] 애니메이션 60fps
  - [ ] 반응형 레이아웃 (가로 모드)

플랫폼 테스트:
  - [ ] Android 5.0+ 정상 작동
  - [ ] iOS 13+ 정상 작동
  - [ ] Windows/macOS 빌드 (옵션)

성능 테스트:
  - [ ] 앱 시작 시간 < 3초
  - [ ] 메모리 사용량 < 200MB
  - [ ] 템플릿 로드 시간 < 100ms
  - [ ] 이미지 로딩 최적화
```

### 10.2 사용자 테스트

**베타 테스트 계획**:
```
Week 19-20: 클로즈드 베타
- 테스터: 10명
- 목표: 버그 발견, UX 개선, 템플릿 품질 검증
- 설문: 난이도, 몰입도, AI 응답 품질

Week 21: 오픈 베타 (옵션)
- TestFlight (iOS) / Google Play 베타
- 피드백 수집 및 템플릿 개선
```

---

## 📌 핵심 마일스톤

### Milestone 1: 프로토타입 (Week 6)
✅ 화면 네비게이션 동작
✅ JSON 데이터 로드
✅ 기본 UI 완성

### Milestone 2: Alpha (Week 12)
✅ Day 시스템 완성
✅ **템플릿 기반 AI 시스템 구축**
✅ 이메일 5개 통합
✅ **기본 템플릿 5개 작성**

### Milestone 3: Beta (Week 18)
✅ 전체 콘텐츠 통합 (이메일 15개)
✅ **AI 템플릿 50개 작성**
✅ 엔딩 시스템 완성
✅ 버그 수정

### Milestone 4: Release (Week 22)
✅ 스토어 출시 (Android/iOS)
✅ Steam 출시 (옵션)
✅ 마케팅 자료 완성

---

## 🎯 다음 액션 아이템

### 즉시 시작 (Week 1)

1. **Flutter 프로젝트 생성**
   ```bash
   flutter create aiprofiler
   cd aiprofiler
   flutter pub add flutter_riverpod hive hive_flutter shared_preferences
   flutter pub add flutter_markdown google_fonts cached_network_image flutter_animate
   flutter pub add --dev build_runner json_serializable hive_generator
   ```

2. **폴더 구조 생성**
   - lib/ 하위 core, data, domain, presentation 폴더
   - assets/ 하위 data, images, fonts, **ai_templates** 폴더

3. **다크 테마 설정**
   - lib/core/constants/colors.dart
   - lib/core/constants/text_styles.dart

4. **첫 화면 구현**
   - lib/presentation/screens/main/main_screen.dart
   - 배경 이미지 + 3개 폴더 아이콘

5. **Hive 초기화**
   - main.dart에서 Hive.initFlutter()

---

## 💡 템플릿 시스템의 장점

### ✅ 기술적 장점
- **오프라인 플레이**: 네트워크 불필요
- **즉각 응답**: 실제 처리는 즉시 (duration은 연출용)
- **비용 제로**: API 호출 비용 없음
- **일관된 품질**: 게임 디자이너가 완전히 통제

### ✅ 게임 디자인 장점
- **정확한 힌트 제공**: 의도한 힌트만 제공
- **레드헤링 통제**: 레드헤링을 정확히 설계 가능
- **난이도 조절**: 템플릿별로 난이도 조절
- **재플레이 가치**: 증거물 조합별 다양한 응답 발견

### ✅ 개발 효율성
- **API 연동 불필요**: 네트워크 코드 제거
- **로컬 테스트 용이**: 모든 응답 즉시 확인 가능
- **버전 관리 용이**: JSON 파일로 버전 관리

---

**작성자**: Claude Code Assistant
**최종 수정**: 2025-01-06 (템플릿 기반 AI 시스템으로 전환)
**버전**: 2.0

---

이 마스터플랜을 기반으로 22주 내에 "밤의 침입자" 게임을 완성할 수 있습니다.
템플릿 기반 AI 시스템으로 API 비용 없이 오프라인에서도 플레이 가능한 게임이 됩니다.

화이팅! 🎮✨
