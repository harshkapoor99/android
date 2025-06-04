part of 'master_models.dart';

class Language {
  final String id;
  final String title;
  final String languageCode;
  final String nativeName;
  final DateTime createdDate;
  final DateTime updatedDate;
  final int status;

  Language({
    required this.id,
    required this.title,
    required this.languageCode,
    required this.nativeName,
    required this.createdDate,
    required this.updatedDate,
    required this.status,
  });

  factory Language.fromMap(Map<String, dynamic> json) => Language(
    id: json["id"] ?? json["_id"],
    title: json["title"],
    languageCode: json["language_code"],
    nativeName: json["native_name"],
    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: DateTime.parse(json["updated_date"]),
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "language_code": languageCode,
    "native_name": nativeName,
    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
    "status": status,
  };
}
