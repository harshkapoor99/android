part of 'master_models.dart';

class Country {
  final String id;
  final String countryName;
  final String flag;
  final DateTime createdDate;
  final DateTime updatedDate;
  final int status;

  Country({
    required this.id,
    required this.countryName,
    required this.flag,
    required this.createdDate,
    required this.updatedDate,
    required this.status,
  });

  factory Country.fromMap(Map<String, dynamic> json) => Country(
    id: json["_id"],
    countryName: json["country_name"],
    flag: json["flag"],
    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: DateTime.parse(json["updated_date"]),
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "country_name": countryName,
    "flag": flag,
    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
    "status": status,
  };
}
