import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme.dart';
import '../../../../core/constants/layout_constants.dart';
import '../../../../data/models/victim.dart';
import '../../../../data/models/evidence.dart';
import '../../../providers/evidence_provider.dart';

/// 피해자 상세 패널 (오버레이)
///
/// MainScreen 위에 표시되는 피해자 상세 패널
class VictimDetailPanel extends ConsumerWidget {
  final Victim victim;
  final VoidCallback onClose;

  const VictimDetailPanel({
    super.key,
    required this.victim,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final leftMargin = LayoutConstants.emailPanelLeftMargin(context);
    final panelWidth = screenWidth - leftMargin;

    return Container(
      width: panelWidth,
      decoration: BoxDecoration(
        color: AppTheme.gray22,
        border: Border(
          left: BorderSide(
            color: AppTheme.errorColor.withOpacity(0.3),
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
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildProfileCard()),
                        const SizedBox(width: 16.0),
                        Expanded(child: _buildDeathInfoCard()),
                      ],
                    ),
                    const SizedBox(height: 24.0),
                    _buildDiscoveredEvidenceSection(context, ref),
                    const SizedBox(height: 24.0),
                    _buildInvestigationNotesSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: LayoutConstants.topBarHeight(context),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: AppTheme.gray22,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.textSecondary.withOpacity(0.2),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.white),
            onPressed: onClose,
            tooltip: '닫기',
          ),
          const SizedBox(width: 8.0),
          const Text(
            '피해자 상세',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: AppTheme.errorColor.withOpacity(0.3),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
              color: AppTheme.gray80,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.errorColor.withOpacity(0.5),
                width: 3.0,
              ),
            ),
            child: ClipOval(
              child: victim.profileImagePath != null
                  ? Image.asset(
                      victim.profileImagePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.person,
                          size: 60.0,
                          color: AppTheme.gray22,
                        );
                      },
                    )
                  : const Icon(
                      Icons.person,
                      size: 60.0,
                      color: AppTheme.gray22,
                    ),
            ),
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Text(
                  victim.name,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  '직업 : ${victim.occupation} (${victim.age}세)',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeathInfoCard() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: AppTheme.gray80.withOpacity(0.2),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '사망 정보',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16.0),
          _buildInfoRow(Icons.calendar_today, '일시', victim.deathDate),
          const SizedBox(height: 12.0),
          _buildInfoRow(Icons.location_on, '장소', victim.deathLocation),
          const SizedBox(height: 12.0),
          _buildInfoRow(
            Icons.warning_amber,
            '원인',
            victim.causeOfDeath,
            valueColor: AppTheme.errorColor,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16.0,
          color: AppTheme.textSecondary,
        ),
        const SizedBox(width: 8.0),
        Text(
          '$label : ',
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppTheme.textSecondary,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDiscoveredEvidenceSection(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: AppTheme.gray80.withOpacity(0.2),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '발견한 증거',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16.0),
          if (victim.discoveredEvidenceIds.isEmpty)
            const Text(
              '아직 발견한 증거가 없습니다.',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14.0,
              ),
            )
          else
            _buildEvidenceList(ref),
        ],
      ),
    );
  }

  Widget _buildEvidenceList(WidgetRef ref) {
    final allEvidencesAsync = ref.watch(allEvidencesProvider);

    return allEvidencesAsync.when(
      data: (allEvidences) {
        final discoveredEvidences = allEvidences
            .where((e) => victim.discoveredEvidenceIds.contains(e.id))
            .toList();

        if (discoveredEvidences.isEmpty) {
          return const Text(
            '발견한 증거를 불러올 수 없습니다.',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14.0,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: discoveredEvidences.map((evidence) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  Container(
                    width: 60.0,
                    height: 32.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppTheme.gray22,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      evidence.id,
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      evidence.name,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
      loading: () => const CircularProgressIndicator(
        color: AppTheme.primaryColor,
      ),
      error: (error, stack) => Text(
        '증거를 불러올 수 없습니다: $error',
        style: const TextStyle(
          color: AppTheme.errorColor,
          fontSize: 14.0,
        ),
      ),
    );
  }

  Widget _buildInvestigationNotesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: AppTheme.gray80.withOpacity(0.2),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '수사 노트',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            width: double.infinity,
            height: 200.0,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppTheme.gray22,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              victim.investigationNotes ?? '노트를 작성하세요 (구현 예정)',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
