part of 'master_models.dart';

class CharacterType {
  final String id;
  final String charactertypeName;
  final String description;
  final String emoji;
  final DateTime createdDate;
  final DateTime updatedDate;
  final int status;

  CharacterType({
    required this.id,
    required this.charactertypeName,
    required this.description,
    required this.emoji,
    required this.createdDate,
    required this.updatedDate,
    required this.status,
  });

  factory CharacterType.fromMap(Map<String, dynamic> json) => CharacterType(
    id: json["_id"],
    charactertypeName: json["charactertype_name"],
    description: json["description"],
    emoji: json["emoji"],
    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: DateTime.parse(json["updated_date"]),
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "charactertype_name": charactertypeName,
    "description": description,
    "emoji": emoji,
    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
    "status": status,
  };
}
