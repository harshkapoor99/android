part of 'master_models.dart';

class City {
  final String id;
  final String cityName;
  final String? countryId;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final int? status;

  City({
    required this.id,
    required this.cityName,
    this.countryId,
    this.createdDate,
    this.updatedDate,
    this.status,
  });

  factory City.fromMap(Map<String, dynamic> json) => City(
    id: json["_id"] ?? json["id"],
    cityName: json["city_name"] ?? json["name"],
    countryId: json["country_id"] ?? json["country"],
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
    "city_name": cityName,
    "country_id": countryId,
    "created_date": createdDate?.toIso8601String(),
    "updated_date": updatedDate?.toIso8601String(),
    "status": status,
  };
}
