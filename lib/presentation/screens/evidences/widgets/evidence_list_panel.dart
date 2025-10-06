import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme.dart';
import '../../../../core/constants/layout_constants.dart';
import '../../../../data/models/evidence.dart';
import '../../../providers/evidence_provider.dart';
import 'evidence_card.dart';

/// 증거 목록 패널 (오버레이)
///
/// MainScreen 위에 표시되는 증거 목록 패널
class EvidenceListPanel extends ConsumerWidget {
  final VoidCallback onClose;
  final Function(Evidence) onEvidenceTap;

  const EvidenceListPanel({
    super.key,
    required this.onClose,
    required this.onEvidenceTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final evidencesAsync = ref.watch(evidencesProvider);

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

            // 증거 목록
            Expanded(
              child: evidencesAsync.when(
                data: (evidences) => _buildEvidenceList(context, evidences),
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

  /// 상단 헤더 (제목 + 닫기 버튼)
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
            '증거',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  /// 증거 목록 (3열 그리드)
  Widget _buildEvidenceList(
    BuildContext context,
    List<Evidence> evidences,
  ) {
    if (evidences.isEmpty) {
      return _buildEmptyView();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(24.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        childAspectRatio: 0.9, // 카드 가로:세로 비율 (세로가 약간 더 긺)
      ),
      itemCount: evidences.length,
      itemBuilder: (context, index) {
        final evidence = evidences[index];

        return EvidenceCard(
          evidence: evidence,
          onTap: () => onEvidenceTap(evidence),
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
            Icons.photo_library_outlined,
            size: 80.0,
            color: AppTheme.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 24.0),
          const Text(
            '수집된 증거가 없습니다',
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
              '증거를 불러올 수 없습니다',
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
