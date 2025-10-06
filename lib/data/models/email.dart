import 'package:json_annotation/json_annotation.dart';

part 'email.g.dart';

/// 이메일 메시지 모델
///
/// JSON 파일에서 로드되며, 게임 내에서 표시됨
@JsonSerializable(explicitToJson: true)
class Email {
  final String id;
  final int day;
  final EmailSender sender;
  final String receiver;
  @JsonKey(fromJson: _dateTimeFromString, toJson: _dateTimeToString)
  final DateTime timestamp;
  final String subject;
  final int importance;
  final bool? isUrgent;
  final bool hasAttachments;
  final int? attachmentCount;
  final EmailBody body;
  @JsonKey(defaultValue: [])
  final List<EmailAttachment> attachments;

  // ⭐ 런타임 전용 필드 (JSON 직렬화 안 함)
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool hasNewEnhancedFiles;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<String> enhancedFilePaths;

  Email({
    required this.id,
    required this.day,
    required this.sender,
    required this.receiver,
    required this.timestamp,
    required this.subject,
    required this.importance,
    this.isUrgent,
    required this.hasAttachments,
    this.attachmentCount,
    required this.body,
    required this.attachments,
    this.hasNewEnhancedFiles = false,
    this.enhancedFilePaths = const [],
  });

  /// JSON에서 Email 객체 생성
  factory Email.fromJson(Map<String, dynamic> json) => _$EmailFromJson(json);

  /// Email 객체를 JSON으로 변환
  Map<String, dynamic> toJson() => _$EmailToJson(this);

  /// 보강수사 파일 추가
  Email withEnhancedFiles(List<String> files) {
    return Email(
      id: id,
      day: day,
      sender: sender,
      receiver: receiver,
      timestamp: timestamp,
      subject: subject,
      importance: importance,
      isUrgent: isUrgent,
      hasAttachments: true,
      attachmentCount: (attachmentCount ?? attachments.length) + files.length,
      body: body,
      attachments: attachments,
      hasNewEnhancedFiles: true,
      enhancedFilePaths: files,
    );
  }

  /// 복사본 생성
  Email copyWith({
    String? id,
    int? day,
    EmailSender? sender,
    String? receiver,
    DateTime? timestamp,
    String? subject,
    int? importance,
    bool? isUrgent,
    bool? hasAttachments,
    int? attachmentCount,
    EmailBody? body,
    List<EmailAttachment>? attachments,
    bool? hasNewEnhancedFiles,
    List<String>? enhancedFilePaths,
  }) {
    return Email(
      id: id ?? this.id,
      day: day ?? this.day,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      timestamp: timestamp ?? this.timestamp,
      subject: subject ?? this.subject,
      importance: importance ?? this.importance,
      isUrgent: isUrgent ?? this.isUrgent,
      hasAttachments: hasAttachments ?? this.hasAttachments,
      attachmentCount: attachmentCount ?? this.attachmentCount,
      body: body ?? this.body,
      attachments: attachments ?? this.attachments,
      hasNewEnhancedFiles: hasNewEnhancedFiles ?? this.hasNewEnhancedFiles,
      enhancedFilePaths: enhancedFilePaths ?? this.enhancedFilePaths,
    );
  }

  // DateTime 변환 헬퍼
  static DateTime _dateTimeFromString(String dateString) {
    return DateTime.parse(dateString);
  }

  static String _dateTimeToString(DateTime dateTime) {
    return dateTime.toIso8601String();
  }
}

/// 이메일 발신자 정보
@JsonSerializable()
class EmailSender {
  final String name;
  final String department;
  final String? badge;   // Day 1-4 일부 이메일
  final String? title;   // Day 5 이메일

  EmailSender({
    required this.name,
    required this.department,
    this.badge,
    this.title,
  });

  factory EmailSender.fromJson(Map<String, dynamic> json) =>
      _$EmailSenderFromJson(json);

  Map<String, dynamic> toJson() => _$EmailSenderToJson(this);
}

/// 이메일 본문
@JsonSerializable(explicitToJson: true)
class EmailBody {
  final String? greeting;
  final String? urgentNotice;
  final List<EmailSection> sections;
  final String closing;

  EmailBody({
    this.greeting,
    this.urgentNotice,
    required this.sections,
    required this.closing,
  });

  factory EmailBody.fromJson(Map<String, dynamic> json) =>
      _$EmailBodyFromJson(json);

  Map<String, dynamic> toJson() => _$EmailBodyToJson(this);
}

/// 이메일 본문 섹션
@JsonSerializable()
class EmailSection {
  final String title;
  final List<String> content;

  EmailSection({
    required this.title,
    required this.content,
  });

  factory EmailSection.fromJson(Map<String, dynamic> json) =>
      _$EmailSectionFromJson(json);

  Map<String, dynamic> toJson() => _$EmailSectionToJson(this);
}

/// 이메일 첨부파일
@JsonSerializable()
class EmailAttachment {
  // Day 1-4 필드
  @JsonKey(name: 'assetId')
  final String? assetIdOld;

  // Day 5 필드 (e15_enhancedmail.json)
  @JsonKey(name: 'id')
  final String? idNew;

  final String filename;
  final String type;
  final String? size;

  EmailAttachment({
    this.assetIdOld,
    this.idNew,
    required this.filename,
    required this.type,
    this.size,
  });

  /// assetId 통일 getter (Day 1-4는 assetIdOld, Day 5는 idNew 사용)
  String get assetId => assetIdOld ?? idNew ?? '';

  factory EmailAttachment.fromJson(Map<String, dynamic> json) =>
      _$EmailAttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$EmailAttachmentToJson(this);
}
