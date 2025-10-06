import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/victim.dart';

/// 피해자 데이터 저장소
class VictimRepository {
  /// 피해자 정보 가져오기
  Future<Victim> getVictim() async {
    final jsonString = await rootBundle.loadString('assets/data/core/victim.json');
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    final victimJson = json['victim'] as Map<String, dynamic>;

    return Victim.fromJson(victimJson);
  }
}

/// VictimRepository Provider
final victimRepositoryProvider = Provider<VictimRepository>((ref) {
  return VictimRepository();
});
