import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme.dart';
import '../../../../data/models/email.dart';
import '../../attachments/attachment_viewer_screen.dart';

/// 첨부파일 목록 위젯
///
/// 표시:
/// - 원본 첨부파일 (attachments)
/// - Enhanced 파일 (보강수사 결과)
class AttachmentList extends ConsumerWidget {
  final Email email;
  final List<String> enhancedFiles;

  const AttachmentList({
    super.key,
    required this.email,
    this.enhancedFiles = const [],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 첨부파일 제목
        Row(
          children: [
            const Icon(
              Icons.attach_file,
              color: AppTheme.primaryColor,
              size: 20.0,
            ),
            const SizedBox(width: 8.0),
            Text(
              '첨부파일 (${email.attachments.length + enhancedFiles.length})',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16.0),

        // 원본 첨부파일
        ...email.attachments.map((attachment) => _buildAttachmentItem(
              context,
              attachment.filename,
              attachment.type,
              attachment.size,
              attachment.assetId,
              isEnhanced: false,
            )),

        // Enhanced 파일
        if (enhancedFiles.isNotEmpty) ...[
          const SizedBox(height: 12.0),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withOpacity(0.1),
              border: Border.all(
                color: AppTheme.successColor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.new_releases,
                  color: AppTheme.successColor,
                  size: 20.0,
                ),
                const SizedBox(width: 8.0),
                const Text(
                  '보강수사 결과 파일',
                  style: TextStyle(
                    color: AppTheme.successColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0),
          ...enhancedFiles.map((filePath) => _buildEnhancedFileItem(
                context,
                filePath,
              )),
        ],
      ],
    );
  }

  /// 첨부파일 아이템
  Widget _buildAttachmentItem(
    BuildContext context,
    String filename,
    String type,
    String? size,
    String assetId, {
    required bool isEnhanced,
  }) {
    return InkWell(
      onTap: () => _openAttachment(context, assetId, filename),
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: AppTheme.textSecondary.withOpacity(0.3),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            // 파일 타입 아이콘
            Icon(
              _getFileIcon(type),
              color: AppTheme.primaryColor,
              size: 28.0,
            ),

            const SizedBox(width: 12.0),

            // 파일 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    filename,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text(
                        type,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12.0,
                        ),
                      ),
                      if (size != null) ...[
                        const SizedBox(width: 8.0),
                        Text(
                          size,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // 열기 아이콘
            const Icon(
              Icons.chevron_right,
              color: AppTheme.textSecondary,
              size: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  /// Enhanced 파일 아이템
  Widget _buildEnhancedFileItem(BuildContext context, String filePath) {
    // 파일 경로에서 파일명 추출
    final filename = filePath.split('/').last;

    return InkWell(
      onTap: () => _openEnhancedFile(context, filePath, filename),
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: AppTheme.successColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: AppTheme.successColor,
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            // 새 파일 아이콘
            const Icon(
              Icons.fiber_new,
              color: AppTheme.successColor,
              size: 28.0,
            ),

            const SizedBox(width: 12.0),

            // 파일 정보
            Expanded(
              child: Text(
                filename,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // 열기 아이콘
            const Icon(
              Icons.chevron_right,
              color: AppTheme.successColor,
              size: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  /// 파일 타입 아이콘 반환
  IconData _getFileIcon(String type) {
    final lowerType = type.toLowerCase();

    if (lowerType.contains('pdf')) {
      return Icons.picture_as_pdf;
    } else if (lowerType.contains('image') || lowerType.contains('png') || lowerType.contains('jpg')) {
      return Icons.image;
    } else if (lowerType.contains('text') || lowerType.contains('md') || lowerType.contains('markdown')) {
      return Icons.description;
    } else if (lowerType.contains('video')) {
      return Icons.videocam;
    } else {
      return Icons.insert_drive_file;
    }
  }

  /// 첨부파일 열기
  void _openAttachment(BuildContext context, String assetId, String filename) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttachmentViewerScreen(
          assetId: assetId,
          filename: filename,
          isEnhanced: false,
        ),
      ),
    );
  }

  /// Enhanced 파일 열기
  void _openEnhancedFile(BuildContext context, String filePath, String filename) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttachmentViewerScreen(
          assetId: filePath,
          filename: filename,
          isEnhanced: true,
        ),
      ),
    );
  }
}
