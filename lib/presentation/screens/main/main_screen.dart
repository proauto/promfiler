import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/layout_constants.dart';
import '../../../data/models/email.dart';
import '../../../data/models/suspect.dart';
import '../../../data/models/victim.dart';
import '../../../data/models/evidence.dart';
import '../../providers/game_state_provider.dart';
import '../../providers/email_provider.dart';
import '../../providers/providers.dart';
import '../emails/widgets/email_list_panel.dart';
import '../emails/widgets/email_detail_panel.dart';
import '../suspects/widgets/suspect_list_panel.dart';
import '../suspects/widgets/suspect_detail_panel.dart';
import '../suspects/widgets/victim_detail_panel.dart';
import '../evidences/widgets/evidence_list_panel.dart';
import 'widgets/main_top_bar.dart';
import 'widgets/main_icon_button.dart';
import 'widgets/ai_prompt_bar.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  AIStatus aiStatus = AIStatus.idle; // AI 상태 (테스트용)

  // 오버레이 패널 상태
  bool _showEmailList = false;
  Email? _selectedEmail;
  bool _showSuspectList = false;
  Victim? _selectedVictim;
  Suspect? _selectedSuspect;
  bool _showEvidenceList = false;

  @override
  Widget build(BuildContext context) {
    // GameState에서 데이터 가져오기
    final gameState = ref.watch(gameStateProvider);
    final currentDay = gameState.currentDay;
    final currentTime = _formatTime(gameState.currentTime);
    final canSubmit = gameState.canSubmitAnswer;

    // 읽지 않은 이메일 개수
    final unreadEmailCount = ref.watch(unreadEmailCountProvider);

    // 디버그: 이메일 개수 확인
    debugPrint('📧 읽지 않은 이메일 개수: $unreadEmailCount');
    debugPrint('📅 현재 Day: $currentDay');

    // 디버그: 화면 해상도 출력
    final screenSize = MediaQuery.of(context).size;
    final screenType = LayoutConstants.getScreenSize(context);
    debugPrint('📱 화면 크기: ${screenSize.width} x ${screenSize.height}');
    debugPrint('📐 화면 타입: $screenType');
    debugPrint('🎯 아이콘 크기: ${LayoutConstants.iconButtonSize(context)}dp');

    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/main_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 어두운 오버레이 (선택적, 텍스트 가독성 향상)
          Container(
            color: Colors.black.withOpacity(0.1),
          ),

          // UI 레이어
          SafeArea(
            child: Column(
              children: [
                // 상단바
                MainTopBar(
                  currentDay: currentDay,
                  currentTime: currentTime,
                  canSubmit: canSubmit,
                  onMenuTap: _onMenuTap,
                  onSubmitTap: _onSubmitTap,
                ),

                // 중간 빈 공간 (배경 이미지가 보이도록)
                const Expanded(child: SizedBox()),

                // 하단 AI 안내바
                AIPromptBar(
                  status: aiStatus,
                  onTap: _onAIPromptTap,
                ),
              ],
            ),
          ),

          // 왼쪽 아이콘들 (절대 위치 - 반응형)
          Positioned(
            left: LayoutConstants.iconLeftMargin(context),
            top: MediaQuery.of(context).padding.top +
                 LayoutConstants.iconTopMargin(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 사건파일
                MainIconButton(
                  iconType: 'folder',
                  label: '사건 파일',
                  onTap: _onFolderTap,
                  isActive: _showSuspectList || _selectedVictim != null || _selectedSuspect != null,
                ),

                SizedBox(height: LayoutConstants.iconSpacing(context)),

                // 메일 (뱃지 포함)
                MainIconButton(
                  iconType: 'mail',
                  label: '메일',
                  badgeCount: unreadEmailCount,
                  onTap: _onMailTap,
                  isActive: _showEmailList || _selectedEmail != null,
                ),

                SizedBox(height: LayoutConstants.iconSpacing(context)),

                // 증거
                MainIconButton(
                  iconType: 'camera',
                  label: '증거',
                  onTap: _onCameraTap,
                  isActive: _showEvidenceList,
                ),
              ],
            ),
          ),

          // 메일 목록 패널 (오버레이 - 슬라이드 애니메이션)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            right: (_showEmailList && _selectedEmail == null)
                ? 0
                : -(MediaQuery.of(context).size.width - LayoutConstants.emailPanelLeftMargin(context)),
            top: 0,
            bottom: 0,
            child: _showEmailList && _selectedEmail == null
                ? EmailListPanel(
                    onClose: () => setState(() => _showEmailList = false),
                    onEmailTap: (email) => setState(() => _selectedEmail = email),
                  )
                : const SizedBox.shrink(),
          ),

          // 메일 상세 패널 (오버레이 - 슬라이드 애니메이션)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            right: _selectedEmail != null
                ? 0
                : -(MediaQuery.of(context).size.width - LayoutConstants.emailPanelLeftMargin(context)),
            top: 0,
            bottom: 0,
            child: _selectedEmail != null
                ? EmailDetailPanel(
                    email: _selectedEmail!,
                    onClose: () => setState(() => _selectedEmail = null),
                  )
                : const SizedBox.shrink(),
          ),

          // 사건파일 목록 패널 (오버레이 - 슬라이드 애니메이션)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            right: (_showSuspectList && _selectedVictim == null && _selectedSuspect == null)
                ? 0
                : -(MediaQuery.of(context).size.width - LayoutConstants.emailPanelLeftMargin(context)),
            top: 0,
            bottom: 0,
            child: _showSuspectList && _selectedVictim == null && _selectedSuspect == null
                ? SuspectListPanel(
                    onClose: () => setState(() => _showSuspectList = false),
                    onVictimTap: (victim) => setState(() => _selectedVictim = victim),
                    onSuspectTap: (suspect) => setState(() => _selectedSuspect = suspect),
                  )
                : const SizedBox.shrink(),
          ),

          // 피해자 상세 패널 (오버레이 - 슬라이드 애니메이션)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            right: _selectedVictim != null
                ? 0
                : -(MediaQuery.of(context).size.width - LayoutConstants.emailPanelLeftMargin(context)),
            top: 0,
            bottom: 0,
            child: _selectedVictim != null
                ? VictimDetailPanel(
                    victim: _selectedVictim!,
                    onClose: () => setState(() => _selectedVictim = null),
                  )
                : const SizedBox.shrink(),
          ),

          // 용의자 상세 패널 (오버레이 - 슬라이드 애니메이션)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            right: _selectedSuspect != null
                ? 0
                : -(MediaQuery.of(context).size.width - LayoutConstants.emailPanelLeftMargin(context)),
            top: 0,
            bottom: 0,
            child: _selectedSuspect != null
                ? SuspectDetailPanel(
                    suspect: _selectedSuspect!,
                    onClose: () => setState(() => _selectedSuspect = null),
                  )
                : const SizedBox.shrink(),
          ),

          // 증거 패널 (오버레이 - 슬라이드 애니메이션)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            right: _showEvidenceList
                ? 0
                : -(MediaQuery.of(context).size.width - LayoutConstants.emailPanelLeftMargin(context)),
            top: 0,
            bottom: 0,
            child: _showEvidenceList
                ? EvidenceListPanel(
                    onClose: () => setState(() => _showEvidenceList = false),
                    onEvidenceTap: (evidence) {
                      // TODO: 증거 상세 화면 (옵션)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${evidence.name} 선택됨')),
                      );
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  void _onMenuTap() {
    final gameState = ref.read(gameStateProvider);

    // 개발용 메뉴
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('게임 정보'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('현재 Day: ${gameState.currentDay}'),
            Text('토큰: ${gameState.tokenBalance}'),
            Text('읽은 이메일: ${gameState.readEmailIds.length}'),
            const SizedBox(height: 8),
            const Text(
              '설정 메뉴는 추후 구현 예정입니다.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  /// Day 진행
  Future<void> _advanceDay() async {
    final dayTransitionService = ref.read(dayTransitionServiceProvider);

    try {
      // Day 전환 실행
      await dayTransitionService.advanceToNextDay();

      if (mounted) {
        final newDay = ref.read(gameStateProvider).currentDay;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ Day $newDay로 진행되었습니다')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ 오류: $e')),
        );
      }
    }
  }

  void _onSubmitTap() {
    final gameState = ref.read(gameStateProvider);

    if (gameState.canSubmitAnswer) {
      // Day 5: 최종 제출 화면으로 이동
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제출 화면으로 이동합니다 (구현 예정)')),
      );
    } else {
      // Day 1~4: 퇴근하기 (다음 날로 진행)
      _showLeaveWorkDialog();
    }
  }

  /// 퇴근 확인 다이얼로그
  void _showLeaveWorkDialog() {
    final currentDay = ref.read(gameStateProvider).currentDay;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('퇴근하기'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('현재 Day $currentDay'),
            const SizedBox(height: 8),
            const Text('오늘 업무를 마치고 퇴근하시겠습니까?'),
            const SizedBox(height: 4),
            const Text(
              '다음 날로 진행됩니다.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _advanceDay();
            },
            child: const Text('퇴근하기'),
          ),
        ],
      ),
    );
  }

  void _onFolderTap() {
    setState(() {
      _showSuspectList = true;
      _selectedVictim = null;
      _selectedSuspect = null;
      _showEmailList = false;
      _selectedEmail = null;
      _showEvidenceList = false;
    });
  }

  void _onMailTap() {
    setState(() {
      _showEmailList = true;
      _selectedEmail = null;
      _showSuspectList = false;
      _selectedVictim = null;
      _selectedSuspect = null;
      _showEvidenceList = false;
    });
  }

  void _onCameraTap() {
    setState(() {
      _showEvidenceList = true;
      _showEmailList = false;
      _selectedEmail = null;
      _showSuspectList = false;
      _selectedVictim = null;
      _selectedSuspect = null;
    });
  }

  void _onAIPromptTap() {
    // TODO: AI 분석 화면으로 이동
    // 데모: AI 상태 순환 (idle → thinking → complete → idle)
    setState(() {
      switch (aiStatus) {
        case AIStatus.idle:
          aiStatus = AIStatus.thinking;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('AI 분석 시작...')),
          );
          // 2초 후 자동으로 완료로 전환 (실제로는 API 응답 후)
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() => aiStatus = AIStatus.complete);
            }
          });
          break;
        case AIStatus.thinking:
          // 분석 중에는 클릭 무시
          break;
        case AIStatus.complete:
          // 완료 상태에서 클릭하면 결과 화면으로 이동
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('AI 분석 결과 화면으로 이동')),
          );
          // 결과 확인 후 다시 idle로
          setState(() => aiStatus = AIStatus.idle);
          break;
      }
    });
  }

  /// DateTime을 "HH:mm AM/PM" 형식으로 변환
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '$displayHour:$minute $period';
  }
}
