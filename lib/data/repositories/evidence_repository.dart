import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/evidence.dart';

/// Evidence Repository Provider
final evidenceRepositoryProvider = Provider<EvidenceRepository>((ref) {
  return EvidenceRepository();
});

/// 증거 데이터 Repository
class EvidenceRepository {
  /// 모든 증거 가져오기
  Future<List<Evidence>> getAllEvidences() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/core/evidences.json');
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final evidencesJson = json['evidences'] as List;

      return evidencesJson
          .map((e) => Evidence.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('증거 데이터를 불러올 수 없습니다: $e');
    }
  }

  /// Day별 증거 가져오기
  Future<List<Evidence>> getEvidencesByDay(int day) async {
    final evidences = await getAllEvidences();
    return evidences.where((e) => e.day <= day).toList();
  }

  /// ID로 증거 찾기
  Future<Evidence?> getEvidenceById(String id) async {
    final evidences = await getAllEvidences();
    try {
      return evidences.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }
}
