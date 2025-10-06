import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme.dart';
import '../../../../core/constants/layout_constants.dart';
import '../../../../data/models/email.dart';
import '../../../providers/game_state_provider.dart';
import '../../../providers/email_provider.dart';
import 'email_card.dart';

/// 메일 목록 패널 (오버레이)
///
/// MainScreen 위에 표시되는 메일 목록 패널
class EmailListPanel extends ConsumerWidget {
  final VoidCallback onClose;
  final Function(Email) onEmailTap;

  const EmailListPanel({
    super.key,
    required this.onClose,
    required this.onEmailTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDay = ref.watch(
      gameStateProvider.select((state) => state.currentDay),
    );
    final readEmailIds = ref.watch(
      gameStateProvider.select((state) => state.readEmailIds),
    );
    final emailsAsync = ref.watch(emailsForDayProvider(currentDay));

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

            // 메일 목록
            Expanded(
              child: emailsAsync.when(
                data: (emails) => _buildEmailList(
                  context,
                  emails,
                  readEmailIds,
                ),
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
            '메일',
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

  /// 이메일 목록
  Widget _buildEmailList(
    BuildContext context,
    List<Email> emails,
    List<String> readEmailIds,
  ) {
    if (emails.isEmpty) {
      return _buildEmptyView();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24.0),
      itemCount: emails.length,
      itemBuilder: (context, index) {
        final email = emails[index];
        final isRead = readEmailIds.contains(email.id);

        return EmailCard(
          email: email,
          isRead: isRead,
          onTap: () => onEmailTap(email),
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
            Icons.mail_outline,
            size: 80.0,
            color: AppTheme.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 24.0),
          const Text(
            '도착한 메일이 없습니다',
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
              '이메일을 불러올 수 없습니다',
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
