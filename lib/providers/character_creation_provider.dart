import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/providers/character_creation_provider.gen.dart';

@Riverpod(keepAlive: true)
class CharacterCreation extends _$CharacterCreation {
  @override
  CharacterCreationState build() {
    final initState = CharacterCreationState(
      pageController: PageController(keepPage: true),
      index: 0,
      characterNameController: TextEditingController(),
      descriptionController: TextEditingController(),
      backstoryController: TextEditingController(),
    );
    return initState;
  }

  void updateIndex(int index) {
    state = state._updateWith(index: index);
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
  });

  final PageController pageController;
  final int index;

  final TextEditingController characterNameController;
  final String? age;
  final String? gender;
  final String? style;
  final String? sexualOrientation;
  final String? language;
  final String? personality;
  final String? relationship;
  final String? behaviour;
  final String? voice;
  final String? country;
  final String? city;
  final String? refImageUrl;
  final TextEditingController descriptionController;
  final TextEditingController backstoryController;

  // _updateWith method to update the state
  CharacterCreationState _updateWith({
    PageController? pageController,
    int? index,
    TextEditingController? characterNameController,
    String? age,
    String? gender,
    String? style,
    String? sexualOrientation,
    String? language,
    String? personality,
    String? relationship,
    String? behaviour,
    String? voice,
    String? country,
    String? city,
    String? refImageUrl,
    TextEditingController? descriptionController,
    TextEditingController? backstoryController,
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
    );
  }
}
