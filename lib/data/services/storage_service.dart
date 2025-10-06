import 'package:hive_flutter/hive_flutter.dart';
import '../models/game_state.dart';

/// 로컬 저장소 서비스 (Hive)
///
/// GameState의 저장/로드를 담당
class StorageService {
  static const String _gameStateBoxName = 'gameState';
  static const String _gameStateKey = 'current';

  Box<GameState>? _gameStateBox;

  /// Hive 초기화
  Future<void> init() async {
    await Hive.initFlutter();

    // GameState TypeAdapter 등록
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(GameStateAdapter());
    }

    // Box 열기
    _gameStateBox = await Hive.openBox<GameState>(_gameStateBoxName);
  }

  /// GameState 저장
  Future<void> saveGameState(GameState state) async {
    if (_gameStateBox == null) {
      throw Exception('StorageService가 초기화되지 않았습니다');
    }

    await _gameStateBox!.put(_gameStateKey, state);
  }

  /// GameState 로드
  GameState? loadGameState() {
    // Box가 아직 열리지 않았으면 null 반환 (초기화 중)
    if (_gameStateBox == null) {
      return null;
    }

    return _gameStateBox!.get(_gameStateKey);
  }

  /// GameState 삭제 (게임 초기화)
  Future<void> deleteGameState() async {
    if (_gameStateBox == null) {
      throw Exception('StorageService가 초기화되지 않았습니다');
    }

    await _gameStateBox!.delete(_gameStateKey);
  }

  /// GameState 존재 여부 확인
  bool hasGameState() {
    // Box가 아직 열리지 않았으면 false 반환
    if (_gameStateBox == null) {
      return false;
    }

    return _gameStateBox!.containsKey(_gameStateKey);
  }

  /// Box 닫기
  Future<void> close() async {
    await _gameStateBox?.close();
  }
}
