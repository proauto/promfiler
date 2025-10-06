import 'package:flutter/material.dart';

import '../../../../core/constants/layout_constants.dart';
import '../../../../core/utils/font_utils.dart';

class MainIconButton extends StatefulWidget {
  final String iconType; // 'folder', 'mail', 'camera'
  final String label;
  final VoidCallback onTap;
  final int? badgeCount; // 메일 뱃지용
  final bool isActive; // 해당 화면이 열려있는지 여부

  const MainIconButton({
    super.key,
    required this.iconType,
    required this.label,
    required this.onTap,
    this.badgeCount,
    this.isActive = false,
  });

  @override
  State<MainIconButton> createState() => _MainIconButtonState();
}

class _MainIconButtonState extends State<MainIconButton> {
  bool _isPressed = false;

  String get _iconPath {
    final suffix = (widget.isActive || _isPressed) ? 'clicked' : 'unclicked';
    return 'assets/images/icons/${widget.iconType}_icon_$suffix.png';
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = LayoutConstants.iconButtonSize(context);
    final labelFontSize = LayoutConstants.iconLabelFontSize(context);
    final badgeSize = LayoutConstants.badgeSize(context);
    final badgeFontSize = LayoutConstants.badgeFontSize(context);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: SizedBox(
        width: iconSize,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 아이콘 이미지 + 뱃지
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(iconSize * 0.15),
                    boxShadow: (widget.isActive || _isPressed)
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: iconSize * 0.1,
                              offset: Offset(0, iconSize * 0.05),
                            ),
                          ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(iconSize * 0.15),
                    child: Image.asset(
                      _iconPath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // 메일 뱃지 (있을 경우)
                if (widget.badgeCount != null && widget.badgeCount! > 0)
                  Positioned(
                    right: -badgeSize * 0.1,
                    top: -badgeSize * 0.1,
                    child: Container(
                      width: badgeSize,
                      height: badgeSize,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF5252),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${widget.badgeCount}',
                          style: FontUtils.notoSans(
                            fontSize: badgeFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: iconSize * 0.1),

            // 라벨
            Text(
              widget.label,
              style: FontUtils.notoSans(
                fontSize: labelFontSize,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
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
