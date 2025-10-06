# Phase 2 진행 계획 및 데이터 연결 규칙

> **작성일**: 2025-10-06
> **목적**: Phase 1 완료 확인, Phase 2 진행 전략, Assets 데이터 연결 규칙 정의

---

## 1. Phase 1 완료 상태 분석

### 1.1 원래 Phase 1 계획 (CLAUDE.md)

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

### 1.2 실제 완료 상태

**✅ 완료된 항목:**
- Week 1: 프로젝트 초기 설정 (100%)
- Week 2: 메인 화면 및 네비게이션 (100%)
  - MainScreen 완성 (dp 기반 반응형 디자인)
  - 상단바 (MainTopBar)
  - 왼쪽 아이콘 버튼 (사건파일, 메일, 증거)
  - AI 프롬프트바 (AIPromptBar)
  - 배경 이미지

**❌ 미완료 항목:**
- Week 3: 기본 화면 스캐폴딩 (0%)
  - EmailListScreen ❌
  - CaseFilesScreen ❌
  - EvidenceScreen ❌

### 1.3 조정된 진행 전략 ✅ 권장

**사용자의 접근 방식이 합리적합니다:**

```
기존 계획:
Phase 1 Week 3 (더미 화면) → Phase 2 (데이터) → Phase 3 (실제 화면)
                ↓                ↓                ↓
            중복 작업        데이터 정의      다시 화면 수정

조정 계획:
Phase 1 Week 1-2 (홈화면) → Phase 2 (데이터) → Phase 3 (실제 화면 + 연결)
        ✅ 완료             다음 단계          한 번에 완성
```

**장점:**
1. ✅ 더미 데이터로 두 번 작업하지 않음
2. ✅ 데이터 모델 먼저 정의 → 화면 구현 시 바로 실제 데이터 연결
3. ✅ Phase 2에서 JSON 구조 확정 → Phase 3에서 화면만 집중

**결론:**
- **Phase 1은 홈화면 완성으로 종료** ✅
- **바로 Phase 2 진행** ✅

---

## 2. Assets 폴더 구조 및 파일 명명 규칙

### 2.1 전체 폴더 구조

```
assets/
├── core/
│   └── game_intro.md                      # 게임 인트로
│
├── data/
│   └── .gitkeep                           # 미래 데이터용
│
├── day1/
│   ├── emails/
│   │   ├── e01_case_assignment.json      # 이메일 JSON
│   │   ├── e02_crime_scene.json
│   │   └── e03_suspects_initial_auto.json
│   │
│   └── attachments/
│       ├── e01_victim_profile_auto.md     # 첨부파일 Markdown
│       ├── e02_floor_plan.md
│       ├── e02_lock_photos.md
│       └── 이미지_사건현장_e01_crime_scene_photo  # 이미지
│
├── day2/
│   ├── emails/
│   │   ├── e04_autopsy.json
│   │   ├── e05_alibi_check.json
│   │   └── e06_drug_tracking.json
│   │
│   └── attachments/
│       └── e04__autopsy_report.md
│
├── day3/
│   ├── emails/
│   │   ├── e07_embezzlement.json
│   │   ├── e08_inheritance.json
│   │   └── e09_communication.json
│   │
│   └── attachments/
│       ├── e07_embezzlement_details_auto.md
│       └── e09_comm_records_auto.md
│
├── day4/
│   ├── emails/
│   │   ├── e10_kim_laptop.json
│   │   ├── e11_footprints.json
│   │   └── e12_summary.json
│   │
│   └── attachments/
│       ├── e10_email_draft_auto.md
│       ├── e10_fishing_experience.md
│       ├── e10_search_history_auto.md
│       ├── e11_fiber_analysis.md
│       ├── e11_footprint_analysis.md
│       └── e11_footprint_photos.md
│
├── day5/
│   ├── emails/
│   │   ├── email_e13.json                 # ⚠️ 네이밍 다름
│   │   └── email_e14.json                 # ⚠️ 네이밍 다름
│   │
│   └── attachments/
│       └── e17_conspiracy_theory.md
│
├── enhanced/                               # 보강 수사 파일
│   ├── (e05)_enhanced_04_gps_analysis.md  # ⚠️ 네이밍 방식 1
│   ├── (e06)_enhanced_01_drug_family.md
│   ├── (e07)_enhanced_01_final_warning.md
│   ├── (e09)_enhanced_01_netflix_log.md
│   ├── e02_enhanced_01_garden_report.md   # ⚠️ 네이밍 방식 2
│   ├── e02_enhanced_02_roof_access.md
│   ├── e02_enhanced_03_neighbor_interview.md
│   ├── e05_enhanced_02_witnesses_recheck.md
│   └── e05_enhanced_03_delivery_driver.md
│
├── images/
│   ├── icons/
│   │   ├── ai_icon_complete.png
│   │   ├── ai_icon_think.png
│   │   ├── camera_icon_clicked.png
│   │   ├── camera_icon_unclicked.png
│   │   ├── folder_icon_clicked.png
│   │   ├── folder_icon_unclicked.png
│   │   ├── mail_icon_clicked.png
│   │   └── mail_icon_unclicked.png
│   │
│   └── main_background.png
│
└── fonts/                                  # (미래)
```

### 2.2 파일 명명 규칙 분석

#### 2.2.1 이메일 JSON 파일

**Day 1-4 패턴:**
```
assets/day{N}/emails/e{NN}_{description}.json

예시:
- assets/day1/emails/e01_case_assignment.json
- assets/day2/emails/e04_autopsy.json
- assets/day3/emails/e07_embezzlement.json
```

**Day 5 패턴 (⚠️ 다름):**
```
assets/day5/emails/email_e{NN}.json

예시:
- assets/day5/emails/email_e13.json
- assets/day5/emails/email_e14.json
```

**일관성 문제:**
- Day 5만 `email_` 접두사 사용
- 설명(_description) 부분 생략

**권장 수정 (사용자가 할 작업):**
```
assets/day5/emails/email_e13.json
→ assets/day5/emails/e13_final_analysis.json

assets/day5/emails/email_e14.json
→ assets/day5/emails/e14_novel_manuscript.json
```

#### 2.2.2 첨부파일 Markdown

**기본 패턴:**
```
assets/day{N}/attachments/e{NN}_{description}.md

예시:
- assets/day1/attachments/e01_victim_profile_auto.md
- assets/day2/attachments/e04__autopsy_report.md
- assets/day4/attachments/e11_footprint_analysis.md
```

**특이사항:**
- 일부 파일 끝에 `_auto` 접미사
  - `e01_victim_profile_auto.md`
  - `e03_suspects_initial_auto.json`
  - `e07_embezzlement_details_auto.md`

- 이미지 파일 접두사:
  - `이미지_사건현장_e01_crime_scene_photo`

**`_auto` 의미 추정:**
- 자동 생성된 파일 (시스템이나 AI가 작성)
- 수사관이 직접 작성하지 않은 공식 문서

#### 2.2.3 보강 수사 파일 (Enhanced)

**패턴 1 (괄호 사용):**
```
assets/enhanced/(e{NN})_enhanced_{NN}_{description}.md

예시:
- (e05)_enhanced_04_gps_analysis.md
- (e06)_enhanced_01_drug_family.md
- (e07)_enhanced_01_final_warning.md
- (e09)_enhanced_01_netflix_log.md
```

**패턴 2 (괄호 없음):**
```
assets/enhanced/e{NN}_enhanced_{NN}_{description}.md

예시:
- e02_enhanced_01_garden_report.md
- e02_enhanced_02_roof_access.md
- e02_enhanced_03_neighbor_interview.md
- e05_enhanced_02_witnesses_recheck.md
- e05_enhanced_03_delivery_driver.md
```

**일관성 문제:**
- 두 가지 네이밍 방식 혼재
- 괄호 사용 여부 불일치

**권장 표준 (사용자가 선택):**

**옵션 A - 괄호 제거:**
```
e{NN}_enhanced_{NN}_{description}.md

모든 파일:
- e05_enhanced_04_gps_analysis.md
- e06_enhanced_01_drug_family.md
- e07_enhanced_01_final_warning.md
```

**옵션 B - 괄호 사용:**
```
(e{NN})_enhanced_{NN}_{description}.md

모든 파일:
- (e02)_enhanced_01_garden_report.md
- (e02)_enhanced_02_roof_access.md
- (e05)_enhanced_02_witnesses_recheck.md
```

---

## 3. JSON 데이터 구조 및 연결 규칙

### 3.1 이메일 JSON 표준 구조

**Day 1-4 구조:**
```json
{
  "id": "E01",                              // 대문자 E + 숫자
  "day": 1,                                 // 1-5
  "sender": {
    "name": "박진수 형사",
    "department": "강남서 형사1팀",
    "badge": "형사 #20547"                   // 또는 "title"
  },
  "receiver": "프로파일링센터",
  "timestamp": "2025-10-28T10:15:00",       // ISO 8601
  "subject": "변사사건 배당 - 압구정동 자택",
  "importance": 3,                          // 1-5
  "isUrgent": false,                        // 옵션 (Day 2 E04만 true)
  "hasAttachments": true,
  "attachmentCount": 2,                     // 옵션
  "body": {
    "greeting": "...",                      // 인사말 (옵션)
    "urgentNotice": "...",                  // 긴급 알림 (옵션)
    "sections": [
      {
        "title": "사건 개요",
        "content": [
          "피해자: 강민호 (46세, 남성)",
          "직업: VisionTech 대표이사",
          "..."
        ]
      }
    ],
    "closing": "첨부파일을 확인하시고 초기 분석 부탁드립니다."
  },
  "attachments": [
    {
      "filename": "현장사진_01.jpg",
      "type": "image/jpeg",                 // MIME type
      "size": "2.3 MB",
      "assetId": "e01_attach_01"            // 실제 파일 연결 ID
    },
    {
      "filename": "피해자_기본정보.pdf",
      "type": "application/pdf",
      "size": "156 KB",
      "assetId": "e01_attach_02"
    }
  ]
}
```

**Day 5 구조 (간소화):**
```json
{
  "id": "E13",
  "day": 5,
  "sender": {
    "name": "최민석",
    "department": "국립과학수사연구원",
    "title": "수석연구관"
  },
  "receiver": "프로파일링센터",
  "timestamp": "2025-11-01T09:00:00",
  "subject": "최종 분석 결과 - 낚싯줄, 발자국",
  "importance": 5,
  "hasAttachments": true,
  "attachments": [
    {
      "id": "e13_attach_01",                // ⚠️ "assetId" 대신 "id"
      "filename": "낚싯줄_제조사_분석.pdf",
      "type": "pdf"                          // ⚠️ MIME type 아님
    }
  ],
  "body": {
    "greeting": "...",
    "sections": [...],
    "closing": "..."
  }
}
```

**일관성 문제:**
1. Day 1-4: `assetId` vs Day 5: `id`
2. Day 1-4: `"type": "image/jpeg"` vs Day 5: `"type": "pdf"`
3. Day 1-4: `"size"` 필드 있음 vs Day 5: 없음
4. Day 1-4: `attachmentCount` 있음 vs Day 5: 없음

**권장 표준 (사용자가 수정할 때):**
```json
{
  "attachments": [
    {
      "assetId": "e13_attach_01",           // ✅ 통일
      "filename": "낚싯줄_제조사_분석.pdf",
      "type": "application/pdf",            // ✅ MIME type
      "size": "1.2 MB"                      // ✅ 추가
    }
  ]
}
```

### 3.2 첨부파일 연결 규칙

#### 3.2.1 assetId → 실제 파일 매핑

**방법 1: 직접 경로 매핑**
```dart
// lib/data/repositories/asset_repository.dart

class AssetRepository {
  String getAttachmentPath(String assetId) {
    // assetId 파싱
    final parts = assetId.split('_');
    final emailId = parts[0]; // "e01"
    final attachNum = parts[2]; // "01"

    // Day 추정 (E01-E03: Day 1, E04-E06: Day 2, ...)
    final day = _getDayFromEmailId(emailId);

    // 실제 파일 찾기
    return 'assets/day$day/attachments/${emailId}_*.md';
  }
}
```

**방법 2: 매핑 테이블 사용 (권장)**
```json
// assets/data/attachment_mappings.json
{
  "e01_attach_01": "day1/attachments/이미지_사건현장_e01_crime_scene_photo",
  "e01_attach_02": "day1/attachments/e01_victim_profile_auto.md",
  "e02_attach_01": "day1/attachments/e02_floor_plan.md",
  "e02_attach_02": "day1/attachments/e02_lock_photos.md",
  "e04_attach_01": "day2/attachments/e04__autopsy_report.md",
  "e13_attach_01": "day5/attachments/e13_fishing_line_analysis.md",
  "e13_attach_02": "day5/attachments/e13_footprint_detail.jpg"
}
```

#### 3.2.2 Enhanced 파일 연결 규칙

**보강 수사는 이메일과 독립적으로 관리:**

```json
// assets/data/enhanced_mappings.json
{
  "e02": [
    "enhanced/e02_enhanced_01_garden_report.md",
    "enhanced/e02_enhanced_02_roof_access.md",
    "enhanced/e02_enhanced_03_neighbor_interview.md"
  ],
  "e05": [
    "enhanced/e05_enhanced_02_witnesses_recheck.md",
    "enhanced/e05_enhanced_03_delivery_driver.md",
    "enhanced/e05_enhanced_04_gps_analysis.md"
  ],
  "e06": [
    "enhanced/e06_enhanced_01_drug_family.md"
  ],
  "e07": [
    "enhanced/e07_enhanced_01_final_warning.md"
  ],
  "e09": [
    "enhanced/e09_enhanced_01_netflix_log.md"
  ]
}
```

**사용 예시:**
```dart
class EnhancedInvestigationRepository {
  List<String> getEnhancedFiles(String emailId) {
    // 매핑 테이블에서 조회
    return enhancedMappings[emailId] ?? [];
  }
}
```

---

## 4. Phase 2 진행 계획 (Week 4-6)

### 4.1 Week 4: 데이터 모델 및 JSON

**목표:** Email, Suspect, Evidence 모델 정의 및 JSON 파싱

#### Step 1: 데이터 모델 클래스 작성

```dart
// lib/data/models/email.dart
@JsonSerializable()
class Email {
  final String id;
  final int day;
  final EmailSender sender;
  final String receiver;
  final DateTime timestamp;
  final String subject;
  final int importance;
  final bool? isUrgent;
  final bool hasAttachments;
  final int? attachmentCount;
  final EmailBody body;
  final List<EmailAttachment> attachments;

  Email({...});

  factory Email.fromJson(Map<String, dynamic> json) => _$EmailFromJson(json);
  Map<String, dynamic> toJson() => _$EmailToJson(this);
}

@JsonSerializable()
class EmailSender {
  final String name;
  final String department;
  final String? badge;
  final String? title;

  EmailSender({...});

  factory EmailSender.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}

@JsonSerializable()
class EmailBody {
  final String? greeting;
  final String? urgentNotice;
  final List<EmailSection> sections;
  final String closing;

  EmailBody({...});

  factory EmailBody.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}

@JsonSerializable()
class EmailSection {
  final String title;
  final List<String> content;

  EmailSection({...});

  factory EmailSection.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}

@JsonSerializable()
class EmailAttachment {
  @JsonKey(name: 'assetId')  // Day 1-4
  final String? assetIdOld;

  @JsonKey(name: 'id')       // Day 5
  final String? idNew;

  final String filename;
  final String type;
  final String? size;

  EmailAttachment({...});

  // assetId 통일 getter
  String get assetId => assetIdOld ?? idNew ?? '';

  factory EmailAttachment.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

#### Step 2: AssetLoader 구현

```dart
// lib/data/services/asset_loader.dart
class AssetLoader {
  // 이메일 JSON 로드
  Future<List<Email>> loadEmailsForDay(int day) async {
    final jsonString = await rootBundle.loadString(
      'assets/day$day/emails/*.json',  // 와일드카드는 안 되므로 수동 리스트
    );

    // Day별 이메일 파일명 리스트
    final fileNames = _getEmailFileNamesForDay(day);

    final emails = <Email>[];
    for (final fileName in fileNames) {
      final path = 'assets/day$day/emails/$fileName';
      final jsonString = await rootBundle.loadString(path);
      final json = jsonDecode(jsonString);
      emails.add(Email.fromJson(json));
    }

    return emails;
  }

  List<String> _getEmailFileNamesForDay(int day) {
    switch (day) {
      case 1:
        return [
          'e01_case_assignment.json',
          'e02_crime_scene.json',
          'e03_suspects_initial_auto.json',
        ];
      case 2:
        return [
          'e04_autopsy.json',
          'e05_alibi_check.json',
          'e06_drug_tracking.json',
        ];
      case 3:
        return [
          'e07_embezzlement.json',
          'e08_inheritance.json',
          'e09_communication.json',
        ];
      case 4:
        return [
          'e10_kim_laptop.json',
          'e11_footprints.json',
          'e12_summary.json',
        ];
      case 5:
        return [
          'email_e13.json',  // ⚠️ 나중에 수정
          'email_e14.json',
        ];
      default:
        return [];
    }
  }

  // 첨부파일 Markdown 로드
  Future<String> loadAttachment(String assetId) async {
    final path = _getAttachmentPath(assetId);
    return await rootBundle.loadString(path);
  }

  String _getAttachmentPath(String assetId) {
    // 매핑 테이블 로드 (미리 로드된 Map)
    return _attachmentMappings[assetId] ?? '';
  }

  // Enhanced 파일 로드
  Future<List<String>> loadEnhancedFiles(String emailId) async {
    final paths = _getEnhancedPaths(emailId);

    final contents = <String>[];
    for (final path in paths) {
      final content = await rootBundle.loadString('assets/$path');
      contents.add(content);
    }

    return contents;
  }

  List<String> _getEnhancedPaths(String emailId) {
    // 매핑 테이블 로드 (미리 로드된 Map)
    return _enhancedMappings[emailId] ?? [];
  }
}
```

#### Step 3: 매핑 테이블 JSON 작성

```json
// assets/data/attachment_mappings.json
{
  "e01_attach_01": "이미지_사건현장_e01_crime_scene_photo",
  "e01_attach_02": "day1/attachments/e01_victim_profile_auto.md",
  ...
}
```

```json
// assets/data/enhanced_mappings.json
{
  "e02": [
    "enhanced/e02_enhanced_01_garden_report.md",
    "enhanced/e02_enhanced_02_roof_access.md",
    "enhanced/e02_enhanced_03_neighbor_interview.md"
  ],
  ...
}
```

#### Step 4: Day 1 이메일 3개 테스트

```dart
void main() async {
  final loader = AssetLoader();

  // Day 1 이메일 로드
  final emails = await loader.loadEmailsForDay(1);

  print('이메일 개수: ${emails.length}');
  print('첫 번째 이메일: ${emails[0].subject}');

  // 첨부파일 로드
  final attachment = await loader.loadAttachment('e01_attach_02');
  print('첨부파일 내용: ${attachment.substring(0, 100)}...');
}
```

### 4.2 Week 5: Hive 로컬 저장소

**목표:** GameState 저장/로드, Hive TypeAdapter 구현

#### Step 1: Hive TypeAdapter

```dart
// lib/data/models/game_state.dart
@HiveType(typeId: 0)
class GameState {
  @HiveField(0)
  int currentDay;

  @HiveField(1)
  DateTime currentTime;

  @HiveField(2)
  int tokenBalance;

  @HiveField(3)
  List<String> readEmailIds;

  @HiveField(4)
  List<String> unlockedEvidenceIds;

  @HiveField(5)
  Map<String, String> suspectNotes;

  @HiveField(6)
  List<String> completedEnhancedInvestigations;

  @HiveField(7)
  bool canSubmitAnswer;

  @HiveField(8)
  String? submittedSuspect;

  GameState({...});
}
```

#### Step 2: StorageService 구현

```dart
// lib/data/services/storage_service.dart
class StorageService {
  static const String _gameStateKey = 'game_state';

  late Box<GameState> _gameStateBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(GameStateAdapter());

    _gameStateBox = await Hive.openBox<GameState>('gameState');
  }

  Future<void> saveGameState(GameState state) async {
    await _gameStateBox.put(_gameStateKey, state);
  }

  GameState? loadGameState() {
    return _gameStateBox.get(_gameStateKey);
  }

  Future<void> deleteGameState() async {
    await _gameStateBox.delete(_gameStateKey);
  }
}
```

### 4.3 Week 6: Riverpod 상태 관리

**목표:** GameStateProvider, EmailProvider, TokenProvider 구현

#### Step 1: GameStateProvider

```dart
// lib/presentation/providers/game_state_provider.dart
final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((ref) {
  return GameStateNotifier(ref.read(storageServiceProvider));
});

class GameStateNotifier extends StateNotifier<GameState> {
  final StorageService _storageService;

  GameStateNotifier(this._storageService) : super(_loadInitialState(_storageService));

  static GameState _loadInitialState(StorageService storage) {
    return storage.loadGameState() ?? GameState.initial();
  }

  void advanceDay() {
    state = state.copyWith(
      currentDay: state.currentDay + 1,
      currentTime: DateTime.now(),
    );
    _saveState();
  }

  void markEmailAsRead(String emailId) {
    final newReadEmails = [...state.readEmailIds, emailId];
    state = state.copyWith(readEmailIds: newReadEmails);
    _saveState();
  }

  void _saveState() {
    _storageService.saveGameState(state);
  }
}
```

#### Step 2: EmailProvider

```dart
// lib/presentation/providers/email_provider.dart
final emailProvider = FutureProvider.family<List<Email>, int>((ref, day) async {
  final loader = ref.read(assetLoaderProvider);
  return await loader.loadEmailsForDay(day);
});

final currentDayEmailsProvider = Provider<AsyncValue<List<Email>>>((ref) {
  final currentDay = ref.watch(gameStateProvider.select((state) => state.currentDay));
  return ref.watch(emailProvider(currentDay));
});
```

#### Step 3: TokenProvider

```dart
// lib/presentation/providers/token_provider.dart
final tokenProvider = StateNotifierProvider<TokenNotifier, int>((ref) {
  return TokenNotifier(ref);
});

class TokenNotifier extends StateNotifier<int> {
  final Ref _ref;

  TokenNotifier(this._ref) : super(_loadInitialBalance(_ref));

  static int _loadInitialBalance(Ref ref) {
    final gameState = ref.read(gameStateProvider);
    return gameState.tokenBalance;
  }

  bool canAfford(int cost) {
    return state >= cost;
  }

  void spend(int amount) {
    if (!canAfford(amount)) {
      throw InsufficientTokenException();
    }

    state -= amount;
    _updateGameState();
  }

  void earn(int amount) {
    state += amount;
    _updateGameState();
  }

  void _updateGameState() {
    final gameState = _ref.read(gameStateProvider);
    _ref.read(gameStateProvider.notifier).updateTokenBalance(state);
  }
}
```

---

## 5. 사용자 작업 체크리스트

### 5.1 파일 네이밍 일관성 수정 (선택적)

**Day 5 이메일:**
- [ ] `email_e13.json` → `e13_final_analysis.json`
- [ ] `email_e14.json` → `e14_novel_manuscript.json`

**Enhanced 파일 (옵션 A 또는 B 선택):**

**옵션 A - 괄호 제거:**
- [ ] `(e05)_enhanced_04_gps_analysis.md` → `e05_enhanced_04_gps_analysis.md`
- [ ] `(e06)_enhanced_01_drug_family.md` → `e06_enhanced_01_drug_family.md`
- [ ] `(e07)_enhanced_01_final_warning.md` → `e07_enhanced_01_final_warning.md`
- [ ] `(e09)_enhanced_01_netflix_log.md` → `e09_enhanced_01_netflix_log.md`

**옵션 B - 괄호 사용:**
- [ ] `e02_enhanced_01_garden_report.md` → `(e02)_enhanced_01_garden_report.md`
- [ ] `e02_enhanced_02_roof_access.md` → `(e02)_enhanced_02_roof_access.md`
- [ ] `e02_enhanced_03_neighbor_interview.md` → `(e02)_enhanced_03_neighbor_interview.md`
- [ ] `e05_enhanced_02_witnesses_recheck.md` → `(e05)_enhanced_02_witnesses_recheck.md`
- [ ] `e05_enhanced_03_delivery_driver.md` → `(e05)_enhanced_03_delivery_driver.md`

### 5.2 JSON 구조 일관성 수정

**Day 5 이메일 (email_e13.json, email_e14.json):**
- [ ] `"id"` → `"assetId"`로 변경
- [ ] `"type": "pdf"` → `"type": "application/pdf"`로 변경
- [ ] `"size"` 필드 추가

### 5.3 매핑 테이블 작성

- [ ] `assets/data/attachment_mappings.json` 작성
- [ ] `assets/data/enhanced_mappings.json` 작성

---

## 6. Phase 2 성공 기준

**Week 4 완료 시:**
- [ ] Email 모델 클래스 완성 및 json_serializable 적용
- [ ] AssetLoader로 Day 1 이메일 3개 로드 성공
- [ ] 첨부파일 Markdown 로드 성공

**Week 5 완료 시:**
- [ ] Hive TypeAdapter 작성 완료
- [ ] GameState 저장/로드 테스트 성공
- [ ] StorageService 구현 완료

**Week 6 완료 시:**
- [ ] GameStateProvider, EmailProvider, TokenProvider 작동
- [ ] 홈화면에서 실제 데이터 표시 (Day 1 이메일 개수 뱃지)
- [ ] Day 진행 시 이메일 자동 해금 로직 작동

---

## 7. 다음 단계 (Phase 3)

Phase 2 완료 후:
- Phase 3 Week 7-9: 실제 화면 구현 + 데이터 연결
  - EmailListScreen (실제 이메일 데이터 표시)
  - EmailDetailScreen (Markdown 렌더링)
  - CaseFilesScreen
  - EvidenceScreen

---

**작성자**: Claude Code Assistant
**작성일**: 2025-10-06
**버전**: 1.0
