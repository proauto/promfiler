import 'package:flutter/material.dart';

import '../../../../core/constants/layout_constants.dart';
import '../../../../core/utils/font_utils.dart';

class MainTopBar extends StatelessWidget {
  final int currentDay;
  final String currentTime;
  final VoidCallback onMenuTap;
  final VoidCallback onSubmitTap;
  final bool canSubmit; // Day 5만 true

  const MainTopBar({
    super.key,
    required this.currentDay,
    required this.currentTime,
    required this.onMenuTap,
    required this.onSubmitTap,
    this.canSubmit = false,
  });

  String get _dayLabel {
    final daysRemaining = 5 - currentDay;
    return 'D-$daysRemaining $currentTime';
  }

  @override
  Widget build(BuildContext context) {
    final barHeight = LayoutConstants.topBarHeight(context);
    final fontSize = LayoutConstants.topBarFontSize(context);
    final iconSize = LayoutConstants.topBarIconSize(context);
    final horizontalPadding = MediaQuery.of(context).size.width * 0.02;

    return Container(
      height: barHeight,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // 햄버거 메뉴
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white, size: iconSize),
            onPressed: onMenuTap,
            tooltip: '메뉴',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),

          const Spacer(),

          // Day 타이머
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: barHeight * 0.3,
              vertical: barHeight * 0.15,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(barHeight * 0.15),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              _dayLabel,
              style: FontUtils.notoSans(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const Spacer(),

          // 퇴근하기/제출하기 버튼
          TextButton(
            onPressed: onSubmitTap,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: canSubmit
                  ? const Color(0xFF00D9FF).withOpacity(0.2)
                  : const Color(0xFFFFB800).withOpacity(0.2),
              padding: EdgeInsets.symmetric(
                horizontal: barHeight * 0.3,
                vertical: barHeight * 0.15,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(barHeight * 0.15),
                side: BorderSide(
                  color: canSubmit
                      ? const Color(0xFF00D9FF)
                      : const Color(0xFFFFB800),
                  width: 1,
                ),
              ),
            ),
            child: Text(
              canSubmit ? '제출하기' : '퇴근하기',
              style: FontUtils.notoSans(
                fontSize: fontSize * 0.9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
