part of 'master_models.dart';

class Voice {
  final String id;
  final String fullName;
  final String vocalId;
  final String vocalType;
  final String languageId;
  final String languageCode;
  final String gender;
  final String? voicetextUrl;
  final DateTime createdDate;
  final DateTime updatedDate;
  final int status;

  Voice({
    required this.id,
    required this.fullName,
    required this.vocalId,
    required this.vocalType,
    required this.languageId,
    required this.languageCode,
    required this.gender,
    this.voicetextUrl,
    required this.createdDate,
    required this.updatedDate,
    required this.status,
  });

  factory Voice.fromMap(Map<String, dynamic> json) => Voice(
    id: json["_id"],
    fullName: json["full_name"],
    vocalId: json["vocal_id"],
    vocalType: json["vocal_type"],
    languageId: json["language_id"] ?? " ",
    languageCode: json["language_code"],
    gender: json["gender"],
    voicetextUrl: json["voicetext_url"],
    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: DateTime.parse(json["updated_date"]),
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "full_name": fullName,
    "vocal_id": vocalId,
    "vocal_type": vocalType,
    "language_id": languageId,
    "language_code": languageCode,
    "gender": gender,
    "voicetext_url": voicetextUrl,
    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
    "status": status,
  };
}
