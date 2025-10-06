import 'package:flutter/material.dart';

import '../../../../config/theme.dart';
import '../../../../data/models/evidence.dart';

/// 증거 카드 위젯
///
/// 표시 정보:
/// - 이미지 썸네일
/// - 파일명
class EvidenceCard extends StatelessWidget {
  final Evidence evidence;
  final VoidCallback onTap;

  const EvidenceCard({
    super.key,
    required this.evidence,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이미지 썸네일 (정사각형)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: AppTheme.gray80.withOpacity(0.2),
                  width: 1.0,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: evidence.imagePath != null
                    ? Image.asset(
                        evidence.imagePath!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholder();
                        },
                      )
                    : _buildPlaceholder(),
              ),
            ),
          ),

          const SizedBox(height: 8.0),

          // 파일명
          Text(
            evidence.name,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// 이미지 플레이스홀더
  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        _getIconByType(),
        size: 48.0,
        color: AppTheme.gray80,
      ),
    );
  }

  /// 증거 타입별 아이콘
  IconData _getIconByType() {
    switch (evidence.type) {
      case 'image':
        return Icons.image;
      case 'document':
        return Icons.description;
      case 'video':
        return Icons.videocam;
      case 'physical':
        return Icons.fingerprint;
      case 'digital':
        return Icons.computer;
      default:
        return Icons.file_present;
    }
  }
}
