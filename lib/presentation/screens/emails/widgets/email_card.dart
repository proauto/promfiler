import 'package:flutter/material.dart';

import '../../../../config/theme.dart';
import '../../../../data/models/email.dart';

/// 이메일 카드 위젯
///
/// 표시 정보:
/// - 발신자 이름
/// - 이메일 제목
/// - 첨부파일 개수
/// - 읽지 않은 상태 강조 (불투명도로 구분)
class EmailCard extends StatelessWidget {
  final Email email;
  final bool isRead;
  final VoidCallback onTap;

  const EmailCard({
    super.key,
    required this.email,
    required this.isRead,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final opacity = isRead ? AppTheme.readOpacity : AppTheme.unreadOpacity;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor.withOpacity(opacity),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: AppTheme.gray80.withOpacity(0.1),
            width: 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 아이콘
            Container(
              width: 48.0,
              height: 48.0,
              decoration: BoxDecoration(
                color: AppTheme.gray80.withOpacity(opacity),
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Icon(
                Icons.person,
                color: AppTheme.gray22.withOpacity(opacity),
                size: 28.0,
              ),
            ),

            const SizedBox(width: 16.0),

            // 발신자 + 제목
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 발신자 이름
                  Text(
                    email.sender.name,
                    style: TextStyle(
                      color: AppTheme.textPrimary.withOpacity(opacity),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 6.0),

                  // 이메일 제목
                  Text(
                    email.subject,
                    style: TextStyle(
                      color: AppTheme.textSecondary.withOpacity(opacity),
                      fontSize: 14.0,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12.0),

            // 첨부파일 개수
            if (email.hasAttachments && email.attachmentCount != null)
              Row(
                children: [
                  Icon(
                    Icons.link,
                    color: AppTheme.textSecondary.withOpacity(opacity),
                    size: 18.0,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    '첨부파일 ${email.attachmentCount}개',
                    style: TextStyle(
                      color: AppTheme.textSecondary.withOpacity(opacity),
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
