// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evidence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Evidence _$EvidenceFromJson(Map<String, dynamic> json) => Evidence(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      imagePath: json['imagePath'] as String?,
      description: json['description'] as String?,
      day: (json['day'] as num).toInt(),
      relatedSuspects: (json['relatedSuspects'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$EvidenceToJson(Evidence instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'imagePath': instance.imagePath,
      'description': instance.description,
      'day': instance.day,
      'relatedSuspects': instance.relatedSuspects,
    };
