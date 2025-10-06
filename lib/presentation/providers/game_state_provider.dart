import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/game_state.dart';
import '../../data/services/storage_service.dart';
import 'providers.dart';

/// GameState Provider (StateNotifier)
final gameStateProvider =
    StateNotifierProvider<GameStateNotifier, GameState>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return GameStateNotifier(storageService);
});

/// GameState Notifier
class GameStateNotifier extends StateNotifier<GameState> {
  final StorageService _storageService;

  GameStateNotifier(this._storageService)
      : super(_loadInitialState(_storageService));

  /// 현재 GameState 가져오기 (외부에서 사용)
  GameState get currentState => state;

  /// 초기 상태 로드 (저장된 게임 또는 새 게임)
  static GameState _loadInitialState(StorageService storage) {
    final savedState = storage.loadGameState();
    return savedState ?? GameState.initial();
  }

  /// Day 진행
  void advanceDay() {
    if (state.currentDay >= 5) {
      return; // Day 5 이상 진행 불가
    }

    final nextDay = state.currentDay + 1;
    state = state.copyWith(
      currentDay: nextDay,
      currentTime: _calculateNextDayTime(nextDay),
      canSubmitAnswer: nextDay == 5, // Day 5만 제출 가능
    );

    _saveState();
  }

  /// 이메일 읽음 표시
  void markEmailAsRead(String emailId) {
    if (state.readEmailIds.contains(emailId)) {
      return; // 이미 읽음
    }

    final newReadEmails = [...state.readEmailIds, emailId];
    state = state.copyWith(readEmailIds: newReadEmails);
    _saveState();
  }

  /// 이메일 안읽음으로 변경 (보강수사 파일 추가 시)
  void markEmailAsUnread(String emailId) {
    final newReadEmails = List<String>.from(state.readEmailIds);
    newReadEmails.remove(emailId);
    state = state.copyWith(readEmailIds: newReadEmails);
    _saveState();
  }

  /// 토큰 잔액 업데이트
  void updateTokenBalance(int newBalance) {
    state = state.copyWith(tokenBalance: newBalance);
    _saveState();
  }

  /// 토큰 차감
  /// 반환값: 차감 성공 여부
  bool spendTokens(int amount) {
    if (state.tokenBalance < amount) {
      return false; // 잔액 부족
    }

    final newBalance = state.tokenBalance - amount;
    state = state.copyWith(tokenBalance: newBalance);
    _saveState();
    return true;
  }

  /// 토큰 추가
  void addTokens(int amount) {
    final newBalance = state.tokenBalance + amount;
    state = state.copyWith(tokenBalance: newBalance);
    _saveState();
  }

  /// 토큰 잔액 확인
  bool canAffordTokens(int amount) {
    return state.tokenBalance >= amount;
  }

  /// 보강수사 요청 추가
  void addEnhancedInvestigation(String emailId) {
    if (state.requestedEnhancedInvestigations.contains(emailId)) {
      return; // 이미 요청됨
    }

    final newRequested = [...state.requestedEnhancedInvestigations, emailId];
    state = state.copyWith(requestedEnhancedInvestigations: newRequested);
    _saveState();
  }

  /// 이메일별 Enhanced 파일 추가
  void addEmailEnhancedFiles(String emailId, List<String> files) {
    final newEmailEnhancedFiles =
        Map<String, List<String>>.from(state.emailEnhancedFiles);
    newEmailEnhancedFiles[emailId] = files;

    state = state.copyWith(emailEnhancedFiles: newEmailEnhancedFiles);
    _saveState();
  }

  /// Day 5 파일 수집
  void addDay5EnhancedFiles(List<String> files) {
    final newDay5Files = [
      ...state.day5EnhancedFilesToDeliver,
      ...files,
    ];

    state = state.copyWith(day5EnhancedFilesToDeliver: newDay5Files);
    _saveState();
  }

  /// 용의자 메모 업데이트
  void updateSuspectNote(String suspectId, String note) {
    final newNotes = Map<String, String>.from(state.suspectNotes);
    newNotes[suspectId] = note;

    state = state.copyWith(suspectNotes: newNotes);
    _saveState();
  }

  /// 최종 제출
  void submitAnswer(String suspectId) {
    if (!state.canSubmitAnswer) {
      return; // Day 5 아니면 제출 불가
    }

    state = state.copyWith(submittedSuspect: suspectId);
    _saveState();
  }

  /// 게임 초기화
  Future<void> resetGame() async {
    await _storageService.deleteGameState();
    state = GameState.initial();
  }

  /// 상태 저장
  void _saveState() {
    _storageService.saveGameState(state);
  }

  /// Day별 시간 계산
  DateTime _calculateNextDayTime(int day) {
    // 2025-10-28 (Day 1) 기준으로 계산
    final baseDate = DateTime(2025, 10, 28);
    return baseDate.add(Duration(days: day - 1));
  }
}
