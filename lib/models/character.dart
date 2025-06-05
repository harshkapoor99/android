import 'package:guftagu_mobile/models/gen_image.dart';

class Character {
  final String id;
  final String creatorId;
  final String creatorUserType;
  final String name;
  final String? age;
  final String? gender;
  final String? style;
  final String? characterDescription;
  final String? sexualOrientation;
  final String? languageId;
  final String? charactertypeId;
  final String? relationshipId;
  final String? personalityId;
  final List<String> behaviourIds;
  final String? voiceId;
  final String? countryId;
  final String? cityId;
  final String? refImage;
  final String? refImageDescription;
  final String? refImageBackstory;
  final String prompt;
  final List<GenImage> imageGallery;
  final DateTime createdDate;
  final DateTime updatedDate;

  Character({
    required this.id,
    required this.creatorId,
    required this.creatorUserType,
    required this.name,
    this.age,
    this.gender,
    this.style,
    this.characterDescription,
    this.sexualOrientation,
    this.languageId,
    this.charactertypeId,
    this.relationshipId,
    this.personalityId,
    this.behaviourIds = const [],
    this.voiceId,
    this.countryId,
    this.cityId,
    this.refImage,
    this.refImageDescription,
    this.refImageBackstory,
    required this.prompt,
    required this.imageGallery,
    required this.createdDate,
    required this.updatedDate,
  });

  factory Character.fromMap(Map<String, dynamic> json) => Character(
    id: json["_id"],
    creatorId: json["creator_id"],
    creatorUserType: json["creator_user_type"],
    name: json["name"],
    age: json["age"],
    gender: json["gender"],
    style: json["style"],
    characterDescription: json["character_description"],
    sexualOrientation: json["sexual_orientation"],
    languageId: json["language_id"],
    charactertypeId: json["charactertype_id"] ?? "",
    relationshipId: json["relationship_id"],
    personalityId: json["personality_id"],
    behaviourIds: List<String>.from(json["behaviour_ids"]),
    voiceId: json["voice_id"],
    countryId: json["country_id"],
    cityId: json["city_id"],
    refImage: json["ref_image"],
    refImageDescription: json["ref_image_description"],
    refImageBackstory: json["ref_image_backstory"],
    prompt: json["prompt"],
    imageGallery: List<GenImage>.from(
      json["image_gallery"].map((x) => GenImage.fromMap(x)),
    ),
    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: DateTime.parse(json["updated_date"]),
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "creator_id": creatorId,
    "creator_user_type": creatorUserType,
    "name": name,
    "age": age,
    "gender": gender,
    "style": style,
    "character_description": characterDescription,
    "sexual_orientation": sexualOrientation,
    "language_id": languageId,
    "charactertype_id": charactertypeId,
    "relationship_id": relationshipId,
    "personality_id": personalityId,
    "behaviour_ids": behaviourIds,
    "voice_id": voiceId,
    "country_id": countryId,
    "city_id": cityId,
    "ref_image": refImage,
    "ref_image_description": refImageDescription,
    "ref_image_backstory": refImageBackstory,
    "prompt": prompt,
    "image_gallery": List<dynamic>.from(imageGallery.map((x) => x.toMap())),
    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
  };

  Character updateWith({
    // String? id,
    // String? creatorId,
    // String? creatorUserType,
    // String? name,
    // String? age,
    // String? gender,
    // String? style,
    // String? sexualOrientation,
    // String? languageId,
    // String? charactertypeId,
    // String? relationshipId,
    // String? personalityId,
    // List<String>? behaviourIds,
    // String? voiceId,
    // String? countryId,
    // String? cityId,
    String? refImage,
    String? refImageDescription,
    String? refImageBackstory,
    // String? prompt,
    List<GenImage>? imageGallery,
    // DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return Character(
      id: id,
      creatorId: creatorId,
      creatorUserType: creatorUserType,
      name: name,
      age: age,
      gender: gender,
      style: style,
      characterDescription: characterDescription,
      sexualOrientation: sexualOrientation,
      languageId: languageId,
      charactertypeId: charactertypeId,
      relationshipId: relationshipId,
      personalityId: personalityId,
      behaviourIds: behaviourIds,
      voiceId: voiceId,
      countryId: countryId,
      cityId: cityId,
      refImage: refImage,
      refImageDescription: refImageDescription,
      refImageBackstory: refImageBackstory,
      prompt: prompt,
      imageGallery: imageGallery ?? this.imageGallery,
      createdDate: createdDate,
      updatedDate: DateTime.now(),
    );
  }
}
