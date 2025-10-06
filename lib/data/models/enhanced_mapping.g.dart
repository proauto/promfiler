// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enhanced_mapping.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnhancedMapping _$EnhancedMappingFromJson(Map<String, dynamic> json) =>
    EnhancedMapping(
      emailId: json['emailId'] as String,
      normalFiles:
          (json['normal'] as List<dynamic>).map((e) => e as String).toList(),
      day5Files:
          (json['day5'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$EnhancedMappingToJson(EnhancedMapping instance) =>
    <String, dynamic>{
      'emailId': instance.emailId,
      'normal': instance.normalFiles,
      'day5': instance.day5Files,
    };
