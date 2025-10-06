import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/email_repository.dart';
import '../../data/repositories/enhanced_investigation_repository.dart';
import '../../data/services/asset_loader.dart';
import '../../data/services/day_transition_service.dart';
import '../../data/services/storage_service.dart';
import '../../domain/use_cases/enhanced_investigation_use_case.dart';
import '../../domain/use_cases/request_enhanced_investigation_use_case.dart';
import 'game_state_provider.dart';

/// AssetLoader Provider (싱글톤)
final assetLoaderProvider = Provider<AssetLoader>((ref) {
  return AssetLoader();
});

/// StorageService Provider (싱글톤)
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

/// EmailRepository Provider
final emailRepositoryProvider = Provider<EmailRepository>((ref) {
  final assetLoader = ref.watch(assetLoaderProvider);
  return EmailRepository(assetLoader);
});

/// EnhancedInvestigationRepository Provider
final enhancedInvestigationRepositoryProvider =
    Provider<EnhancedInvestigationRepository>((ref) {
  final assetLoader = ref.watch(assetLoaderProvider);
  return EnhancedInvestigationRepository(assetLoader);
});

/// EnhancedInvestigationUseCase Provider
final enhancedInvestigationUseCaseProvider =
    Provider<EnhancedInvestigationUseCase>((ref) {
  final repository = ref.watch(enhancedInvestigationRepositoryProvider);
  return EnhancedInvestigationUseCase(repository);
});

/// RequestEnhancedInvestigationUseCase Provider
final requestEnhancedInvestigationUseCaseProvider =
    Provider<RequestEnhancedInvestigationUseCase>((ref) {
  final gameStateNotifier = ref.watch(gameStateProvider.notifier);
  final repository = ref.watch(enhancedInvestigationRepositoryProvider);
  return RequestEnhancedInvestigationUseCase(gameStateNotifier, repository);
});

/// DayTransitionService Provider
final dayTransitionServiceProvider = Provider<DayTransitionService>((ref) {
  final gameStateNotifier = ref.watch(gameStateProvider.notifier);
  final emailRepository = ref.watch(emailRepositoryProvider);
  final enhancedRepository = ref.watch(enhancedInvestigationRepositoryProvider);

  return DayTransitionService(
    gameStateNotifier,
    emailRepository,
    enhancedRepository,
  );
});
