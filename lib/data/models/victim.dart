import 'package:json_annotation/json_annotation.dart';

part 'victim.g.dart';

/// 피해자 모델
///
/// 사건파일 화면에 표시되는 피해자 정보
@JsonSerializable()
class Victim {
  final String id;
  final String name;
  final int age;
  final String occupation;
  final String? profileImagePath;
  final String? description;

  /// 사망 일시
  final String deathDate;

  /// 사망 장소
  final String deathLocation;

  /// 사망 원인
  final String causeOfDeath;

  /// 관련 증거 ID 목록
  @JsonKey(defaultValue: [])
  final List<String> relatedEvidence;

  /// 발견한 증거 ID 목록 (상세 화면에 표시)
  @JsonKey(defaultValue: [])
  final List<String> discoveredEvidenceIds;

  /// 수사 노트 (플레이어가 작성, 추후 구현)
  final String? investigationNotes;

  Victim({
    required this.id,
    required this.name,
    required this.age,
    required this.occupation,
    this.profileImagePath,
    this.description,
    required this.deathDate,
    required this.deathLocation,
    required this.causeOfDeath,
    required this.relatedEvidence,
    required this.discoveredEvidenceIds,
    this.investigationNotes,
  });

  factory Victim.fromJson(Map<String, dynamic> json) => _$VictimFromJson(json);
  Map<String, dynamic> toJson() => _$VictimToJson(this);
}
