import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/suspect.dart';

/// Suspect Repository Provider
final suspectRepositoryProvider = Provider<SuspectRepository>((ref) {
  return SuspectRepository();
});

/// 용의자 데이터 Repository
class SuspectRepository {
  /// 모든 용의자 가져오기
  Future<List<Suspect>> getAllSuspects() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/core/suspects.json');
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final suspectsJson = json['suspects'] as List;

      return suspectsJson
          .map((e) => Suspect.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('용의자 데이터를 불러올 수 없습니다: $e');
    }
  }

  /// ID로 용의자 찾기
  Future<Suspect?> getSuspectById(String id) async {
    final suspects = await getAllSuspects();
    try {
      return suspects.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }
}
