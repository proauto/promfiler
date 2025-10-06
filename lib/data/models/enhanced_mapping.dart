import 'package:json_annotation/json_annotation.dart';

part 'enhanced_mapping.g.dart';

/// 보강수사 파일 매핑 정보
///
/// enhanced_mappings.json에서 로드됨
@JsonSerializable()
class EnhancedMapping {
  /// 이메일 ID (예: "E02", "E05")
  final String emailId;

  /// 일반 보강수사 파일 (다음날 원래 이메일에 추가)
  /// 예: ["enhanced/e02_enhanced_01_garden_report.md", ...]
  @JsonKey(name: 'normal')
  final List<String> normalFiles;

  /// Day 5 특수 파일 (Day 5 E15에 추가)
  /// 예: ["enhanced/e05_5day_enhanced_04_gps_analysis.md"]
  @JsonKey(name: 'day5')
  final List<String> day5Files;

  EnhancedMapping({
    required this.emailId,
    required this.normalFiles,
    required this.day5Files,
  });

  factory EnhancedMapping.fromJson(Map<String, dynamic> json) =>
      _$EnhancedMappingFromJson(json);

  Map<String, dynamic> toJson() => _$EnhancedMappingToJson(this);

  @override
  String toString() {
    return 'EnhancedMapping('
        'emailId: $emailId, '
        'normal: ${normalFiles.length} files, '
        'day5: ${day5Files.length} files'
        ')';
  }
}
