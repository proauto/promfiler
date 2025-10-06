// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'victim.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Victim _$VictimFromJson(Map<String, dynamic> json) => Victim(
      id: json['id'] as String,
      name: json['name'] as String,
      age: (json['age'] as num).toInt(),
      occupation: json['occupation'] as String,
      profileImagePath: json['profileImagePath'] as String?,
      description: json['description'] as String?,
      deathDate: json['deathDate'] as String,
      deathLocation: json['deathLocation'] as String,
      causeOfDeath: json['causeOfDeath'] as String,
      relatedEvidence: (json['relatedEvidence'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      discoveredEvidenceIds: (json['discoveredEvidenceIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      investigationNotes: json['investigationNotes'] as String?,
    );

Map<String, dynamic> _$VictimToJson(Victim instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'age': instance.age,
      'occupation': instance.occupation,
      'profileImagePath': instance.profileImagePath,
      'description': instance.description,
      'deathDate': instance.deathDate,
      'deathLocation': instance.deathLocation,
      'causeOfDeath': instance.causeOfDeath,
      'relatedEvidence': instance.relatedEvidence,
      'discoveredEvidenceIds': instance.discoveredEvidenceIds,
      'investigationNotes': instance.investigationNotes,
    };
