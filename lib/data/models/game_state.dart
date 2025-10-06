import 'package:hive/hive.dart';

part 'game_state.g.dart';

/// 게임 상태 모델
///
/// Hive를 사용한 로컬 저장소에 저장됨
@HiveType(typeId: 0)
class GameState {
  /// 현재 Day (1-5)
  @HiveField(0)
  final int currentDay;

  /// 현재 시각
  @HiveField(1)
  final DateTime currentTime;

  /// 토큰 잔액
  @HiveField(2)
  final int tokenBalance;

  /// 읽은 이메일 ID 목록
  @HiveField(3)
  final List<String> readEmailIds;

  /// 해금된 증거물 ID 목록
  @HiveField(4)
  final List<String> unlockedEvidenceIds;

  /// 용의자별 메모
  @HiveField(5)
  final Map<String, String> suspectNotes;

  /// 완료된 보강 수사 목록 (Deprecated - 사용 안 함)
  @HiveField(6)
  final List<String> completedEnhancedInvestigations;

  /// Day 5에 제출 가능 여부
  @HiveField(7)
  final bool canSubmitAnswer;

  /// 제출한 용의자 ID
  @HiveField(8)
  final String? submittedSuspect;

  /// ⭐ 보강수사 요청한 이메일 ID 목록
  /// 예: ["E02", "E05", "E06"]
  @HiveField(9)
  final List<String> requestedEnhancedInvestigations;

  /// ⭐ 이메일별 추가된 enhanced 파일 경로 목록
  /// 예: {"E05": ["enhanced/e05_enhanced_02_...", "enhanced/e05_enhanced_03_..."]}
  @HiveField(10)
  final Map<String, List<String>> emailEnhancedFiles;

  /// ⭐ Day 5에 E15로 전달할 파일 목록
  /// 예: ["enhanced/e05_5day_...", "enhanced/e06_5day_...", ...]
  @HiveField(11)
  final List<String> day5EnhancedFilesToDeliver;

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

  /// 초기 게임 상태 생성
  factory GameState.initial() {
    return GameState(
      currentDay: 1,
      currentTime: DateTime(2025, 10, 28, 10, 0), // Day 1: 2025-10-28 10:00
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

  /// 복사본 생성 (불변성 유지)
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
      completedEnhancedInvestigations:
          completedEnhancedInvestigations ?? this.completedEnhancedInvestigations,
      canSubmitAnswer: canSubmitAnswer ?? this.canSubmitAnswer,
      submittedSuspect: submittedSuspect ?? this.submittedSuspect,
      requestedEnhancedInvestigations:
          requestedEnhancedInvestigations ?? this.requestedEnhancedInvestigations,
      emailEnhancedFiles: emailEnhancedFiles ?? this.emailEnhancedFiles,
      day5EnhancedFilesToDeliver:
          day5EnhancedFilesToDeliver ?? this.day5EnhancedFilesToDeliver,
    );
  }

  @override
  String toString() {
    return 'GameState('
        'currentDay: $currentDay, '
        'tokenBalance: $tokenBalance, '
        'readEmails: ${readEmailIds.length}, '
        'requestedEnhanced: ${requestedEnhancedInvestigations.length}'
        ')';
  }
}
