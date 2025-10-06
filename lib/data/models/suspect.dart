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

  Suspect({
    required this.id,
    required this.name,
    required this.relationship,
    required this.occupation,
    required this.age,
    this.profileImagePath,
    this.description,
    required this.relatedEvidence,
  });

  factory Suspect.fromJson(Map<String, dynamic> json) => _$SuspectFromJson(json);
  Map<String, dynamic> toJson() => _$SuspectToJson(this);
}
