import 'package:flutter/material.dart';

import '../../../../config/theme.dart';
import '../../../../data/models/email.dart';

/// 이메일 카드 위젯
///
/// 표시 정보:
/// - 발신자 이름
/// - 이메일 제목
/// - 첨부파일 개수
/// - 읽지 않은 상태 강조
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isRead
                ? AppTheme.textSecondary.withOpacity(0.2)
                : AppTheme.primaryColor.withOpacity(0.5),
            width: isRead ? 1.0 : 2.0,
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
                color: isRead
                    ? AppTheme.textSecondary.withOpacity(0.3)
                    : AppTheme.primaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Icon(
                Icons.person,
                color: isRead ? AppTheme.textSecondary : AppTheme.primaryColor,
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
                      color: isRead ? AppTheme.textSecondary : AppTheme.textPrimary,
                      fontSize: 16.0,
                      fontWeight: isRead ? FontWeight.w600 : FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 6.0),

                  // 이메일 제목
                  Text(
                    email.subject,
                    style: TextStyle(
                      color: isRead
                          ? AppTheme.textSecondary.withOpacity(0.8)
                          : AppTheme.textSecondary,
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
                    Icons.attach_file,
                    color: isRead ? AppTheme.textSecondary : AppTheme.primaryColor,
                    size: 18.0,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    '${email.attachmentCount}개',
                    style: TextStyle(
                      color: isRead ? AppTheme.textSecondary : AppTheme.primaryColor,
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
