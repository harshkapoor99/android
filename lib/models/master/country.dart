part of 'master_models.dart';

class Country {
  final String id;
  final String countryName;
  final String? flag;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final int? status;

  Country({
    required this.id,
    required this.countryName,
    this.flag,
    this.createdDate,
    this.updatedDate,
    this.status,
  });

  factory Country.fromMap(Map<String, dynamic> json) => Country(
    id: json["_id"] ?? json["id"],
    countryName: json["country_name"] ?? json["name"],
    flag: json["flag"],
    createdDate:
        json["created_date"] != null
            ? DateTime.parse(json["created_date"])
            : null,
    updatedDate:
        json["updated_date"] != null
            ? DateTime.parse(json["updated_date"])
            : null,
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "country_name": countryName,
    "flag": flag,
    "created_date": createdDate?.toIso8601String(),
    "updated_date": updatedDate?.toIso8601String(),
    "status": status,
  };
}
