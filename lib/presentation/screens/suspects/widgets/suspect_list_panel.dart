import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme.dart';
import '../../../../core/constants/layout_constants.dart';
import '../../../../data/models/suspect.dart';
import '../../../providers/suspect_provider.dart';
import 'suspect_card.dart';

/// 사건파일 목록 패널 (오버레이)
///
/// MainScreen 위에 표시되는 용의자 목록 패널
class SuspectListPanel extends ConsumerWidget {
  final VoidCallback onClose;
  final Function(Suspect) onSuspectTap;

  const SuspectListPanel({
    super.key,
    required this.onClose,
    required this.onSuspectTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

            // 용의자 목록
            Expanded(
              child: suspectsAsync.when(
                data: (suspects) => _buildSuspectList(context, suspects),
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

  /// 용의자 목록 (2열 그리드)
  Widget _buildSuspectList(
    BuildContext context,
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
        childAspectRatio: 1.8, // 카드 가로:세로 비율
      ),
      itemCount: suspects.length,
      itemBuilder: (context, index) {
        final suspect = suspects[index];

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
