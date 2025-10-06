import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/suspect.dart';
import '../../data/repositories/suspect_repository.dart';

/// 모든 용의자 Provider
final suspectsProvider = FutureProvider<List<Suspect>>((ref) async {
  final repository = ref.read(suspectRepositoryProvider);
  return repository.getAllSuspects();
});

/// ID로 특정 용의자 Provider
final suspectByIdProvider = FutureProvider.family<Suspect?, String>((ref, id) async {
  final repository = ref.read(suspectRepositoryProvider);
  return repository.getSuspectById(id);
});
