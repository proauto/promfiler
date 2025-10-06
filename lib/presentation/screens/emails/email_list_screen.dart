import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/theme.dart';
import '../../../data/models/email.dart';
import '../../providers/game_state_provider.dart';
import '../../providers/email_provider.dart';
import 'email_detail_screen.dart';
import 'widgets/email_card.dart';

/// 이메일 목록 화면
///
/// 기능:
/// - 현재 Day의 이메일 목록 표시
/// - 읽지 않은 이메일 강조
/// - 이메일 클릭 → 상세 화면
class EmailListScreen extends ConsumerWidget {
  const EmailListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDay = ref.watch(
      gameStateProvider.select((state) => state.currentDay),
    );
    final readEmailIds = ref.watch(
      gameStateProvider.select((state) => state.readEmailIds),
    );
    final emailsAsync = ref.watch(emailsForDayProvider(currentDay));

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '메일',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: emailsAsync.when(
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
    );
  }

  /// 이메일 목록 위젯
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
          onTap: () => _openEmailDetail(context, email),
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

  /// 이메일 상세 화면 열기
  void _openEmailDetail(BuildContext context, Email email) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmailDetailScreen(email: email),
      ),
    );
  }
}
