// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suspect.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Suspect _$SuspectFromJson(Map<String, dynamic> json) => Suspect(
      id: json['id'] as String,
      name: json['name'] as String,
      relationship: json['relationship'] as String,
      occupation: json['occupation'] as String,
      age: (json['age'] as num).toInt(),
      profileImagePath: json['profileImagePath'] as String?,
      description: json['description'] as String?,
      relatedEvidence: (json['relatedEvidence'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$SuspectToJson(Suspect instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'relationship': instance.relationship,
      'occupation': instance.occupation,
      'age': instance.age,
      'profileImagePath': instance.profileImagePath,
      'description': instance.description,
      'relatedEvidence': instance.relatedEvidence,
    };
