import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/email.dart';
import '../models/enhanced_mapping.dart';

/// Asset 파일 로더
///
/// JSON, Markdown 등 assets 폴더의 파일을 로드
class AssetLoader {
  // 매핑 테이블 캐시
  Map<String, String>? _attachmentMappings;
  Map<String, EnhancedMapping>? _enhancedMappings;

  /// 특정 Day의 이메일 목록 로드
  Future<List<Email>> loadEmailsForDay(int day) async {
    final fileNames = _getEmailFileNamesForDay(day);
    final emails = <Email>[];

    for (final fileName in fileNames) {
      final path = 'assets/day$day/emails/$fileName';
      final email = await _loadEmailFromPath(path);
      emails.add(email);
    }

    return emails;
  }

  /// 단일 이메일 로드 (경로 지정)
  Future<Email> _loadEmailFromPath(String path) async {
    final jsonString = await rootBundle.loadString(path);
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return Email.fromJson(json);
  }

  /// Day별 이메일 파일명 목록
  List<String> _getEmailFileNamesForDay(int day) {
    switch (day) {
      case 1:
        return [
          'e01_case_assignment.json',
          'e02_crime_scene.json',
          'e03_suspects_initial_auto.json',
        ];
      case 2:
        return [
          'e04_autopsy.json',
          'e05_alibi_check.json',
          'e06_drug_tracking.json',
        ];
      case 3:
        return [
          'e07_embezzlement.json',
          'e08_inheritance.json',
          'e09_communication.json',
        ];
      case 4:
        return [
          'e10_kim_laptop.json',
          'e11_footprints.json',
          'e12_summary.json',
        ];
      case 5:
        return [
          'email_e13.json',
          'email_e14.json',
          // E15는 동적 생성 (보강수사가 있을 경우만)
        ];
      default:
        return [];
    }
  }

  /// 첨부파일 내용 로드 (Markdown)
  Future<String> loadAttachment(String assetId) async {
    // 매핑 테이블 로드 (최초 1회만)
    if (_attachmentMappings == null) {
      await _loadAttachmentMappings();
    }

    final path = _attachmentMappings![assetId];
    if (path == null) {
      throw Exception('첨부파일을 찾을 수 없습니다: $assetId');
    }

    return await rootBundle.loadString('assets/$path');
  }

  /// attachment_mappings.json 로드
  Future<void> _loadAttachmentMappings() async {
    final jsonString =
        await rootBundle.loadString('assets/data/attachment_mappings.json');
    final json = jsonDecode(jsonString) as Map<String, dynamic>;

    _attachmentMappings = json.map(
      (key, value) => MapEntry(key, value as String),
    );
  }

  /// Enhanced 매핑 테이블 로드
  Future<Map<String, EnhancedMapping>> loadEnhancedMappings() async {
    if (_enhancedMappings != null) {
      return _enhancedMappings!;
    }

    final jsonString =
        await rootBundle.loadString('assets/data/enhanced_mappings.json');
    final json = jsonDecode(jsonString) as Map<String, dynamic>;

    _enhancedMappings = {};
    json.forEach((emailId, data) {
      _enhancedMappings![emailId] = EnhancedMapping.fromJson({
        'emailId': emailId,
        'normal': data['normal'],
        'day5': data['day5'],
      });
    });

    return _enhancedMappings!;
  }

  /// Enhanced 파일 내용 로드
  Future<String> loadEnhancedFile(String path) async {
    return await rootBundle.loadString('assets/$path');
  }

  /// 일반 문자열 파일 로드
  Future<String> loadString(String path) async {
    return await rootBundle.loadString(path);
  }

  /// JSON 파일 로드
  Future<Map<String, dynamic>> loadJson(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// 캐시 초기화 (테스트용)
  void clearCache() {
    _attachmentMappings = null;
    _enhancedMappings = null;
  }
}
