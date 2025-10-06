import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'game_state_provider.dart';

/// 토큰 Provider
final tokenProvider = StateNotifierProvider<TokenNotifier, int>((ref) {
  return TokenNotifier(ref);
});

/// 토큰 Notifier
class TokenNotifier extends StateNotifier<int> {
  final Ref _ref;

  TokenNotifier(this._ref) : super(_loadInitialBalance(_ref));

  /// 초기 토큰 잔액 로드
  static int _loadInitialBalance(Ref ref) {
    final gameState = ref.read(gameStateProvider);
    return gameState.tokenBalance;
  }

  /// 현재 토큰 잔액 (외부에서 사용)
  int get currentBalance => state;

  /// 토큰 사용 가능 여부 확인
  bool canAfford(int cost) {
    return state >= cost;
  }

  /// 토큰 소비
  void spend(int amount) {
    if (!canAfford(amount)) {
      throw InsufficientTokenException(required: amount, current: state);
    }

    state -= amount;
    _updateGameState();
  }

  /// 토큰 획득
  void earn(int amount) {
    state += amount;
    _updateGameState();
  }

  /// 토큰 직접 설정 (테스트용)
  void setBalance(int balance) {
    state = balance;
    _updateGameState();
  }

  /// GameState에 토큰 잔액 업데이트
  void _updateGameState() {
    _ref.read(gameStateProvider.notifier).updateTokenBalance(state);
  }
}

/// 토큰 부족 예외
class InsufficientTokenException implements Exception {
  final int required;
  final int current;

  InsufficientTokenException({required this.required, required this.current});

  @override
  String toString() {
    return '토큰이 부족합니다. 필요: $required, 현재: $current';
  }
}
