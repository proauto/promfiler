import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../../config/theme.dart';
import '../../../../core/constants/layout_constants.dart';
import '../../../../data/models/email.dart';
import '../../../providers/game_state_provider.dart';
import '../../../providers/providers.dart';
import 'email_header.dart';
import 'attachment_list.dart';
import 'enhanced_request_button.dart';

/// 메일 상세 패널 (오버레이)
///
/// MainScreen 위에 표시되는 메일 상세 패널
class EmailDetailPanel extends ConsumerStatefulWidget {
  final Email email;
  final VoidCallback onClose;

  const EmailDetailPanel({
    super.key,
    required this.email,
    required this.onClose,
  });

  @override
  ConsumerState<EmailDetailPanel> createState() => _EmailDetailPanelState();
}

class _EmailDetailPanelState extends ConsumerState<EmailDetailPanel> {
  @override
  void initState() {
    super.initState();

    // 화면 진입 시 읽음 처리 (자동)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _markAsRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.email;
    final gameState = ref.watch(gameStateProvider);
    final enhancedUseCase = ref.watch(requestEnhancedInvestigationUseCaseProvider);

    // 보강수사 요청 여부 확인
    final isEnhancedRequested =
        gameState.requestedEnhancedInvestigations.contains(email.id);

    // Enhanced 파일이 추가되었는지 확인
    final hasEnhancedFiles = gameState.emailEnhancedFiles.containsKey(email.id);

    final screenWidth = MediaQuery.of(context).size.width;
    final leftMargin = LayoutConstants.emailPanelLeftMargin(context);
    final panelWidth = screenWidth - leftMargin; // 왼쪽 아이콘 영역 제외

    return Container(
      width: panelWidth,
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        border: Border(
          left: BorderSide(
            color: AppTheme.primaryColor.withOpacity(0.3),
            width: 2.0,
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

            // 이메일 내용 (스크롤 가능)
            Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이메일 헤더
                  EmailHeader(email: email),

                  const SizedBox(height: 24.0),

                  // 본문 구분선
                  Container(
                    height: 1.0,
                    color: AppTheme.textSecondary.withOpacity(0.2),
                  ),

                  const SizedBox(height: 24.0),

                  // 긴급 알림 (있을 경우)
                  if (email.body.urgentNotice != null) ...[
                    _buildUrgentNotice(email.body.urgentNotice!),
                    const SizedBox(height: 24.0),
                  ],

                  // 인사말
                  if (email.body.greeting != null) ...[
                    Text(
                      email.body.greeting!,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14.0,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],

                  // 본문 섹션들
                  ...email.body.sections.map((section) => _buildSection(section)),

                  const SizedBox(height: 16.0),

                  // 마무리 인사
                  Text(
                    email.body.closing,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14.0,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 32.0),

                  // 첨부파일 목록
                  if (email.attachments.isNotEmpty) ...[
                    AttachmentList(
                      email: email,
                      enhancedFiles: hasEnhancedFiles
                          ? gameState.emailEnhancedFiles[email.id]!
                          : [],
                    ),
                    const SizedBox(height: 24.0),
                  ],
                ],
              ),
            ),
          ),

          // 하단 보강수사 요청 버튼
          EnhancedRequestButton(
            email: email,
            isRequested: isEnhancedRequested,
            hasEnhancedFiles: hasEnhancedFiles,
            onRequest: () => _requestEnhancedInvestigation(enhancedUseCase),
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
        color: AppTheme.surfaceColor,
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
            icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
            onPressed: widget.onClose,
            tooltip: '닫기',
          ),

          const SizedBox(width: 8.0),

          // 제목
          const Text(
            '메일 상세',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// 긴급 알림 위젯 (청록색 박스)
  Widget _buildUrgentNotice(String notice) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.tealColor.withOpacity(0.2),
        border: Border.all(
          color: AppTheme.tealColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            color: AppTheme.tealColor,
            size: 24.0,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              notice,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: 보강수사 상세 정보 표시
            },
            child: const Text(
              '자세히',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 본문 섹션 위젯
  Widget _buildSection(EmailSection section) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 제목
          Text(
            section.title,
            style: const TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12.0),

          // 섹션 내용 (Markdown 지원)
          ...section.content.map((text) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: MarkdownBody(
                  data: text,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14.0,
                      height: 1.6,
                    ),
                    strong: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                    em: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontStyle: FontStyle.italic,
                    ),
                    code: TextStyle(
                      backgroundColor: AppTheme.surfaceColor,
                      color: AppTheme.primaryColor,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  /// 읽음 처리
  void _markAsRead() {
    final gameStateNotifier = ref.read(gameStateProvider.notifier);
    gameStateNotifier.markEmailAsRead(widget.email.id);
  }

  /// 보강수사 요청
  Future<void> _requestEnhancedInvestigation(
    dynamic enhancedUseCase,
  ) async {
    try {
      final result = await enhancedUseCase.execute(widget.email.id);

      if (!mounted) return;

      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: AppTheme.successColor,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('오류가 발생했습니다: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }
}
