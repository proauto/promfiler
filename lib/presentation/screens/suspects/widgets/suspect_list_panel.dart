import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme.dart';
import '../../../../core/constants/layout_constants.dart';
import '../../../../data/models/suspect.dart';
import '../../../../data/models/victim.dart';
import '../../../providers/suspect_provider.dart';
import '../../../providers/victim_provider.dart';
import 'suspect_card.dart';
import 'victim_card.dart';

/// 사건파일 목록 패널 (오버레이)
///
/// MainScreen 위에 표시되는 피해자 및 용의자 목록 패널
class SuspectListPanel extends ConsumerWidget {
  final VoidCallback onClose;
  final Function(Victim) onVictimTap;
  final Function(Suspect) onSuspectTap;

  const SuspectListPanel({
    super.key,
    required this.onClose,
    required this.onVictimTap,
    required this.onSuspectTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final victimAsync = ref.watch(victimProvider);
    final suspectsAsync = ref.watch(suspectsProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final leftMargin = LayoutConstants.emailPanelLeftMargin(context);
    final panelWidth = screenWidth - leftMargin; // 왼쪽 아이콘 영역 제외

    return Container(
      width: panelWidth,
      decoration: BoxDecoration(
        color: AppTheme.gray22,
        border: Border(
          left: BorderSide(
            color: AppTheme.gray80.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20.0,
            offset: const Offset(-5, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 상단 헤더
            _buildHeader(context),

            // 피해자 & 용의자 목록
            Expanded(
              child: victimAsync.when(
                data: (victim) {
                  return suspectsAsync.when(
                    data: (suspects) => _buildContent(context, victim, suspects),
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    error: (error, stack) => _buildErrorView(error),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                ),
                error: (error, stack) => _buildErrorView(error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 상단 헤더 (제목 + 닫기 버튼 + 브리핑 다시보기)
  Widget _buildHeader(BuildContext context) {
    return Container(
      height: LayoutConstants.topBarHeight(context),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: AppTheme.gray22,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.textSecondary.withOpacity(0.2),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          // 뒤로가기 버튼
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.white),
            onPressed: onClose,
            tooltip: '닫기',
          ),

          const SizedBox(width: 8.0),

          // 제목
          const Text(
            '사건 파일',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),

          const Spacer(),

          // 브리핑 다시보기 버튼
          TextButton(
            onPressed: () {
              // TODO: 브리핑 다시보기 기능
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('브리핑 다시보기 (구현 예정)')),
              );
            },
            child: const Text(
              '브리핑 다시보기',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 피해자 + 용의자 컨텐츠 (2x2 그리드)
  Widget _buildContent(
    BuildContext context,
    Victim victim,
    List<Suspect> suspects,
  ) {
    if (suspects.isEmpty) {
      return _buildEmptyView();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(24.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        childAspectRatio: 1.8,
      ),
      itemCount: 1 + suspects.length, // 피해자 1명 + 용의자 3명 = 4명
      itemBuilder: (context, index) {
        // 첫 번째 아이템은 피해자
        if (index == 0) {
          return VictimCard(
            victim: victim,
            onTap: () => onVictimTap(victim),
          );
        }

        // 나머지는 용의자
        final suspect = suspects[index - 1];
        return SuspectCard(
          suspect: suspect,
          onTap: () => onSuspectTap(suspect),
        );
      },
    );
  }

  /// 빈 상태 위젯
  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_outlined,
            size: 80.0,
            color: AppTheme.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 24.0),
          const Text(
            '용의자 정보가 없습니다',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// 에러 위젯
  Widget _buildErrorView(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppTheme.errorColor,
              size: 64.0,
            ),
            const SizedBox(height: 16.0),
            const Text(
              '사건파일을 불러올 수 없습니다',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              error.toString(),
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
