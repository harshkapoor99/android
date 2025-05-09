import 'package:guftagu_mobile/models/gen_image.dart';

class Character {
  final String id;
  final String creatorId;
  final String creatorUserType;
  final String name;
  final String age;
  final String gender;
  final String style;
  final String languageId;
  final String personalityId;
  final String relationshipId;
  final List<String> behaviourIds;
  final dynamic voiceId;
  final dynamic countryId;
  final dynamic cityId;
  final dynamic charactertypeId;
  final dynamic refImage;
  final dynamic refImageDescription;
  final dynamic refImageBackstory;
  final String prompt;
  final List<GenImage> imageGallery;
  final DateTime createdDate;
  final DateTime updatedDate;

  Character({
    required this.id,
    required this.creatorId,
    required this.creatorUserType,
    required this.name,
    required this.age,
    required this.gender,
    required this.style,
    required this.languageId,
    required this.personalityId,
    required this.relationshipId,
    required this.behaviourIds,
    required this.voiceId,
    required this.countryId,
    required this.cityId,
    required this.charactertypeId,
    required this.refImage,
    required this.refImageDescription,
    required this.refImageBackstory,
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
    languageId: json["language_id"],
    personalityId: json["personality_id"],
    relationshipId: json["relationship_id"],
    behaviourIds: List<String>.from(json["behaviour_ids"]),
    voiceId: json["voice_id"],
    countryId: json["country_id"],
    cityId: json["city_id"],
    charactertypeId: json["charactertype_id"],
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
    "language_id": languageId,
    "personality_id": personalityId,
    "relationship_id": relationshipId,
    "behaviour_ids": behaviourIds,
    "voice_id": voiceId,
    "country_id": countryId,
    "city_id": cityId,
    "charactertype_id": charactertypeId,
    "ref_image": refImage,
    "ref_image_description": refImageDescription,
    "ref_image_backstory": refImageBackstory,
    "prompt": prompt,
    "image_gallery": List<dynamic>.from(imageGallery.map((x) => x.toMap())),
    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
  };
}
