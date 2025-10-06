import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/evidence.dart';
import '../../data/repositories/evidence_repository.dart';
import 'game_state_provider.dart';

/// 현재 Day까지 해금된 증거 Provider
final evidencesProvider = FutureProvider<List<Evidence>>((ref) async {
  final repository = ref.read(evidenceRepositoryProvider);
  final currentDay = ref.watch(gameStateProvider.select((state) => state.currentDay));

  return repository.getEvidencesByDay(currentDay);
});

/// 모든 증거 Provider (관리자/테스트용)
final allEvidencesProvider = FutureProvider<List<Evidence>>((ref) async {
  final repository = ref.read(evidenceRepositoryProvider);
  return repository.getAllEvidences();
});

/// ID로 특정 증거 Provider
final evidenceByIdProvider = FutureProvider.family<Evidence?, String>((ref, id) async {
  final repository = ref.read(evidenceRepositoryProvider);
  return repository.getEvidenceById(id);
});
