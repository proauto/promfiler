import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/email.dart';
import 'game_state_provider.dart';
import 'providers.dart';

/// Day별 이메일 목록 Provider (FutureProvider.family)
final emailsForDayProvider =
    FutureProvider.family<List<Email>, int>((ref, day) async {
  final repository = ref.watch(emailRepositoryProvider);
  final emails = await repository.getEmailsForDay(day);

  // Day 5일 때 E15 이메일에 day5EnhancedFilesToDeliver 파일들 추가
  if (day == 5) {
    final gameState = ref.read(gameStateProvider);
    final day5Files = gameState.day5EnhancedFilesToDeliver;

    if (day5Files.isNotEmpty) {
      // E15 이메일 찾기
      final e15Index = emails.indexWhere((email) => email.id == 'E15');

      if (e15Index != -1) {
        // E15 이메일에 day5 파일들 추가
        final e15 = emails[e15Index];
        final e15WithFiles = e15.withEnhancedFiles(day5Files);

        // 새 이메일 목록 생성 (E15만 교체)
        final updatedEmails = List<Email>.from(emails);
        updatedEmails[e15Index] = e15WithFiles;

        return updatedEmails;
      }
    }
  }

  return emails;
});

/// 현재 Day의 이메일 목록 Provider
final currentDayEmailsProvider = Provider<AsyncValue<List<Email>>>((ref) {
  final currentDay = ref.watch(
    gameStateProvider.select((state) => state.currentDay),
  );
  return ref.watch(emailsForDayProvider(currentDay));
});

/// 읽지 않은 이메일 개수 Provider
final unreadEmailCountProvider = Provider<int>((ref) {
  final currentDay = ref.watch(
    gameStateProvider.select((state) => state.currentDay),
  );
  final readEmailIds = ref.watch(
    gameStateProvider.select((state) => state.readEmailIds),
  );

  final emailsAsync = ref.watch(emailsForDayProvider(currentDay));

  return emailsAsync.when(
    data: (emails) {
      return emails.where((email) => !readEmailIds.contains(email.id)).length;
    },
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// 특정 이메일이 읽음 상태인지 확인
final isEmailReadProvider =
    Provider.family<bool, String>((ref, emailId) {
  final readEmailIds = ref.watch(
    gameStateProvider.select((state) => state.readEmailIds),
  );
  return readEmailIds.contains(emailId);
});

/// 특정 이메일의 Enhanced 파일 여부 확인
final hasEnhancedFilesProvider =
    Provider.family<bool, String>((ref, emailId) {
  final emailEnhancedFiles = ref.watch(
    gameStateProvider.select((state) => state.emailEnhancedFiles),
  );
  return emailEnhancedFiles.containsKey(emailId);
});

/// 특정 이메일의 Enhanced 파일 경로 목록
final emailEnhancedFilesProvider =
    Provider.family<List<String>, String>((ref, emailId) {
  final emailEnhancedFiles = ref.watch(
    gameStateProvider.select((state) => state.emailEnhancedFiles),
  );
  return emailEnhancedFiles[emailId] ?? [];
});
