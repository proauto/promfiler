import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/victim.dart';
import '../../data/repositories/victim_repository.dart';

/// 피해자 정보 Provider
final victimProvider = FutureProvider<Victim>((ref) async {
  final repository = ref.read(victimRepositoryProvider);
  return repository.getVictim();
});
