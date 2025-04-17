import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/models/master/master_models.dart';
import 'package:guftagu_mobile/providers/master_data_provider.dart';
import 'package:guftagu_mobile/services/character_creation.dart';
import 'package:guftagu_mobile/services/hive_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/providers/character_creation_provider.gen.dart';

@riverpod
bool nextButtonStatus(Ref ref) {
  final provider = ref.watch(characterCreationProvider);
  if (provider.index == 0 &&
      provider.characterNameController.text.isNotEmpty &&
      provider.age != null &&
      provider.gender != null) {
    return true;
  } else if (provider.index == 1 &&
      provider.style != null &&
      provider.sexualOrientation != null &&
      provider.language != null) {
    return true;
  } else if (provider.index == 2 &&
      provider.personality != null &&
      provider.relationship != null &&
      provider.behaviour != null
  // uncomment to make it mandatory
  // && provider.voice != null &&
  // provider.country != null &&
  // provider.city != null
  ) {
    return true;
  } else if (provider.index == 3
  // uncomment to make it mandatory
  // && provider.refImageUrl != null &&
  // provider.descriptionController.text.isNotEmpty &&
  // provider.backstoryController.text.isNotEmpty
  ) {
    return true;
  }
  // REMOVE: remove this
  return false;
}

@Riverpod(keepAlive: true)
class CharacterCreation extends _$CharacterCreation {
  @override
  CharacterCreationState build() {
    ref.read(masterDataProvider.notifier).fetchAllMasterData();
    final initState = CharacterCreationState(
      pageController: PageController(keepPage: true),
      index: 0,
      characterNameController: TextEditingController(),
      descriptionController: TextEditingController(),
      backstoryController: TextEditingController(),
    );
    initState.characterNameController.addListener(() {
      state = state._updateWith(
        characterNameController: initState.characterNameController,
      );
    });
    initState.descriptionController.addListener(() {
      state = state._updateWith(
        descriptionController: initState.descriptionController,
      );
    });
    initState.backstoryController.addListener(() {
      state = state._updateWith(
        backstoryController: initState.backstoryController,
      );
    });
    return initState;
  }

  void updateWith({
    String? age,
    String? gender,
    String? style,
    String? sexualOrientation,
    Language? language,
    Personality? personality,
    Relationship? relationship,
    Behaviour? behaviour,
    Voice? voice,
    Country? country,
    City? city,
    String? refImageUrl,
  }) {
    state = state._updateWith(
      age: age,
      gender: gender,
      style: style,
      sexualOrientation: sexualOrientation,
      language: language,
      personality: personality,
      relationship: relationship,
      behaviour: behaviour,
      voice: voice,
      country: country,
      city: city,
      refImageUrl: refImageUrl,
    );
  }

  void updateIndex(int index) {
    state = state._updateWith(index: index);
  }

  void createCharacter() async {
    state = state._updateWith(isCharacterGenerating: true);
    try {
      final Response response = await ref
          .read(characterServiceProvider)
          .createCharacter(
            creatorId: ref.read(hiveServiceProvider.notifier).getUserId()!,
            creatorUserType: "user",
            name: state.characterNameController.text,
            age: state.age!,
            gender: state.gender!,
            style: state.style!,
            languageId: state.language!.id,
            behaviourId: state.behaviour!.id,
            personalityId: state.personality!.id,
            relationshipId: state.relationship!.id,
            voiceId: state.voice?.id,
            countryId: state.country?.id,
            cityId: state.city?.id,
            refImage: state.refImageUrl,
            refImageDescription: state.descriptionController.text,
            refImageBackstory: state.backstoryController.text,
          );
      print(response.data);
      if (response.statusCode == 200) {
        // Handle success
        state = state._updateWith(
          characterImages: List<String>.from(response.data['image_gallery']),
          chracterId: response.data['character_id'],
        );
        print("Character created successfully");
      } else {
        // Handle error
        print("Error creating character: ${response.data}");
      }
    } on DioException {
      rethrow;
    } finally {
      state = state._updateWith(isCharacterGenerating: false);
    }
  }
}

class CharacterCreationState {
  const CharacterCreationState({
    required this.pageController,
    required this.index,
    required this.characterNameController,
    this.age,
    this.gender,
    this.style,
    this.sexualOrientation,
    this.language,
    this.personality,
    this.relationship,
    this.behaviour,
    this.voice,
    this.country,
    this.city,
    this.refImageUrl,
    required this.descriptionController,
    required this.backstoryController,
    this.isCharacterGenerating = false,
    this.characterImages = const [],
    this.chracterId = "",
  });

  final PageController pageController;
  final int index;

  final TextEditingController characterNameController;
  final String? age;
  final String? gender;
  final String? style;
  final String? sexualOrientation;
  final Language? language;
  final Personality? personality;
  final Relationship? relationship;
  final Behaviour? behaviour;
  final Voice? voice;
  final Country? country;
  final City? city;
  final String? refImageUrl;
  final TextEditingController descriptionController;
  final TextEditingController backstoryController;

  final bool isCharacterGenerating;
  final String chracterId;
  final List<String> characterImages;

  // _updateWith method to update the state
  CharacterCreationState _updateWith({
    PageController? pageController,
    int? index,
    TextEditingController? characterNameController,
    String? age,
    String? gender,
    String? style,
    String? sexualOrientation,
    Language? language,
    Personality? personality,
    Relationship? relationship,
    Behaviour? behaviour,
    Voice? voice,
    Country? country,
    City? city,
    String? refImageUrl,
    TextEditingController? descriptionController,
    TextEditingController? backstoryController,
    bool? isCharacterGenerating,
    List<String>? characterImages,
    String? chracterId,
  }) {
    return CharacterCreationState(
      pageController: pageController ?? this.pageController,
      index: index ?? this.index,
      characterNameController:
          characterNameController ?? this.characterNameController,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      style: style ?? this.style,
      sexualOrientation: sexualOrientation ?? this.sexualOrientation,
      language: language ?? this.language,
      personality: personality ?? this.personality,
      relationship: relationship ?? this.relationship,
      behaviour: behaviour ?? this.behaviour,
      voice: voice ?? this.voice,
      country: country ?? this.country,
      city: city ?? this.city,
      refImageUrl: refImageUrl ?? this.refImageUrl,
      descriptionController:
          descriptionController ?? this.descriptionController,
      backstoryController: backstoryController ?? this.backstoryController,
      isCharacterGenerating:
          isCharacterGenerating ?? this.isCharacterGenerating,
      characterImages: characterImages ?? this.characterImages,
      chracterId: chracterId ?? this.chracterId,
    );
  }
}
