import 'package:json_annotation/json_annotation.dart';

part 'evidence.g.dart';

/// 증거 모델
///
/// 증거 화면에 표시되는 증거물 정보
@JsonSerializable()
class Evidence {
  final String id;
  final String name;
  final String type;
  final String? imagePath;
  final String? description;
  final int day;
  @JsonKey(defaultValue: [])
  final List<String> relatedSuspects;

  Evidence({
    required this.id,
    required this.name,
    required this.type,
    this.imagePath,
    this.description,
    required this.day,
    required this.relatedSuspects,
  });

  factory Evidence.fromJson(Map<String, dynamic> json) => _$EvidenceFromJson(json);
  Map<String, dynamic> toJson() => _$EvidenceToJson(this);
}
