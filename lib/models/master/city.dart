part of 'master_models.dart';

class City {
  final String id;
  final String cityName;
  final String? countryId;
  final DateTime createdDate;
  final DateTime updatedDate;
  final int status;

  City({
    required this.id,
    required this.cityName,
    this.countryId,
    required this.createdDate,
    required this.updatedDate,
    required this.status,
  });

  factory City.fromMap(Map<String, dynamic> json) => City(
    id: json["_id"],
    cityName: json["city_name"],
    countryId: json["country_id"] ?? json["country"],
    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: DateTime.parse(json["updated_date"]),
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "city_name": cityName,
    "country_id": countryId,
    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
    "status": status,
  };
}
