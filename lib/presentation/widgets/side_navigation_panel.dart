import 'package:flutter/material.dart';

import '../../core/constants/layout_constants.dart';
import '../screens/main/widgets/main_icon_button.dart';

/// 왼쪽 사이드 네비게이션 패널
///
/// MainScreen, EmailListScreen, EmailDetailScreen에서 공통으로 사용
class SideNavigationPanel extends StatelessWidget {
  final int unreadEmailCount;
  final VoidCallback? onFolderTap;
  final VoidCallback? onMailTap;
  final VoidCallback? onCameraTap;

  const SideNavigationPanel({
    super.key,
    this.unreadEmailCount = 0,
    this.onFolderTap,
    this.onMailTap,
    this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
            onTap: onFolderTap ?? () => Navigator.of(context).popUntil((route) => route.isFirst),
          ),

          SizedBox(height: LayoutConstants.iconSpacing(context)),

          // 메일 (뱃지 포함)
          MainIconButton(
            iconType: 'mail',
            label: '메일',
            badgeCount: unreadEmailCount,
            onTap: onMailTap ?? () => Navigator.of(context).popUntil((route) => route.isFirst),
          ),

          SizedBox(height: LayoutConstants.iconSpacing(context)),

          // 증거
          MainIconButton(
            iconType: 'camera',
            label: '증거',
            onTap: onCameraTap ?? () => Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ],
      ),
    );
  }
}
