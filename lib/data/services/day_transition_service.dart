import '../repositories/email_repository.dart';
import '../repositories/enhanced_investigation_repository.dart';
import '../../presentation/providers/game_state_provider.dart';

/// Day 전환 서비스
///
/// 역할:
/// - Day 진행 시 보강수사 파일 처리
/// - Normal 파일: 해당 이메일에 추가 + 이메일 "안읽음"으로 변경
/// - Day 5 파일: GameState에 수집 (E15로 전달 예정)
/// - Day 5 도달 시 E15 이메일 생성
class DayTransitionService {
  final GameStateNotifier _gameStateNotifier;
  final EmailRepository _emailRepository;
  final EnhancedInvestigationRepository _enhancedRepository;

  DayTransitionService(
    this._gameStateNotifier,
    this._emailRepository,
    this._enhancedRepository,
  );

  /// Day 전환 시 호출
  Future<void> advanceToNextDay() async {
    final currentState = _gameStateNotifier.currentState;
    final currentDay = currentState.currentDay;
    final nextDay = currentDay + 1;

    if (nextDay > 5) {
      // Day 5 이후 진행 불가
      return;
    }

    // 1. 보강수사 처리
    await _processEnhancedInvestigations();

    // 2. Day 진행 (GameStateProvider의 advanceDay 호출)
    _gameStateNotifier.advanceDay();

    // 3. Day 5 특수 처리 (E15 이메일 생성은 나중에 구현)
    // if (nextDay == 5) {
    //   await _createE15Email();
    // }
  }

  /// 보강수사 파일 처리
  Future<void> _processEnhancedInvestigations() async {
    final gameState = _gameStateNotifier.currentState;
    final requestedEmails = gameState.requestedEnhancedInvestigations;

    if (requestedEmails.isEmpty) return;

    for (final emailId in requestedEmails) {
      // 이미 처리된 경우 스킵
      if (gameState.emailEnhancedFiles.containsKey(emailId)) continue;

      // Normal 파일 가져오기
      final normalFiles = await _enhancedRepository.getNormalFiles(emailId);

      if (normalFiles.isNotEmpty) {
        // Normal 파일 추가 + 이메일 "안읽음"으로 변경
        _gameStateNotifier.addEmailEnhancedFiles(emailId, normalFiles);
        _gameStateNotifier.markEmailAsUnread(emailId);
      }

      // Day 5 파일 수집 (나중에 E15로 전달)
      final day5Files = await _enhancedRepository.getDay5Files(emailId);
      if (day5Files.isNotEmpty) {
        _gameStateNotifier.addDay5EnhancedFiles(day5Files);
      }
    }
  }

  // /// Day 5 E15 이메일 생성 (TODO: 나중에 구현)
  // Future<void> _createE15Email() async {
  //   final gameState = _gameStateNotifier.state;
  //   final day5Files = gameState.day5EnhancedFilesToDeliver;
  //
  //   if (day5Files.isEmpty) {
  //     // 보강수사 요청 안 했으면 E15 생성 안 함
  //     return;
  //   }
  //
  //   // E15 이메일 템플릿 로드
  //   final e15Template = await _emailRepository.getEmailById('E15', 5);
  //
  //   if (e15Template == null) {
  //     return;
  //   }
  //
  //   // Day 5 파일들을 첨부파일로 추가
  //   // TODO: EmailRepository에 동적 이메일 저장 메커니즘 필요
  // }
}
