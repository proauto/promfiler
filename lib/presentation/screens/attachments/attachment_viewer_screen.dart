import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../config/theme.dart';
import '../../providers/providers.dart';

/// 첨부파일 뷰어 화면
///
/// 기능:
/// - Markdown 파일 렌더링
/// - PDF 뷰어 (향후 구현)
/// - 이미지 뷰어 (향후 구현)
class AttachmentViewerScreen extends ConsumerStatefulWidget {
  final String assetId;
  final String filename;
  final bool isEnhanced;

  const AttachmentViewerScreen({
    super.key,
    required this.assetId,
    required this.filename,
    this.isEnhanced = false,
  });

  @override
  ConsumerState<AttachmentViewerScreen> createState() =>
      _AttachmentViewerScreenState();
}

class _AttachmentViewerScreenState
    extends ConsumerState<AttachmentViewerScreen> {
  String? _content;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.filename,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          // Enhanced 뱃지
          if (widget.isEnhanced)
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 6.0,
              ),
              decoration: BoxDecoration(
                color: AppTheme.successColor,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: const Text(
                '보강수사',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primaryColor,
        ),
      );
    }

    if (_error != null) {
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
              Text(
                '파일을 불러올 수 없습니다',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                _error!,
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

    // Markdown 렌더링
    return Markdown(
      data: _content ?? '',
      styleSheet: MarkdownStyleSheet(
        // 제목
        h1: const TextStyle(
          color: AppTheme.primaryColor,
          fontSize: 28.0,
          fontWeight: FontWeight.w700,
          height: 1.4,
        ),
        h2: const TextStyle(
          color: AppTheme.primaryColor,
          fontSize: 24.0,
          fontWeight: FontWeight.w700,
          height: 1.4,
        ),
        h3: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          height: 1.4,
        ),
        h4: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
          height: 1.4,
        ),

        // 본문
        p: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 15.0,
          height: 1.7,
        ),

        // 강조
        strong: const TextStyle(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        em: const TextStyle(
          color: AppTheme.primaryColor,
          fontStyle: FontStyle.italic,
        ),

        // 리스트
        listBullet: const TextStyle(
          color: AppTheme.primaryColor,
          fontSize: 15.0,
        ),

        // 코드
        code: TextStyle(
          backgroundColor: AppTheme.surfaceColor,
          color: AppTheme.primaryColor,
          fontFamily: 'monospace',
          fontSize: 14.0,
        ),
        codeblockDecoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(8.0),
        ),

        // 인용
        blockquote: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 15.0,
          fontStyle: FontStyle.italic,
        ),
        blockquoteDecoration: BoxDecoration(
          color: AppTheme.surfaceColor.withOpacity(0.5),
          border: Border(
            left: BorderSide(
              color: AppTheme.primaryColor,
              width: 4.0,
            ),
          ),
        ),

        // 구분선
        horizontalRuleDecoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppTheme.textSecondary.withOpacity(0.3),
              width: 1.0,
            ),
          ),
        ),

        // 링크
        a: const TextStyle(
          color: AppTheme.primaryColor,
          decoration: TextDecoration.underline,
        ),

        // 테이블
        tableBorder: TableBorder.all(
          color: AppTheme.textSecondary.withOpacity(0.3),
          width: 1.0,
        ),
        tableHead: const TextStyle(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 14.0,
        ),
        tableBody: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 14.0,
        ),
      ),
      padding: const EdgeInsets.all(24.0),
    );
  }

  /// 콘텐츠 로드
  Future<void> _loadContent() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final assetLoader = ref.read(assetLoaderProvider);

      String content;
      if (widget.isEnhanced) {
        // Enhanced 파일 로드
        content = await assetLoader.loadEnhancedFile(widget.assetId);
      } else {
        // 일반 첨부파일 로드
        content = await assetLoader.loadAttachment(widget.assetId);
      }

      setState(() {
        _content = content;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
}
