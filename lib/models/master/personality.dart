part of 'master_models.dart';

class Personality {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final String relationshipId;
  final DateTime createdDate;
  final DateTime updatedDate;
  final int status;

  Personality({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.relationshipId,
    required this.createdDate,
    required this.updatedDate,
    required this.status,
  });

  factory Personality.fromMap(Map<String, dynamic> json) => Personality(
    id: json["_id"] ?? json["id"],
    title: json["title"],
    description: json["description"],
    emoji: json["emoji"],
    relationshipId: json["relationship_id"],
    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: DateTime.parse(json["updated_date"]),
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "description": description,
    "emoji": emoji,
    "relationship_id": relationshipId,
    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
    "status": status,
  };
}
