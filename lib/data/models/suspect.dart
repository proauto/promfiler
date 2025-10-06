import 'package:json_annotation/json_annotation.dart';

part 'suspect.g.dart';

/// 용의자 모델
///
/// 사건파일 화면에 표시되는 용의자 정보
@JsonSerializable()
class Suspect {
  final String id;
  final String name;
  final String relationship;
  final String occupation;
  final int age;
  final String? profileImagePath;
  final String? description;
  @JsonKey(defaultValue: [])
  final List<String> relatedEvidence;

  /// AI 분석 결과 범인 확률 (0.0 ~ 100.0)
  /// null인 경우 아직 분석 결과가 없음
  final double? aiProbability;

  /// 발견한 증거 ID 목록 (상세 화면에 표시)
  @JsonKey(defaultValue: [])
  final List<String> discoveredEvidenceIds;

  /// 수사 노트 (플레이어가 작성, 추후 구현)
  final String? investigationNotes;

  Suspect({
    required this.id,
    required this.name,
    required this.relationship,
    required this.occupation,
    required this.age,
    this.profileImagePath,
    this.description,
    required this.relatedEvidence,
    this.aiProbability,
    required this.discoveredEvidenceIds,
    this.investigationNotes,
  });

  factory Suspect.fromJson(Map<String, dynamic> json) => _$SuspectFromJson(json);
  Map<String, dynamic> toJson() => _$SuspectToJson(this);
}
