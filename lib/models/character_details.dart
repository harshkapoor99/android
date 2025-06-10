import 'package:guftagu_mobile/models/character.dart';
import 'package:guftagu_mobile/models/gen_image.dart';
import 'package:guftagu_mobile/models/master/master_models.dart';

class CharacterDetail {
  final String id;
  final String creatorId;
  final String creatorUserType;

  final String name;
  final String? bio;
  final String? age;
  final String? gender;
  final String? style;
  final String? characterDescription;
  final String? sexualOrientation;

  final Language? language;
  final Voice? voice;
  final Country? country;
  final City? city;
  final Personality? personality;
  final Relationship? relationship;
  final CharacterType? characterType;
  final List<Behaviour> behaviours;
  final List<GenImage> imageGallery;

  final String? refImage;
  final String? imageDescription;
  final String? backStory;
  final String prompt;

  final DateTime createdDate;
  final DateTime updatedDate;
  final int status;

  CharacterDetail({
    required this.id,
    required this.creatorId,
    required this.creatorUserType,

    required this.name,
    this.bio,
    required this.age,
    required this.gender,
    required this.style,
    required this.characterDescription,
    required this.sexualOrientation,

    required this.language,
    this.voice,
    required this.country,
    required this.city,
    required this.personality,
    required this.relationship,
    this.characterType,
    required this.behaviours,
    required this.imageGallery,

    required this.refImage,
    required this.imageDescription,
    required this.backStory,
    required this.prompt,

    required this.createdDate,
    required this.updatedDate,
    required this.status,
  });

  factory CharacterDetail.fromMap(Map<String, dynamic> json) => CharacterDetail(
    id: json["_id"] ?? json["id"] ?? json["character_id"],
    creatorId: json["creator_id"],
    creatorUserType: json["creator_user_type"],
    name: json["name"],
    bio: json["bio"],
    age: json["age"],
    gender: json["gender"],
    style: json["style"],
    characterDescription: json["character_description"],
    sexualOrientation: json["sexual_orientation"],

    language:
        json["language"] != null ? Language.fromMap(json["language"]) : null,
    voice: json["voice"] != null ? Voice.fromMap(json["voice"]) : null,
    country: json["country"] != null ? Country.fromMap(json["country"]) : null,
    city: json["city"] != null ? City.fromMap(json["city"]) : null,
    personality:
        json["personality"] != null
            ? Personality.fromMap(json["personality"])
            : null,
    relationship:
        json["relationship"] != null
            ? Relationship.fromMap(json["relationship"])
            : null,
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

    refImage: json["ref_image"],
    imageDescription: json["ref_image_description"],
    backStory: json["ref_image_backstory"],
    prompt: json["prompt"],

    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: DateTime.parse(json["updated_date"]),
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "creatorId": creatorId,
    "creatorUserType": creatorUserType,

    "name": name,
    "bio": bio,
    "age": age,
    "gender": gender,
    "style": style,
    "character_description": characterDescription,
    "sexual_orientation": sexualOrientation,

    "language": country?.toMap(),
    "voice": voice?.toMap(),
    "country": country?.toMap(),
    "city": city?.toMap(),
    "personality": personality?.toMap(),
    "relationship": relationship?.toMap(),
    "character_type": characterType?.toMap(),
    "behaviour": List<GenImage>.from(behaviours.map((b) => b.toMap())),
    "image_gallery": List<dynamic>.from(imageGallery.map((x) => x.toMap())),

    "ref_image": refImage,
    "ref_image_description": imageDescription,
    "ref_image_backstory": backStory,
    "prompt": prompt,

    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
    "status": status,
  };

  CharacterDetail copyWith({
    String? id,
    String? creatorId,
    String? creatorUserType,

    String? name,
    String? bio,
    String? age,
    String? gender,
    String? style,
    String? characterDescription,
    String? sexualOrientation,

    Language? language,
    Voice? voice,
    Country? country,
    City? city,
    Personality? personality,
    Relationship? relationship,
    CharacterType? characterType,
    List<Behaviour>? behaviours,
    List<GenImage>? imageGallery,

    String? refImage,
    String? imageDescription,
    String? backStory,
    String? prompt,

    DateTime? createdDate,
    DateTime? updatedDate,
    int? status,
  }) {
    return CharacterDetail(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      creatorUserType: creatorUserType ?? this.creatorUserType,

      name: name ?? this.name,
      bio: bio ?? this.bio,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      style: style ?? this.style,
      characterDescription: characterDescription ?? this.characterDescription,
      sexualOrientation: sexualOrientation ?? this.sexualOrientation,

      language: language ?? this.language,
      voice: voice ?? this.voice,
      country: country ?? this.country,
      city: city ?? this.city,
      personality: personality ?? this.personality,
      relationship: relationship ?? this.relationship,
      characterType: characterType ?? this.characterType,
      behaviours: behaviours ?? this.behaviours,
      imageGallery: imageGallery ?? this.imageGallery,

      refImage: refImage ?? this.refImage,
      imageDescription: imageDescription ?? this.imageDescription,
      backStory: backStory ?? this.backStory,
      prompt: prompt ?? this.prompt,

      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
      status: status ?? this.status,
    );
  }

  Character toCharacter() => Character(
    id: id,
    creatorId: creatorId,
    creatorUserType: creatorUserType,
    name: name,
    age: age,
    gender: gender,
    style: style,
    characterDescription: characterDescription,
    sexualOrientation: sexualOrientation,
    languageId: language?.id,
    charactertypeId: characterType?.id ?? "",
    relationshipId: relationship?.id,
    personalityId: personality?.id,
    behaviourIds: behaviours.map((e) => e.id).toList(),
    voiceId: voice?.id,
    countryId: country?.id,
    cityId: city?.id,
    refImage: refImage,
    refImageDescription: imageDescription,
    refImageBackstory: backStory,
    prompt: prompt,
    imageGallery: imageGallery,
    createdDate: createdDate,
    updatedDate: updatedDate,
  );
}
