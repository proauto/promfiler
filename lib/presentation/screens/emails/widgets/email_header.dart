import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme.dart';
import '../../../../data/models/email.dart';

/// 이메일 헤더 위젯
///
/// 표시 정보:
/// - 발신자 (이름, 부서, 배지/직급)
/// - 수신자
/// - 발신 시각
/// - 중요도
/// - 긴급 표시
class EmailHeader extends StatelessWidget {
  final Email email;

  const EmailHeader({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 긴급 표시
        if (email.isUrgent == true) ...[
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            decoration: BoxDecoration(
              color: AppTheme.errorColor,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: const Text(
              '긴급',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
        ],

        // 발신자 정보
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 발신자 아이콘
            Container(
              width: 48.0,
              height: 48.0,
              decoration: BoxDecoration(
                color: AppTheme.gray80,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: const Icon(
                Icons.person,
                color: AppTheme.gray22,
                size: 28.0,
              ),
            ),

            const SizedBox(width: 16.0),

            // 발신자 이름/부서
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이름
                  Text(
                    email.sender.name,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 4.0),

                  // 부서 및 배지/직급
                  Row(
                    children: [
                      Text(
                        email.sender.department,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14.0,
                        ),
                      ),
                      if (email.sender.badge != null) ...[
                        const SizedBox(width: 8.0),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6.0,
                            vertical: 2.0,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.gray22,
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(
                              color: AppTheme.gray80.withOpacity(0.5),
                              width: 1.0,
                            ),
                          ),
                          child: Text(
                            email.sender.badge!,
                            style: const TextStyle(
                              color: AppTheme.gray80,
                              fontSize: 11.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                      if (email.sender.title != null) ...[
                        const SizedBox(width: 8.0),
                        Text(
                          email.sender.title!,
                          style: const TextStyle(
                            color: AppTheme.gray80,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16.0),

        // 수신자 및 시각
        Row(
          children: [
            // 수신자
            const Icon(
              Icons.mail_outline,
              color: AppTheme.textSecondary,
              size: 16.0,
            ),
            const SizedBox(width: 8.0),
            Text(
              '수신: ${email.receiver}',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13.0,
              ),
            ),

            const Spacer(),

            // 발신 시각
            const Icon(
              Icons.access_time,
              color: AppTheme.textSecondary,
              size: 16.0,
            ),
            const SizedBox(width: 8.0),
            Text(
              _formatDateTime(email.timestamp),
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// DateTime 포맷팅
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }
}
