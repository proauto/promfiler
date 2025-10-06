import '../models/email.dart';
import '../services/asset_loader.dart';

/// 이메일 데이터 저장소
///
/// 이메일 로드, 첨부파일 로드 등을 담당
class EmailRepository {
  final AssetLoader _assetLoader;

  EmailRepository(this._assetLoader);

  /// 특정 Day의 모든 이메일 로드
  Future<List<Email>> getEmailsForDay(int day) async {
    return await _assetLoader.loadEmailsForDay(day);
  }

  /// 이메일 ID로 이메일 찾기
  Future<Email?> getEmailById(String emailId, int day) async {
    final emails = await getEmailsForDay(day);
    try {
      return emails.firstWhere((email) => email.id == emailId);
    } catch (e) {
      return null;
    }
  }

  /// 첨부파일 내용 로드
  Future<String> getAttachmentContent(String assetId) async {
    return await _assetLoader.loadAttachment(assetId);
  }

  /// 모든 이메일 로드 (Day 1-5)
  Future<List<Email>> getAllEmails() async {
    final allEmails = <Email>[];

    for (int day = 1; day <= 5; day++) {
      final emails = await getEmailsForDay(day);
      allEmails.addAll(emails);
    }

    return allEmails;
  }

  /// Day별 이메일 개수 가져오기
  Future<Map<int, int>> getEmailCountsByDay() async {
    final counts = <int, int>{};

    for (int day = 1; day <= 5; day++) {
      final emails = await getEmailsForDay(day);
      counts[day] = emails.length;
    }

    return counts;
  }
}
