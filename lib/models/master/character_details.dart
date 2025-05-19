part of 'master_models.dart';

class CharacterDetails {
  final String id;
  final String name;
  final String bio;
  final String image;
  final String voiceId;
  final String countryId;
  final String cityId;
  final String personalityId;
  final String relationshipId;
  final String characterTypeId;
  final String? behaviourId;
  final DateTime createdDate;
  final DateTime updatedDate;
  final int status;

  final Voice? voice;
  final Country? country;
  final City? city;
  final Personality? personality;
  final Relationship? relationship;
  final CharacterType? characterType;
  final Behaviour? behaviour;

  CharacterDetails({
    required this.id,
    required this.name,
    required this.bio,
    required this.image,
    required this.voiceId,
    required this.countryId,
    required this.cityId,
    required this.personalityId,
    required this.relationshipId,
    required this.characterTypeId,
    this.behaviourId,
    required this.createdDate,
    required this.updatedDate,
    required this.status,
    this.voice,
    this.country,
    this.city,
    this.personality,
    this.relationship,
    this.characterType,
    this.behaviour,
  });

  factory CharacterDetails.fromMap(Map<String, dynamic> json) => CharacterDetails(
    id: json["_id"] ?? json["id"],
    name: json["name"],
    bio: json["bio"],
    image: json["image"],
    voiceId: json["voice_id"],
    countryId: json["country_id"],
    cityId: json["city_id"],
    personalityId: json["personality_id"],
    relationshipId: json["relationship_id"],
    characterTypeId: json["charactertype_id"],
    behaviourId: json["behaviour_id"],
    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: DateTime.parse(json["updated_date"]),
    status: json["status"],
    voice: json["voice"] != null ? Voice.fromMap(json["voice"]) : null,
    country: json["country"] != null ? Country.fromMap(json["country"]) : null,
    city: json["city"] != null ? City.fromMap(json["city"]) : null,
    personality: json["personality"] != null ? Personality.fromMap(json["personality"]) : null,
    relationship: json["relationship"] != null ? Relationship.fromMap(json["relationship"]) : null,
    characterType: json["character_type"] != null ? CharacterType.fromMap(json["character_type"]) : null,
    behaviour: json["behaviour"] != null ? Behaviour.fromMap(json["behaviour"]) : null,
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "bio": bio,
    "image": image,
    "voice_id": voiceId,
    "country_id": countryId,
    "city_id": cityId,
    "personality_id": personalityId,
    "relationship_id": relationshipId,
    "charactertype_id": characterTypeId,
    "behaviour_id": behaviourId,
    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
    "status": status,
    "voice": voice?.toMap(),
    "country": country?.toMap(),
    "city": city?.toMap(),
    "personality": personality?.toMap(),
    "relationship": relationship?.toMap(),
    "character_type": characterType?.toMap(),
    "behaviour": behaviour?.toMap(),
  };

  CharacterDetails copyWith({
    String? id,
    String? name,
    String? bio,
    String? image,
    String? voiceId,
    String? countryId,
    String? cityId,
    String? personalityId,
    String? relationshipId,
    String? characterTypeId,
    String? behaviourId,
    DateTime? createdDate,
    DateTime? updatedDate,
    int? status,
    Voice? voice,
    Country? country,
    City? city,
    Personality? personality,
    Relationship? relationship,
    CharacterType? characterType,
    Behaviour? behaviour,
  }) {
    return CharacterDetails(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      image: image ?? this.image,
      voiceId: voiceId ?? this.voiceId,
      countryId: countryId ?? this.countryId,
      cityId: cityId ?? this.cityId,
      personalityId: personalityId ?? this.personalityId,
      relationshipId: relationshipId ?? this.relationshipId,
      characterTypeId: characterTypeId ?? this.characterTypeId,
      behaviourId: behaviourId ?? this.behaviourId,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
      status: status ?? this.status,
      voice: voice ?? this.voice,
      country: country ?? this.country,
      city: city ?? this.city,
      personality: personality ?? this.personality,
      relationship: relationship ?? this.relationship,
      characterType: characterType ?? this.characterType,
      behaviour: behaviour ?? this.behaviour,
    );
  }
}