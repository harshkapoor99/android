part of 'master_models.dart';

class Voice {
  final String id;
  final String fullName;
  final String voice;
  final String gender;
  final String voicetextUrl;
  final DateTime createdDate;
  final DateTime updatedDate;
  final int status;

  Voice({
    required this.id,
    required this.fullName,
    required this.voice,
    required this.gender,
    required this.voicetextUrl,
    required this.createdDate,
    required this.updatedDate,
    required this.status,
  });

  factory Voice.fromMap(Map<String, dynamic> json) => Voice(
    id: json["_id"],
    fullName: json["full_name"],
    voice: json["voice"],
    gender: json["gender"],
    voicetextUrl: json["voicetext_url"],
    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: DateTime.parse(json["updated_date"]),
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "full_name": fullName,
    "voice": voice,
    "gender": gender,
    "voicetext_url": voicetextUrl,
    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
    "status": status,
  };
}
