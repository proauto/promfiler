import 'package:flutter/material.dart';

import '../../../../config/theme.dart';
import '../../../../data/models/suspect.dart';

/// 용의자 카드 위젯
///
/// 표시 정보:
/// - 프로필 사진
/// - 이름
/// - 관계
/// - 직업
class SuspectCard extends StatelessWidget {
  final Suspect suspect;
  final VoidCallback onTap;

  const SuspectCard({
    super.key,
    required this.suspect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: AppTheme.gray80.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 프로필 사진 (원형)
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: AppTheme.gray80,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.gray80.withOpacity(0.3),
                  width: 2.0,
                ),
              ),
              child: suspect.profileImagePath != null
                  ? ClipOval(
                      child: Image.asset(
                        suspect.profileImagePath!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 40.0,
                            color: AppTheme.gray22,
                          );
                        },
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      size: 40.0,
                      color: AppTheme.gray22,
                    ),
            ),

            const SizedBox(width: 20.0),

            // 이름 + 관계 + 직업
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이름
                  Text(
                    suspect.name,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8.0),

                  // 관계
                  Text(
                    '관계 : ${suspect.relationship}',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14.0,
                    ),
                  ),

                  const SizedBox(height: 4.0),

                  // 직업
                  Text(
                    '직업 : ${suspect.occupation} (${suspect.age}세)',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
