part of 'master_models.dart';

class CharacterDetail {
  final String id;
  final String name;
  final String? bio;
  final String age;
  final String gender;

  final Voice? voice;
  final Country country;
  final City city;
  final Personality personality;
  final Relationship relationship;
  final CharacterType? characterType;
  final List<Behaviour> behaviours;
  final List<GenImage> imageGallery;

  final DateTime createdDate;
  final DateTime updatedDate;
  final int status;

  CharacterDetail({
    required this.id,
    required this.name,
    this.bio,
    required this.age,
    required this.gender,

    this.voice,
    required this.country,
    required this.city,
    required this.personality,
    required this.relationship,
    this.characterType,
    required this.behaviours,
    required this.imageGallery,

    required this.createdDate,
    required this.updatedDate,
    required this.status,
  });

  factory CharacterDetail.fromMap(Map<String, dynamic> json) => CharacterDetail(
    id: json["_id"] ?? json["id"] ?? json["character_id"],
    name: json["name"],
    bio: json["bio"],
    age: json["age"],
    gender: json["gender"],

    voice: json["voice"] != null ? Voice.fromMap(json["voice"]) : null,
    country: Country.fromMap(json["country"]),
    city: City.fromMap(json["city"]),
    personality: Personality.fromMap(json["personality"]),
    relationship: Relationship.fromMap(json["relationship"]),
    characterType:
        json["character_type"] != null
            ? CharacterType.fromMap(json["character_type"])
            : null,
    behaviours: List<Behaviour>.from(
      json["behaviours"].map((b) => Behaviour.fromMap(b)),
    ),
    imageGallery: List<GenImage>.from(
      json["image_gallery"].map((x) => GenImage.fromMap(x)),
    ),

    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: DateTime.parse(json["updated_date"]),
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "bio": bio,
    "age": age,
    "gender": gender,

    "voice": voice?.toMap(),
    "country": country.toMap(),
    "city": city.toMap(),
    "personality": personality.toMap(),
    "relationship": relationship.toMap(),
    "character_type": characterType?.toMap(),
    "behaviour": List<GenImage>.from(behaviours.map((b) => b.toMap())),
    "image_gallery": List<dynamic>.from(imageGallery.map((x) => x.toMap())),

    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
    "status": status,
  };

  CharacterDetail copyWith({
    String? id,
    String? name,
    String? bio,
    String? age,
    String? gender,

    Voice? voice,
    Country? country,
    City? city,
    Personality? personality,
    Relationship? relationship,
    CharacterType? characterType,
    List<Behaviour>? behaviour,
    List<GenImage>? imageGallery,

    DateTime? createdDate,
    DateTime? updatedDate,
    int? status,
  }) {
    return CharacterDetail(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      age: age ?? this.age,
      gender: gender ?? this.gender,

      voice: voice ?? this.voice,
      country: country ?? this.country,
      city: city ?? this.city,
      personality: personality ?? this.personality,
      relationship: relationship ?? this.relationship,
      characterType: characterType ?? this.characterType,
      behaviours: behaviour ?? this.behaviours,
      imageGallery: imageGallery ?? this.imageGallery,

      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
      status: status ?? this.status,
    );
  }
}
