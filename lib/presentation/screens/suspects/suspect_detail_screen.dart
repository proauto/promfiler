import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/theme.dart';
import '../../../data/models/suspect.dart';
import '../../../data/models/evidence.dart';
import '../../providers/evidence_provider.dart';

/// 용의자 상세 화면
///
/// 용의자의 세부 정보, AI 분석 결과, 발견한 증거, 수사 노트를 표시
class SuspectDetailScreen extends ConsumerWidget {
  final Suspect suspect;

  const SuspectDetailScreen({
    super.key,
    required this.suspect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.gray22,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '용의자 상세',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 카드 (프로필 + AI 확률)
            Row(
              children: [
                // 프로필 카드
                Expanded(
                  child: _buildProfileCard(),
                ),
                const SizedBox(width: 16.0),

                // AI 확률 카드
                Expanded(
                  child: _buildAIProbabilityCard(),
                ),
              ],
            ),

            const SizedBox(height: 24.0),

            // 발견한 증거 섹션
            _buildDiscoveredEvidenceSection(context, ref),

            const SizedBox(height: 24.0),

            // 수사 노트 섹션
            _buildInvestigationNotesSection(),
          ],
        ),
      ),
    );
  }

  /// 프로필 카드
  Widget _buildProfileCard() {
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
      child: Row(
        children: [
          // 프로필 사진
          Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
              color: AppTheme.gray80,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: suspect.profileImagePath != null
                  ? Image.asset(
                      suspect.profileImagePath!,
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

          // 이름, 관계, 직업
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 이름
                Text(
                  suspect.name,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12.0),

                // 관계
                Text(
                  '관계 : ${suspect.relationship}',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8.0),

                // 직업
                Text(
                  '직업 : ${suspect.occupation} (${suspect.age}세)',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// AI 확률 카드
  Widget _buildAIProbabilityCard() {
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 아이콘
          Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              color: AppTheme.gray22,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: AppTheme.primaryColor,
              size: 32.0,
            ),
          ),
          const SizedBox(height: 16.0),

          // 텍스트
          const Text(
            'VIT AI 분석 결과 범인 확률',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12.0),

          // 확률
          Text(
            suspect.aiProbability != null
                ? '${suspect.aiProbability!.toStringAsFixed(0)}%'
                : '분석 중...',
            style: TextStyle(
              color: suspect.aiProbability != null
                  ? AppTheme.primaryColor
                  : AppTheme.textSecondary,
              fontSize: 48.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  /// 발견한 증거 섹션
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
          // 제목
          const Text(
            '발견한 증거',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16.0),

          // 증거 목록
          if (suspect.discoveredEvidenceIds.isEmpty)
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

  /// 증거 목록
  Widget _buildEvidenceList(WidgetRef ref) {
    final allEvidencesAsync = ref.watch(allEvidencesProvider);

    return allEvidencesAsync.when(
      data: (allEvidences) {
        // 발견한 증거만 필터링
        final discoveredEvidences = allEvidences
            .where((e) => suspect.discoveredEvidenceIds.contains(e.id))
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
                  // 증거 ID
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

                  // 증거 이름
                  Expanded(
                    child: Text(
                      evidence.name,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
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

  /// 수사 노트 섹션
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
          // 제목
          const Text(
            '수사 노트',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16.0),

          // 노트 내용 (추후 편집 기능 구현)
          Container(
            width: double.infinity,
            height: 200.0,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppTheme.gray22,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              suspect.investigationNotes ?? '노트를 작성하세요 (구현 예정)',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
