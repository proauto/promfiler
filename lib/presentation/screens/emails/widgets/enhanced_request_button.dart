import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme.dart';
import '../../../../data/models/email.dart';
import '../../../../domain/use_cases/request_enhanced_investigation_use_case.dart';
import '../../../providers/game_state_provider.dart';

/// 보강수사 요청 버튼 위젯
///
/// 상태:
/// - 요청 가능: "보강수사 요청 (30 토큰)"
/// - 요청 완료: "보강수사 요청됨 (다음 날 도착 예정)"
/// - 파일 도착: "보강수사 결과 도착"
class EnhancedRequestButton extends ConsumerWidget {
  final Email email;
  final bool isRequested;
  final bool hasEnhancedFiles;
  final VoidCallback onRequest;

  const EnhancedRequestButton({
    super.key,
    required this.email,
    required this.isRequested,
    required this.hasEnhancedFiles,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    final tokenBalance = gameState.tokenBalance;

    // 토큰 부족 여부
    final hasEnoughTokens =
        tokenBalance >= RequestEnhancedInvestigationUseCase.ENHANCED_INVESTIGATION_COST;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          top: BorderSide(
            color: AppTheme.textSecondary.withOpacity(0.2),
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: _buildButtonContent(context, hasEnoughTokens),
      ),
    );
  }

  Widget _buildButtonContent(BuildContext context, bool hasEnoughTokens) {
    // 이미 파일 도착
    if (hasEnhancedFiles) {
      return _buildStatusContainer(
        icon: Icons.check_circle,
        iconColor: AppTheme.successColor,
        text: '보강수사 결과 도착 완료',
        textColor: AppTheme.successColor,
        backgroundColor: AppTheme.successColor.withOpacity(0.1),
      );
    }

    // 요청 완료 (파일 대기 중)
    if (isRequested) {
      return _buildStatusContainer(
        icon: Icons.schedule,
        iconColor: AppTheme.warningColor,
        text: '보강수사 요청됨 (다음 날 도착 예정)',
        textColor: AppTheme.warningColor,
        backgroundColor: AppTheme.warningColor.withOpacity(0.1),
      );
    }

    // 요청 가능
    return ElevatedButton(
      onPressed: hasEnoughTokens ? onRequest : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: hasEnoughTokens
            ? AppTheme.primaryColor
            : AppTheme.textSecondary.withOpacity(0.3),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 16.0,
        ),
        minimumSize: const Size(double.infinity, 56.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.science,
            size: 24.0,
          ),
          const SizedBox(width: 12.0),
          Text(
            hasEnoughTokens
                ? '보강수사 요청 (30 토큰)'
                : '토큰 부족 (30 토큰 필요)',
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  /// 상태 표시 컨테이너
  Widget _buildStatusContainer({
    required IconData icon,
    required Color iconColor,
    required String text,
    required Color textColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 16.0,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: iconColor,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 24.0,
          ),
          const SizedBox(width: 12.0),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
