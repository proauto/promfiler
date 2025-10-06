import '../models/enhanced_mapping.dart';
import '../services/asset_loader.dart';

/// 보강수사 데이터 저장소
///
/// 보강수사 파일 매핑 및 로드를 담당
class EnhancedInvestigationRepository {
  final AssetLoader _assetLoader;

  // 매핑 테이블 캐시
  Map<String, EnhancedMapping>? _cachedMappings;

  EnhancedInvestigationRepository(this._assetLoader);

  /// Enhanced 매핑 테이블 로드
  Future<Map<String, EnhancedMapping>> loadMappings() async {
    _cachedMappings ??= await _assetLoader.loadEnhancedMappings();
    return _cachedMappings!;
  }

  /// 특정 이메일의 normal 파일 목록 가져오기
  Future<List<String>> getNormalFiles(String emailId) async {
    final mappings = await loadMappings();
    return mappings[emailId]?.normalFiles ?? [];
  }

  /// 특정 이메일의 day5 파일 목록 가져오기
  Future<List<String>> getDay5Files(String emailId) async {
    final mappings = await loadMappings();
    return mappings[emailId]?.day5Files ?? [];
  }

  /// Enhanced 파일 내용 로드
  Future<String> loadEnhancedFile(String path) async {
    return await _assetLoader.loadEnhancedFile(path);
  }

  /// 보강수사 가능한 이메일 ID 목록
  Future<List<String>> getAvailableEmailIds() async {
    final mappings = await loadMappings();
    return mappings.keys.toList();
  }

  /// 특정 이메일이 보강수사 가능한지 확인
  Future<bool> isEnhancedAvailable(String emailId) async {
    final mappings = await loadMappings();
    return mappings.containsKey(emailId);
  }

  /// 캐시 초기화 (테스트용)
  void clearCache() {
    _cachedMappings = null;
  }
}
