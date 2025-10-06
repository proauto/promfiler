import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/layout_constants.dart';
import '../../../../core/utils/font_utils.dart';

enum AIStatus {
  idle,      // 대기 중
  thinking,  // AI 분석 중
  complete,  // 답변 완료
}

class AIPromptBar extends StatelessWidget {
  final VoidCallback onTap;
  final AIStatus status;

  const AIPromptBar({
    super.key,
    required this.onTap,
    this.status = AIStatus.idle,
  });

  String get _promptText {
    switch (status) {
      case AIStatus.idle:
        return 'VIT AI 분석도구 사건을 해결해보세요.';
      case AIStatus.thinking:
        return 'AI가 증거를 분석하고 있습니다...';
      case AIStatus.complete:
        return 'AI 분석 완료! 결과를 확인하세요.';
    }
  }

  Widget _iconWidget(BuildContext context) {
    final iconSize = LayoutConstants.aiIconSize(context);

    switch (status) {
      case AIStatus.idle:
        // 기본 AI 아이콘
        return Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            color: const Color(0xFF00D9FF).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              'assets/images/icons/ai_icon_think.png',
              width: iconSize * 0.7,
              height: iconSize * 0.7,
              fit: BoxFit.contain,
            ),
          ),
        );

      case AIStatus.thinking:
        // AI 분석 중 아이콘 (회전 애니메이션)
        return Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            color: const Color(0xFF00D9FF).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              'assets/images/icons/ai_icon_think.png',
              width: iconSize * 0.7,
              height: iconSize * 0.7,
              fit: BoxFit.contain,
            ),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .rotate(duration: 2000.ms);

      case AIStatus.complete:
        // AI 분석 완료 아이콘 (등장 애니메이션)
        return Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            color: const Color(0xFF4ade80).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              'assets/images/icons/ai_icon_complete.png',
              width: iconSize * 0.7,
              height: iconSize * 0.7,
              fit: BoxFit.contain,
            ),
          ),
        ).animate().scale(duration: 300.ms).fadeIn();
    }
  }

  Color get _borderColor {
    switch (status) {
      case AIStatus.idle:
        return const Color(0xFF00D9FF);
      case AIStatus.thinking:
        return const Color(0xFF00D9FF);
      case AIStatus.complete:
        return const Color(0xFF4ade80); // 초록색
    }
  }

  Color get _glowColor {
    switch (status) {
      case AIStatus.idle:
        return const Color(0xFF00D9FF);
      case AIStatus.thinking:
        return const Color(0xFF00D9FF);
      case AIStatus.complete:
        return const Color(0xFF4ade80); // 초록색
    }
  }

  @override
  Widget build(BuildContext context) {
    final barHeight = LayoutConstants.aiPromptBarHeight(context);
    final fontSize = LayoutConstants.aiPromptFontSize(context);
    final bottomMargin = LayoutConstants.aiPromptBarBottomMargin(context);
    final borderRadius = LayoutConstants.aiPromptBarRadius(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: barHeight,
          width: screenWidth * 0.5, // 화면 가로의 50%
          margin: EdgeInsets.only(
            bottom: bottomMargin,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: barHeight * 0.4,
            vertical: barHeight * 0.2,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: _borderColor.withOpacity(0.5),
              width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _glowColor.withOpacity(0.2),
              blurRadius: barHeight * 0.4,
              spreadRadius: 2,
            ),
          ],
        ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 텍스트
              Flexible(
                child: Text(
                  _promptText,
                  style: FontUtils.notoSans(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              SizedBox(width: barHeight * 0.2),

              // AI 상태별 아이콘
              _iconWidget(context),
            ],
          ),
        ),
      ),
    );
  }
}
