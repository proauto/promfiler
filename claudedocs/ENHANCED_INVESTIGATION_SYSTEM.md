# 보강 수사 시스템 설계 문서

> **작성일**: 2025-10-06
> **목적**: 복잡한 보강 수사 시스템의 완전한 설계 및 구현 가이드
> **난이도**: ⭐⭐⭐⭐⭐ (매우 높음 - 신중한 구현 필요)

---

## 📋 목차

1. [시스템 개요](#1-시스템-개요)
2. [파일 분류 및 매핑](#2-파일-분류-및-매핑)
3. [게임 플로우](#3-게임-플로우)
4. [데이터 구조 설계](#4-데이터-구조-설계)
5. [핵심 로직 구현](#5-핵심-로직-구현)
6. [E15 이메일 설계](#6-e15-이메일-설계)
7. [테스트 시나리오](#7-테스트-시나리오)

---

## 1. 시스템 개요

### 1.1 보강 수사란?

**기능**: 플레이어가 특정 이메일에 대해 추가 조사를 요청하는 시스템

**비용**: 토큰 소모 (예: 50 토큰)

**효과**: 다음 날 해당 이메일에 새로운 첨부파일 추가

### 1.2 두 가지 보강 수사 타입

#### Type A: 일반 보강 수사

**동작:**
1. Day N에 보강수사 요청
2. Day N+1에:
   - 원래 이메일이 "안읽음"으로 변경 ✨
   - 새로운 첨부파일 추가

**예시:**
- E02 보강수사 요청 (Day 1)
- Day 2에 E02가 "안읽음" + 3개 파일 추가
  - e02_enhanced_01_garden_report.md
  - e02_enhanced_02_roof_access.md
  - e02_enhanced_03_neighbor_interview.md

#### Type B: Day 5 특수 보강 수사

**동작:**
1. Day N에 보강수사 요청
2. Day N+1에:
   - **일반 파일만** 원래 이메일에 추가
   - **5day 파일은 추가 안 함** (보류)
3. Day 5에:
   - E15 특수 이메일 도착
   - **모든 5day 파일**을 E15에 첨부

**예시:**
- E05 보강수사 요청 (Day 2)
- Day 3에 E05에 추가:
  - e05_enhanced_02_witnesses_recheck.md ✅
  - e05_enhanced_03_delivery_driver.md ✅
  - e05_5day_enhanced_04_gps_analysis.md ❌ (추가 안 함)
- Day 5에 E15에 추가:
  - e05_5day_enhanced_04_gps_analysis.md ✅

---

## 2. 파일 분류 및 매핑

### 2.1 Enhanced 파일 전체 목록

```
assets/enhanced/
├── e02_enhanced_01_garden_report.md           [Type A]
├── e02_enhanced_02_roof_access.md             [Type A]
├── e02_enhanced_03_neighbor_interview.md      [Type A]
├── e05_enhanced_02_witnesses_recheck.md       [Type A]
├── e05_enhanced_03_delivery_driver.md         [Type A]
├── e05_5day_enhanced_04_gps_analysis.md       [Type B] ⭐
├── e06_5day_enhanced_01_drug_family.md        [Type B] ⭐
├── e07_5day_enhanced_01_final_warning.md      [Type B] ⭐
└── e09_5day_enhanced_01_netflix_log.md        [Type B] ⭐
```

### 2.2 이메일별 보강수사 파일 매핑

```json
// assets/data/enhanced_mappings.json
{
  "E02": {
    "normal": [
      "enhanced/e02_enhanced_01_garden_report.md",
      "enhanced/e02_enhanced_02_roof_access.md",
      "enhanced/e02_enhanced_03_neighbor_interview.md"
    ],
    "day5": []
  },
  "E05": {
    "normal": [
      "enhanced/e05_enhanced_02_witnesses_recheck.md",
      "enhanced/e05_enhanced_03_delivery_driver.md"
    ],
    "day5": [
      "enhanced/e05_5day_enhanced_04_gps_analysis.md"
    ]
  },
  "E06": {
    "normal": [],
    "day5": [
      "enhanced/e06_5day_enhanced_01_drug_family.md"
    ]
  },
  "E07": {
    "normal": [],
    "day5": [
      "enhanced/e07_5day_enhanced_01_final_warning.md"
    ]
  },
  "E09": {
    "normal": [],
    "day5": [
      "enhanced/e09_5day_enhanced_01_netflix_log.md"
    ]
  }
}
```

### 2.3 Day 5 특수 파일 의미 분석

**모든 Day 5 파일은 게임 후반부의 결정적 증거입니다:**

| 파일 | 이메일 | 내용 | 중요도 |
|------|--------|------|--------|
| e05_5day_enhanced_04_gps_analysis.md | E05 | GPS 교차 검증 - 김수현 모바일 접속 의문 | ⭐⭐⭐⭐⭐ |
| e06_5day_enhanced_01_drug_family.md | E06 | 한지은 모친 디곡신 처방 기록 | ⭐⭐⭐⭐⭐ |
| e07_5day_enhanced_01_final_warning.md | E07 | 최후통첩 녹취록 - 김수현/박준영 동기 명확 | ⭐⭐⭐⭐⭐ |
| e09_5day_enhanced_01_netflix_log.md | E09 | 넷플릭스 로그 - 김수현 알리바이 의문 | ⭐⭐⭐⭐⭐ |

**게임 디자인 의도:**
- Day 1-4: 플레이어가 혼란스러움 (여러 용의자 가능성)
- Day 5: 결정적 증거 제공 → 진범 확신

---

## 3. 게임 플로우

### 3.1 시나리오 예시: E05 보강수사

**Day 2 (화요일)**
```
플레이어:
1. E05 이메일 수신 (알리바이 확인 결과)
2. E05 읽음 → 읽음 표시 ✓
3. 보강수사 요청 (50 토큰 소모)

시스템:
- requestedEnhancedInvestigations: ["E05"]
- Day 2 종료
```

**Day 2 → Day 3 전환 시**
```
시스템 처리:
1. E05가 보강수사 요청됨 확인
2. enhanced_mappings.json에서 E05 파일 조회:
   - normal: ["e05_enhanced_02_...", "e05_enhanced_03_..."]
   - day5: ["e05_5day_enhanced_04_..."]

3. E05 이메일 상태 변경:
   - isRead: false  ✨ (안읽음으로 변경)
   - hasNewEnhancedFiles: true

4. E05 첨부파일에 normal 파일만 추가:
   - e05_enhanced_02_witnesses_recheck.md ✅
   - e05_enhanced_03_delivery_driver.md ✅
   - e05_5day_enhanced_04 는 추가 안 함 ❌

5. emailEnhancedFiles 업데이트:
   {
     "E05": ["e05_enhanced_02", "e05_enhanced_03"]
   }
```

**Day 3 (수요일)**
```
플레이어:
1. 메일함 확인
2. E05가 "안읽음" 상태로 표시됨 (뱃지 표시)
3. E05 클릭 → 새 첨부파일 2개 확인
4. 첨부파일 읽기
```

**Day 4 (목요일)**
```
아무 변화 없음
```

**Day 4 → Day 5 전환 시**
```
시스템 처리:
1. Day 5 도달 확인
2. 모든 보강수사 요청된 이메일 조회
3. day5 파일 수집:
   - E05 → e05_5day_enhanced_04_gps_analysis.md
   - E06 → e06_5day_enhanced_01_drug_family.md
   - E07 → e07_5day_enhanced_01_final_warning.md
   - E09 → e09_5day_enhanced_01_netflix_log.md

4. E15 이메일 생성:
   - 위 4개 파일을 모두 첨부
   - subject: "보강수사 최종 분석 결과"
```

**Day 5 (금요일)**
```
플레이어:
1. E15 이메일 확인 (새 이메일)
2. 첨부파일 4개 확인
3. 결정적 증거 획득
4. 진범 확신
```

### 3.2 Edge Case: 보강수사 요청 안 한 경우

**플레이어가 E05 보강수사 요청 안 함:**

**Day 3**: E05 변화 없음

**Day 5**:
- E15 도착
- E05의 day5 파일 **첨부 안 됨**
- 다른 보강수사 요청한 이메일의 day5 파일만 첨부

**결과**: 플레이어가 중요한 증거 놓침 (게임 디자인 의도)

---

## 4. 데이터 구조 설계

### 4.1 GameState 확장

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
  List<String> completedEnhancedInvestigations;  // ⚠️ 사용 안 함 (삭제 예정)

  @HiveField(7)
  bool canSubmitAnswer;

  @HiveField(8)
  String? submittedSuspect;

  // ⭐ 신규 필드
  @HiveField(9)
  List<String> requestedEnhancedInvestigations;  // 보강수사 요청한 이메일 ID 목록
  // 예: ["E02", "E05", "E06"]

  @HiveField(10)
  Map<String, List<String>> emailEnhancedFiles;  // 이메일별 추가된 enhanced 파일 경로
  // 예: {"E05": ["enhanced/e05_enhanced_02_...", "enhanced/e05_enhanced_03_..."]}

  @HiveField(11)
  List<String> day5EnhancedFilesToDeliver;  // Day 5에 E15로 전달할 파일 목록
  // 예: ["enhanced/e05_5day_enhanced_04_...", "enhanced/e06_5day_enhanced_01_..."]

  GameState({
    required this.currentDay,
    required this.currentTime,
    required this.tokenBalance,
    required this.readEmailIds,
    required this.unlockedEvidenceIds,
    required this.suspectNotes,
    required this.completedEnhancedInvestigations,
    required this.canSubmitAnswer,
    this.submittedSuspect,
    this.requestedEnhancedInvestigations = const [],
    this.emailEnhancedFiles = const {},
    this.day5EnhancedFilesToDeliver = const [],
  });

  // 복사 메서드
  GameState copyWith({
    int? currentDay,
    DateTime? currentTime,
    int? tokenBalance,
    List<String>? readEmailIds,
    List<String>? unlockedEvidenceIds,
    Map<String, String>? suspectNotes,
    List<String>? completedEnhancedInvestigations,
    bool? canSubmitAnswer,
    String? submittedSuspect,
    List<String>? requestedEnhancedInvestigations,
    Map<String, List<String>>? emailEnhancedFiles,
    List<String>? day5EnhancedFilesToDeliver,
  }) {
    return GameState(
      currentDay: currentDay ?? this.currentDay,
      currentTime: currentTime ?? this.currentTime,
      tokenBalance: tokenBalance ?? this.tokenBalance,
      readEmailIds: readEmailIds ?? this.readEmailIds,
      unlockedEvidenceIds: unlockedEvidenceIds ?? this.unlockedEvidenceIds,
      suspectNotes: suspectNotes ?? this.suspectNotes,
      completedEnhancedInvestigations: completedEnhancedInvestigations ?? this.completedEnhancedInvestigations,
      canSubmitAnswer: canSubmitAnswer ?? this.canSubmitAnswer,
      submittedSuspect: submittedSuspect ?? this.submittedSuspect,
      requestedEnhancedInvestigations: requestedEnhancedInvestigations ?? this.requestedEnhancedInvestigations,
      emailEnhancedFiles: emailEnhancedFiles ?? this.emailEnhancedFiles,
      day5EnhancedFilesToDeliver: day5EnhancedFilesToDeliver ?? this.day5EnhancedFilesToDeliver,
    );
  }

  factory GameState.initial() {
    return GameState(
      currentDay: 1,
      currentTime: DateTime(2025, 10, 28, 10, 0),
      tokenBalance: 500,
      readEmailIds: [],
      unlockedEvidenceIds: [],
      suspectNotes: {},
      completedEnhancedInvestigations: [],
      canSubmitAnswer: false,
      requestedEnhancedInvestigations: [],
      emailEnhancedFiles: {},
      day5EnhancedFilesToDeliver: [],
    );
  }
}
```

### 4.2 Enhanced Mapping 모델

```dart
// lib/data/models/enhanced_mapping.dart
@JsonSerializable()
class EnhancedMapping {
  final String emailId;
  final List<String> normalFiles;  // Type A: 다음날 원래 이메일에 추가
  final List<String> day5Files;    // Type B: Day 5 E15에 추가

  EnhancedMapping({
    required this.emailId,
    required this.normalFiles,
    required this.day5Files,
  });

  factory EnhancedMapping.fromJson(Map<String, dynamic> json) => _$EnhancedMappingFromJson(json);
  Map<String, dynamic> toJson() => _$EnhancedMappingToJson(this);
}
```

### 4.3 Email 모델 확장

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

  // ⭐ 신규 필드 (런타임에만 사용, JSON 직렬화 안 함)
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool hasNewEnhancedFiles;  // 보강수사 파일 추가됨 표시

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<String> enhancedFilePaths;  // 추가된 enhanced 파일 경로 목록

  Email({
    required this.id,
    required this.day,
    required this.sender,
    required this.receiver,
    required this.timestamp,
    required this.subject,
    required this.importance,
    this.isUrgent,
    required this.hasAttachments,
    this.attachmentCount,
    required this.body,
    required this.attachments,
    this.hasNewEnhancedFiles = false,
    this.enhancedFilePaths = const [],
  });

  // 보강수사 파일 추가
  Email withEnhancedFiles(List<String> files) {
    return Email(
      id: id,
      day: day,
      sender: sender,
      receiver: receiver,
      timestamp: timestamp,
      subject: subject,
      importance: importance,
      isUrgent: isUrgent,
      hasAttachments: true,
      attachmentCount: (attachmentCount ?? attachments.length) + files.length,
      body: body,
      attachments: attachments,
      hasNewEnhancedFiles: true,
      enhancedFilePaths: files,
    );
  }

  factory Email.fromJson(Map<String, dynamic> json) => _$EmailFromJson(json);
  Map<String, dynamic> toJson() => _$EmailToJson(this);
}
```

---

## 5. 핵심 로직 구현

### 5.1 EnhancedInvestigationRepository

```dart
// lib/data/repositories/enhanced_investigation_repository.dart
class EnhancedInvestigationRepository {
  final AssetLoader _assetLoader;

  EnhancedInvestigationRepository(this._assetLoader);

  // enhanced_mappings.json 로드
  Future<Map<String, EnhancedMapping>> loadMappings() async {
    final jsonString = await _assetLoader.loadString('assets/data/enhanced_mappings.json');
    final Map<String, dynamic> json = jsonDecode(jsonString);

    final mappings = <String, EnhancedMapping>{};
    json.forEach((emailId, data) {
      mappings[emailId] = EnhancedMapping.fromJson({
        'emailId': emailId,
        'normalFiles': data['normal'],
        'day5Files': data['day5'],
      });
    });

    return mappings;
  }

  // 특정 이메일의 normal 파일 가져오기
  Future<List<String>> getNormalFiles(String emailId) async {
    final mappings = await loadMappings();
    return mappings[emailId]?.normalFiles ?? [];
  }

  // 특정 이메일의 day5 파일 가져오기
  Future<List<String>> getDay5Files(String emailId) async {
    final mappings = await loadMappings();
    return mappings[emailId]?.day5Files ?? [];
  }

  // Enhanced 파일 내용 로드
  Future<String> loadEnhancedFile(String path) async {
    return await _assetLoader.loadString('assets/$path');
  }
}
```

### 5.2 EnhancedInvestigationUseCase

```dart
// lib/domain/use_cases/enhanced_investigation_use_case.dart
class EnhancedInvestigationUseCase {
  final EnhancedInvestigationRepository _repository;
  final GameStateProvider _gameStateProvider;
  final TokenProvider _tokenProvider;

  static const int ENHANCED_COST = 50;

  EnhancedInvestigationUseCase(
    this._repository,
    this._gameStateProvider,
    this._tokenProvider,
  );

  // 보강수사 요청
  Future<void> requestEnhancedInvestigation(String emailId) async {
    // 1. 토큰 체크
    if (!_tokenProvider.canAfford(ENHANCED_COST)) {
      throw InsufficientTokenException();
    }

    // 2. 이미 요청했는지 체크
    final gameState = _gameStateProvider.state;
    if (gameState.requestedEnhancedInvestigations.contains(emailId)) {
      throw AlreadyRequestedException();
    }

    // 3. 토큰 차감
    _tokenProvider.spend(ENHANCED_COST);

    // 4. 요청 목록에 추가
    final newRequested = [...gameState.requestedEnhancedInvestigations, emailId];

    // 5. GameState 업데이트
    _gameStateProvider.updateState(
      gameState.copyWith(
        requestedEnhancedInvestigations: newRequested,
      ),
    );
  }

  // 보강수사 요청 여부 확인
  bool isRequested(String emailId) {
    final gameState = _gameStateProvider.state;
    return gameState.requestedEnhancedInvestigations.contains(emailId);
  }

  // Enhanced 파일이 추가되었는지 확인
  bool hasEnhancedFiles(String emailId) {
    final gameState = _gameStateProvider.state;
    return gameState.emailEnhancedFiles.containsKey(emailId);
  }

  // 특정 이메일의 Enhanced 파일 목록 가져오기
  List<String> getEnhancedFiles(String emailId) {
    final gameState = _gameStateProvider.state;
    return gameState.emailEnhancedFiles[emailId] ?? [];
  }
}
```

### 5.3 DayTransitionService (핵심 로직)

```dart
// lib/data/services/day_transition_service.dart
class DayTransitionService {
  final GameStateProvider _gameStateProvider;
  final EmailRepository _emailRepository;
  final EnhancedInvestigationRepository _enhancedRepository;

  DayTransitionService(
    this._gameStateProvider,
    this._emailRepository,
    this._enhancedRepository,
  );

  // Day 전환 시 호출
  Future<void> advanceToNextDay() async {
    final currentState = _gameStateProvider.state;
    final currentDay = currentState.currentDay;
    final nextDay = currentDay + 1;

    // 1. 보강수사 처리
    await _processEnhancedInvestigations(currentState, nextDay);

    // 2. GameState 업데이트 (Day 진행)
    _gameStateProvider.updateState(
      currentState.copyWith(
        currentDay: nextDay,
        currentTime: _calculateNextDayTime(currentDay),
        canSubmitAnswer: nextDay == 5,  // Day 5만 제출 가능
      ),
    );

    // 3. Day 5 특수 처리
    if (nextDay == 5) {
      await _createE15Email(currentState);
    }
  }

  // 보강수사 파일 처리
  Future<void> _processEnhancedInvestigations(
    GameState gameState,
    int nextDay,
  ) async {
    final requestedEmails = gameState.requestedEnhancedInvestigations;

    if (requestedEmails.isEmpty) return;

    final newEmailEnhancedFiles = Map<String, List<String>>.from(gameState.emailEnhancedFiles);
    final day5FilesToDeliver = List<String>.from(gameState.day5EnhancedFilesToDeliver);
    final updatedReadEmails = List<String>.from(gameState.readEmailIds);

    for (final emailId in requestedEmails) {
      // 이미 처리된 경우 스킵
      if (newEmailEnhancedFiles.containsKey(emailId)) continue;

      // Normal 파일 가져오기
      final normalFiles = await _enhancedRepository.getNormalFiles(emailId);

      if (normalFiles.isNotEmpty) {
        // Normal 파일 추가
        newEmailEnhancedFiles[emailId] = normalFiles;

        // 이메일을 "안읽음"으로 변경
        updatedReadEmails.remove(emailId);
      }

      // Day 5 파일 수집 (나중에 E15로 전달)
      final day5Files = await _enhancedRepository.getDay5Files(emailId);
      if (day5Files.isNotEmpty) {
        day5FilesToDeliver.addAll(day5Files);
      }
    }

    // GameState 업데이트
    _gameStateProvider.updateState(
      gameState.copyWith(
        emailEnhancedFiles: newEmailEnhancedFiles,
        day5EnhancedFilesToDeliver: day5FilesToDeliver,
        readEmailIds: updatedReadEmails,
      ),
    );
  }

  // Day 5 E15 이메일 생성
  Future<void> _createE15Email(GameState gameState) async {
    final day5Files = gameState.day5EnhancedFilesToDeliver;

    if (day5Files.isEmpty) {
      // 보강수사 요청 안 했으면 E15 생성 안 함
      return;
    }

    // E15 이메일 템플릿 로드
    final e15Template = await _emailRepository.loadEmail('E15');

    // Day 5 파일들을 첨부파일로 추가
    final enhancedAttachments = day5Files.map((path) {
      final filename = path.split('/').last.replaceAll('.md', '.pdf');
      return EmailAttachment(
        assetId: path,
        filename: filename,
        type: 'application/pdf',
        size: '1.2 MB',
      );
    }).toList();

    final e15WithAttachments = e15Template.copyWith(
      attachments: [...e15Template.attachments, ...enhancedAttachments],
      attachmentCount: e15Template.attachments.length + enhancedAttachments.length,
    );

    // E15 이메일 저장 (EmailRepository에 추가)
    await _emailRepository.saveEmail(e15WithAttachments);
  }

  DateTime _calculateNextDayTime(int currentDay) {
    // Day별 시간 설정
    final baseDate = DateTime(2025, 10, 28);
    return baseDate.add(Duration(days: currentDay));
  }
}
```

---

## 6. E15 이메일 설계

### 6.1 E15 이메일 내용 (수정 필요)

**현재 상태**: e14의 복사본 (김수현 PC 복구 내용)

**수정 후 내용**:

```json
{
  "id": "E15",
  "day": 5,
  "sender": {
    "name": "프로파일링센터",
    "department": "종합 분석팀",
    "title": "보강수사 총괄"
  },
  "receiver": "프로파일링센터",
  "timestamp": "2025-11-01T09:00:00",
  "subject": "⭐ 보강수사 최종 분석 결과",
  "importance": 5,
  "isUrgent": true,
  "hasAttachments": true,
  "body": {
    "urgentNotice": "⭐ 긴급: 보강수사로 요청하신 심층 분석 결과가 도착했습니다!",
    "sections": [
      {
        "title": "보강수사 개요",
        "content": [
          "지난 4일간 요청하신 보강수사를 완료했습니다.",
          "",
          "각 팀에서 추가 조사한 결과를 통합하여 전달드립니다.",
          "모든 분석 보고서를 첨부파일로 확인하실 수 있습니다."
        ]
      },
      {
        "title": "첨부 파일 목록",
        "content": [
          "첨부된 모든 파일은 사건 해결의 결정적 증거가 될 수 있습니다.",
          "",
          "주요 분석 내용:",
          "- GPS 및 차량 블랙박스 교차 검증",
          "- 디곡신 처방 기록 추적",
          "- 최후통첩 녹취록 복원",
          "- 넷플릭스 접속 로그 상세 분석",
          "",
          "⚠️ 모든 자료를 신중히 검토하시기 바랍니다.",
          "일부 정보는 용의자들의 진술과 상충될 수 있습니다."
        ]
      },
      {
        "title": "분석 팀 의견",
        "content": [
          "이번 보강수사를 통해 몇 가지 중요한 사실이 밝혀졌습니다.",
          "",
          "1. 용의자들의 알리바이에 의문점 발견",
          "2. 범행 도구의 출처 확인",
          "3. 범행 동기의 명확화",
          "",
          "최종 판단은 수사관님께 달려있습니다.",
          "신중히 검토하신 후 제출해주시기 바랍니다."
        ]
      }
    ],
    "closing": "보강수사 결과를 첨부합니다. 최종 제출 전 반드시 확인하시기 바랍니다.\n\n- 프로파일링센터 종합 분석팀"
  },
  "attachments": [
    // ⭐ 동적으로 추가됨 (Day 5 파일들)
    // {
    //   "assetId": "enhanced/e05_5day_enhanced_04_gps_analysis.md",
    //   "filename": "GPS_교차검증_최종.pdf",
    //   "type": "application/pdf",
    //   "size": "2.1 MB"
    // },
    // ...
  ]
}
```

### 6.2 E15 생성 로직 요약

**조건**: Day 5 도달 AND day5EnhancedFilesToDeliver가 비어있지 않음

**생성 방법**:
1. e15_enhancedmail.json 템플릿 로드
2. day5EnhancedFilesToDeliver의 파일들을 attachments에 추가
3. 최종 Email 객체 생성
4. EmailRepository에 등록

**결과**:
- 보강수사 요청한 경우: E15 도착 (첨부파일 1-4개)
- 보강수사 요청 안 한 경우: E15 도착 안 함 (또는 첨부파일 0개)

---

## 7. 테스트 시나리오

### 7.1 시나리오 A: 모든 보강수사 요청

**Day 1:**
- E02 보강수사 요청 ✅

**Day 2:**
- E02 안읽음 + 3개 파일 추가 ✅
- E05, E06 보강수사 요청 ✅

**Day 3:**
- E05 안읽음 + 2개 파일 추가 (e05_enhanced_02, e05_enhanced_03) ✅
- E06 변화 없음 (normal 파일 0개) ✅
- E07, E09 보강수사 요청 ✅

**Day 4:**
- E07, E09 변화 없음 (둘 다 normal 파일 0개) ✅

**Day 5:**
- E15 도착 ✅
- 첨부파일 4개:
  - e05_5day_enhanced_04_gps_analysis.md
  - e06_5day_enhanced_01_drug_family.md
  - e07_5day_enhanced_01_final_warning.md
  - e09_5day_enhanced_01_netflix_log.md

**예상 결과**: 완벽한 증거 수집 ✅

### 7.2 시나리오 B: 일부만 보강수사 요청

**Day 1:**
- E02 보강수사 요청 ✅

**Day 2:**
- E02 안읽음 + 3개 파일 추가 ✅
- E05 보강수사 요청 안 함 ❌

**Day 5:**
- E15 도착 ✅
- 첨부파일 0개 (E05 요청 안 해서 e05_5day 파일 없음)

**예상 결과**: 중요한 증거 누락 (GPS 교차 검증 못 봄) ❌

### 7.3 시나리오 C: 보강수사 전혀 안 함

**Day 1-4:**
- 아무 변화 없음

**Day 5:**
- E15 도착 안 함 (day5EnhancedFilesToDeliver가 빔)
- 또는 E15 도착하지만 첨부파일 0개

**예상 결과**: 게임 난이도 최고 (기본 증거만으로 추리해야 함) ⭐⭐⭐⭐⭐

---

## 8. 구현 우선순위

### Phase 2 Week 4-5: 데이터 모델

1. ✅ GameState 필드 추가
2. ✅ EnhancedMapping 모델 작성
3. ✅ Email 모델 확장
4. ✅ enhanced_mappings.json 작성

### Phase 2 Week 6: 로직 구현

1. ✅ EnhancedInvestigationRepository 구현
2. ✅ EnhancedInvestigationUseCase 구현
3. ✅ DayTransitionService 구현
4. ✅ E15 이메일 내용 수정

### Phase 3: UI 연결

1. 이메일 상세 화면에 "보강수사 요청" 버튼 추가
2. 이메일 목록에서 "안읽음" 표시
3. Enhanced 첨부파일 렌더링
4. E15 이메일 표시

---

## 9. 주의사항 ⚠️

### 9.1 복잡도 관리

**이 시스템은 매우 복잡합니다:**
- 3가지 상태 관리 (요청, normal 추가, day5 수집)
- 동적 이메일 생성 (E15)
- Day 전환 타이밍 처리

**권장 개발 방식:**
1. 데이터 모델부터 완벽히 구현
2. 단위 테스트 작성
3. 로직을 작은 함수로 분리
4. 각 단계별로 로그 출력하여 디버깅

### 9.2 테스트 필수

**반드시 테스트해야 할 케이스:**
- [ ] 보강수사 요청 → 다음날 파일 추가 확인
- [ ] 이메일 "안읽음" 전환 확인
- [ ] Day 5 E15 생성 확인
- [ ] 보강수사 안 한 경우 E15 미생성 확인
- [ ] 일부만 요청한 경우 E15 일부 첨부 확인

### 9.3 사용자 경험

**플레이어 관점:**
- 보강수사는 비용이 크므로 신중히 선택
- 보강수사 안 하면 증거 누락 가능
- Day 5 결정적 증거는 보강수사 없이 못 봄

**게임 밸런스:**
- 모든 보강수사 요청: 토큰 200-250 소모
- 초기 토큰 500 → 보강수사 4-5개 가능
- AI 분석도 해야 하므로 신중한 선택 필요

---

**작성자**: Claude Code Assistant
**작성일**: 2025-10-06
**버전**: 1.0
**난이도**: ⭐⭐⭐⭐⭐

**중요**: 이 시스템은 게임의 핵심 메커니즘입니다. 신중하게 구현하고 충분히 테스트하세요!
