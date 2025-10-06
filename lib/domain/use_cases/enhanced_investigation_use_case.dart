import '../../data/repositories/enhanced_investigation_repository.dart';
import '../../presentation/providers/game_state_provider.dart';
import '../../presentation/providers/token_provider.dart';

/// 보강수사 요청 Use Case
///
/// 역할:
/// - 보강수사 요청 처리
/// - 토큰 차감 및 검증
/// - 중복 요청 방지
class EnhancedInvestigationUseCase {
  final EnhancedInvestigationRepository _repository;

  static const int ENHANCED_COST = 50;

  EnhancedInvestigationUseCase(this._repository);

  /// 보강수사 요청 (Riverpod Ref 사용)
  Future<void> requestEnhancedInvestigation(
    String emailId,
    GameStateNotifier gameStateNotifier,
    TokenNotifier tokenNotifier,
  ) async {
    // 1. 토큰 체크
    if (!tokenNotifier.canAfford(ENHANCED_COST)) {
      throw InsufficientTokenException(
        required: ENHANCED_COST,
        current: tokenNotifier.currentBalance,
      );
    }

    // 2. 이미 요청했는지 체크
    final gameState = gameStateNotifier.currentState;
    if (gameState.requestedEnhancedInvestigations.contains(emailId)) {
      throw AlreadyRequestedException(emailId: emailId);
    }

    // 3. 토큰 차감
    tokenNotifier.spend(ENHANCED_COST);

    // 4. 요청 목록에 추가
    gameStateNotifier.addEnhancedInvestigation(emailId);
  }

  /// 보강수사 요청 여부 확인
  bool isRequested(String emailId, GameStateNotifier gameStateNotifier) {
    final gameState = gameStateNotifier.currentState;
    return gameState.requestedEnhancedInvestigations.contains(emailId);
  }

  /// Enhanced 파일이 추가되었는지 확인
  bool hasEnhancedFiles(String emailId, GameStateNotifier gameStateNotifier) {
    final gameState = gameStateNotifier.currentState;
    return gameState.emailEnhancedFiles.containsKey(emailId);
  }

  /// 특정 이메일의 Enhanced 파일 목록 가져오기
  List<String> getEnhancedFiles(
    String emailId,
    GameStateNotifier gameStateNotifier,
  ) {
    final gameState = gameStateNotifier.currentState;
    return gameState.emailEnhancedFiles[emailId] ?? [];
  }

  /// Normal 파일 목록 가져오기 (Repository 호출)
  Future<List<String>> getNormalFiles(String emailId) async {
    return await _repository.getNormalFiles(emailId);
  }

  /// Day 5 파일 목록 가져오기 (Repository 호출)
  Future<List<String>> getDay5Files(String emailId) async {
    return await _repository.getDay5Files(emailId);
  }

  /// Enhanced 파일 내용 로드
  Future<String> loadEnhancedFile(String path) async {
    return await _repository.loadEnhancedFile(path);
  }
}

/// 보강수사 이미 요청됨 예외
class AlreadyRequestedException implements Exception {
  final String emailId;

  AlreadyRequestedException({required this.emailId});

  @override
  String toString() {
    return '이미 보강수사를 요청한 이메일입니다: $emailId';
  }
}
