// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Email _$EmailFromJson(Map<String, dynamic> json) => Email(
      id: json['id'] as String,
      day: (json['day'] as num).toInt(),
      sender: EmailSender.fromJson(json['sender'] as Map<String, dynamic>),
      receiver: json['receiver'] as String,
      timestamp: Email._dateTimeFromString(json['timestamp'] as String),
      subject: json['subject'] as String,
      importance: (json['importance'] as num).toInt(),
      isUrgent: json['isUrgent'] as bool?,
      hasAttachments: json['hasAttachments'] as bool,
      attachmentCount: (json['attachmentCount'] as num?)?.toInt(),
      body: EmailBody.fromJson(json['body'] as Map<String, dynamic>),
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => EmailAttachment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$EmailToJson(Email instance) => <String, dynamic>{
      'id': instance.id,
      'day': instance.day,
      'sender': instance.sender.toJson(),
      'receiver': instance.receiver,
      'timestamp': Email._dateTimeToString(instance.timestamp),
      'subject': instance.subject,
      'importance': instance.importance,
      'isUrgent': instance.isUrgent,
      'hasAttachments': instance.hasAttachments,
      'attachmentCount': instance.attachmentCount,
      'body': instance.body.toJson(),
      'attachments': instance.attachments.map((e) => e.toJson()).toList(),
    };

EmailSender _$EmailSenderFromJson(Map<String, dynamic> json) => EmailSender(
      name: json['name'] as String,
      department: json['department'] as String,
      badge: json['badge'] as String?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$EmailSenderToJson(EmailSender instance) =>
    <String, dynamic>{
      'name': instance.name,
      'department': instance.department,
      'badge': instance.badge,
      'title': instance.title,
    };

EmailBody _$EmailBodyFromJson(Map<String, dynamic> json) => EmailBody(
      greeting: json['greeting'] as String?,
      urgentNotice: json['urgentNotice'] as String?,
      sections: (json['sections'] as List<dynamic>)
          .map((e) => EmailSection.fromJson(e as Map<String, dynamic>))
          .toList(),
      closing: json['closing'] as String,
    );

Map<String, dynamic> _$EmailBodyToJson(EmailBody instance) => <String, dynamic>{
      'greeting': instance.greeting,
      'urgentNotice': instance.urgentNotice,
      'sections': instance.sections.map((e) => e.toJson()).toList(),
      'closing': instance.closing,
    };

EmailSection _$EmailSectionFromJson(Map<String, dynamic> json) => EmailSection(
      title: json['title'] as String,
      content:
          (json['content'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$EmailSectionToJson(EmailSection instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
    };

EmailAttachment _$EmailAttachmentFromJson(Map<String, dynamic> json) =>
    EmailAttachment(
      assetIdOld: json['assetId'] as String?,
      idNew: json['id'] as String?,
      filename: json['filename'] as String,
      type: json['type'] as String,
      size: json['size'] as String?,
    );

Map<String, dynamic> _$EmailAttachmentToJson(EmailAttachment instance) =>
    <String, dynamic>{
      'assetId': instance.assetIdOld,
      'id': instance.idNew,
      'filename': instance.filename,
      'type': instance.type,
      'size': instance.size,
    };
