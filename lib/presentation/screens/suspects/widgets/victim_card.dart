import 'package:flutter/material.dart';

import '../../../../config/theme.dart';
import '../../../../data/models/victim.dart';

/// 피해자 카드 위젯
///
/// 표시 정보:
/// - 프로필 사진
/// - 이름
/// - 직업
/// - 사망 일시
/// - 사망 원인
class VictimCard extends StatelessWidget {
  final Victim victim;
  final VoidCallback onTap;

  const VictimCard({
    super.key,
    required this.victim,
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
            color: AppTheme.errorColor.withOpacity(0.3), // 피해자는 붉은 테두리
            width: 2.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 프로필 사진 (원형)
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                color: AppTheme.gray80,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.errorColor.withOpacity(0.5),
                  width: 3.0,
                ),
              ),
              child: victim.profileImagePath != null
                  ? ClipOval(
                      child: Image.asset(
                        victim.profileImagePath!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 50.0,
                            color: AppTheme.gray22,
                          );
                        },
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      size: 50.0,
                      color: AppTheme.gray22,
                    ),
            ),

            const SizedBox(width: 24.0),

            // 피해자 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "피해자" 라벨
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: const Text(
                      '피해자',
                      style: TextStyle(
                        color: AppTheme.errorColor,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12.0),

                  // 이름
                  Text(
                    victim.name,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8.0),

                  // 직업
                  Text(
                    '${victim.occupation} (${victim.age}세)',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 16.0,
                    ),
                  ),

                  const SizedBox(height: 12.0),

                  // 사망 일시
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 14.0,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 6.0),
                      Expanded(
                        child: Text(
                          victim.deathDate,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6.0),

                  // 사망 원인
                  Row(
                    children: [
                      const Icon(
                        Icons.warning_amber,
                        size: 14.0,
                        color: AppTheme.errorColor,
                      ),
                      const SizedBox(width: 6.0),
                      Expanded(
                        child: Text(
                          victim.causeOfDeath,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
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
