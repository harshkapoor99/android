part of 'master_models.dart';

class Behaviour {
  final String id;
  final String title;
  final String description;
  final DateTime createdDate;
  final DateTime updatedDate;
  final int status;

  Behaviour({
    required this.id,
    required this.title,
    required this.description,
    required this.createdDate,
    required this.updatedDate,
    required this.status,
  });

  factory Behaviour.fromMap(Map<String, dynamic> json) => Behaviour(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: DateTime.parse(json["updated_date"]),
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "description": description,
    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
    "status": status,
  };
}
