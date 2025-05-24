part of 'master_models.dart';

class Relationship {
  final String id;
  final String title;
  final String? description;
  final String emoji;
  final String charactertypeId;
  final DateTime createdDate;
  final DateTime updatedDate;
  final int status;

  Relationship({
    required this.id,
    required this.title,
    this.description,
    required this.emoji,
    required this.charactertypeId,
    required this.createdDate,
    required this.updatedDate,
    required this.status,
  });

  factory Relationship.fromMap(Map<String, dynamic> json) => Relationship(
    id: json["_id"] ?? json["id"],
    title: json["title"],
    description: json["description"],
    emoji: json["emoji"],
    charactertypeId: json["charactertype_id"],
    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: DateTime.parse(json["updated_date"]),
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "description": description,
    "emoji": emoji,
    "charactertype_id": charactertypeId,
    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
    "status": status,
  };
}
