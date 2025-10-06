import '../../data/repositories/enhanced_investigation_repository.dart';
import '../../presentation/providers/game_state_provider.dart';

/// 보강수사 요청 Use Case
///
/// 역할:
/// - 토큰 30 차감
/// - GameState에 요청 기록
/// - 다음 날 자동으로 파일 제공
class RequestEnhancedInvestigationUseCase {
  final GameStateNotifier _gameStateNotifier;
  final EnhancedInvestigationRepository _enhancedRepository;

  static const int ENHANCED_INVESTIGATION_COST = 30;

  RequestEnhancedInvestigationUseCase(
    this._gameStateNotifier,
    this._enhancedRepository,
  );

  /// 보강수사 요청
  ///
  /// 반환값: 성공/실패 메시지
  Future<RequestEnhancedInvestigationResult> execute(String emailId) async {
    // 1. 이미 요청했는지 확인
    final gameState = _gameStateNotifier.currentState;
    if (gameState.requestedEnhancedInvestigations.contains(emailId)) {
      return RequestEnhancedInvestigationResult.alreadyRequested();
    }

    // 2. 보강수사 가능한 이메일인지 확인
    final isAvailable = await _enhancedRepository.isEnhancedAvailable(emailId);
    if (!isAvailable) {
      return RequestEnhancedInvestigationResult.notAvailable();
    }

    // 3. 토큰 확인 및 차감
    if (!_gameStateNotifier.canAffordTokens(ENHANCED_INVESTIGATION_COST)) {
      return RequestEnhancedInvestigationResult.insufficientTokens();
    }

    final success = _gameStateNotifier.spendTokens(ENHANCED_INVESTIGATION_COST);
    if (!success) {
      return RequestEnhancedInvestigationResult.insufficientTokens();
    }

    // 4. 요청 기록
    _gameStateNotifier.addEnhancedInvestigation(emailId);

    return RequestEnhancedInvestigationResult.success();
  }

  /// 보강수사 가능 여부 확인
  Future<bool> canRequest(String emailId) async {
    final gameState = _gameStateNotifier.currentState;

    // 이미 요청했으면 불가
    if (gameState.requestedEnhancedInvestigations.contains(emailId)) {
      return false;
    }

    // 토큰 부족하면 불가
    if (!_gameStateNotifier.canAffordTokens(ENHANCED_INVESTIGATION_COST)) {
      return false;
    }

    // 보강수사 데이터 있는지 확인
    return await _enhancedRepository.isEnhancedAvailable(emailId);
  }
}

/// 보강수사 요청 결과
class RequestEnhancedInvestigationResult {
  final bool success;
  final String message;

  RequestEnhancedInvestigationResult._({
    required this.success,
    required this.message,
  });

  factory RequestEnhancedInvestigationResult.success() {
    return RequestEnhancedInvestigationResult._(
      success: true,
      message: '보강수사가 요청되었습니다. 다음 날 결과가 제공됩니다.',
    );
  }

  factory RequestEnhancedInvestigationResult.insufficientTokens() {
    return RequestEnhancedInvestigationResult._(
      success: false,
      message: '토큰이 부족합니다. (필요: 30 토큰)',
    );
  }

  factory RequestEnhancedInvestigationResult.alreadyRequested() {
    return RequestEnhancedInvestigationResult._(
      success: false,
      message: '이미 보강수사를 요청한 이메일입니다.',
    );
  }

  factory RequestEnhancedInvestigationResult.notAvailable() {
    return RequestEnhancedInvestigationResult._(
      success: false,
      message: '이 이메일은 보강수사를 요청할 수 없습니다.',
    );
  }
}
