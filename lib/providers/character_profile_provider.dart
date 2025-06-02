import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:guftagu_mobile/models/character_details.dart';
import 'package:guftagu_mobile/models/gen_image.dart';
import 'package:guftagu_mobile/providers/chat_provider.dart';
import 'package:guftagu_mobile/services/character_creation.dart';
import 'package:guftagu_mobile/services/chat_service.dart';
import 'package:guftagu_mobile/services/hive_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/providers/character_profile_provider.gen.dart';

@riverpod
class CharacterProfile extends _$CharacterProfile {
  @override
  Future<CharacterProfileState> build() async {
    try {
      final response = await ref
          .read(chatServiceProvider)
          .fetchCharacterDetails(
            characterId: ref.read(chatProvider).character!.id,
          );

      final characterDetail = CharacterDetail.fromMap(response.data["data"]);

      return CharacterProfileState(
        characterDetail: characterDetail,
        descriptionController: TextEditingController(
          text: characterDetail.imageDescription,
        ),
        isFetching: false,
        editMode: false,
      );
    } catch (e, st) {
      // Convert any errors to AsyncValue error state
      throw AsyncError(e, st);
    }
  }

  Future<void> toggleEditMode() async {
    final currentState = await future;
    state = AsyncData(
      currentState._updateWith(editMode: !currentState.editMode),
    );
  }

  void generateRandomPrompt() async {
    try {
      // Set loading state
      final currentState = await future;
      state = AsyncData(currentState._updateWith(isFetching: true));

      final response = await ref
          .read(characterServiceProvider)
          .generateRandomPrompt(
            name: currentState.characterDetail.name,
            age: currentState.characterDetail.age!,
            gender: currentState.characterDetail.gender!,
            style: currentState.characterDetail.style!,
            languageId: currentState.characterDetail.language!.id,
            charactertypeId: currentState.characterDetail.characterType!.id,
            relationshipId: currentState.characterDetail.relationship!.id,
            personalityId: currentState.characterDetail.personality!.id,
            behaviourIds:
                currentState.characterDetail.behaviours
                    .map((b) => b.id)
                    .toList(),
            voiceId: currentState.characterDetail.voice?.id,
            countryId: currentState.characterDetail.country?.id,
            cityId: currentState.characterDetail.city?.id,
          );

      if (response.statusCode == 200) {
        final randomPrompt = response.data['random_prompt'];
        final updatedState = currentState._updateWith(isFetching: false);
        updatedState.descriptionController.text = randomPrompt;
        state = AsyncData(updatedState);
      } else {
        // Handle API error
        state = AsyncData(currentState._updateWith(isFetching: false));
        // You might want to show an error message here
      }
    } on DioException {
      // Handle Dio errors
      final currentState = await future;
      state = AsyncData(currentState._updateWith(isFetching: false));
      // Re-throw or handle error as needed
      rethrow;
    }
  }

  void generateNewImages() async {
    try {
      // Set loading state
      final currentState = await future;
      state = AsyncData(currentState._updateWith(isGeneratingImages: true));

      final response = await ref
          .read(characterServiceProvider)
          .characterImageUpdate(
            characterId: currentState.characterDetail.id,
            refImageDescription: currentState.descriptionController.text,
            refImageBackstory: currentState.characterDetail.backStory,
          );

      if (response.statusCode == 200) {
        final resImages = response.data['image_gallery'];
        List<GenImage> images = List<GenImage>.from(
          resImages.map((x) => GenImage.fromMap(x)),
        );
        final updatedState = currentState._updateWith(
          isGeneratingImages: false,
        );
        updatedState.genImages = images;
        state = AsyncData(updatedState);
      } else {
        // Handle API error
        state = AsyncData(currentState._updateWith(isGeneratingImages: false));
        // You might want to show an error message here
      }
    } on DioException {
      // Handle Dio errors
      final currentState = await future;
      state = AsyncData(currentState._updateWith(isGeneratingImages: false));
      // Re-throw or handle error as needed
      rethrow;
    }
  }

  void selectImage(GenImage image) async {
    final currentState = await future;
    state = AsyncData(currentState._updateWith(seletedCharacterImage: image));
  }

  void updateImage() async {
    try {
      // Set loading state
      final currentState = await future;
      if (currentState.seletedCharacterImage != null) {
        state = AsyncData(currentState._updateWith(isGeneratingImages: true));

        final response = await ref
            .read(characterServiceProvider)
            .selectImage(
              characterId: currentState.characterDetail.id,
              creatorId: ref.read(hiveServiceProvider.notifier).getUserId()!,
              imageId: currentState.seletedCharacterImage!.id,
            );

        if (response.statusCode == 200) {
          GenImage genImage = GenImage(
            id: currentState.seletedCharacterImage!.id,
            url: currentState.seletedCharacterImage!.url,
            selected: true,
          );
          List<GenImage> newImageGallery = [genImage];
          final updatedState = currentState._updateWith(
            isGeneratingImages: false,
            genImages: [],
            editMode: false,
            characterDetail: currentState.characterDetail.copyWith(
              imageGallery: newImageGallery,
            ),
          );
          ref.read(chatProvider.notifier).updateImage(genImage);
          state = AsyncData(updatedState);
        } else {
          // Handle API error
          state = AsyncData(
            currentState._updateWith(isGeneratingImages: false),
          );
          // You might want to show an error message here
        }
      }
    } on DioException {
      // Handle Dio errors
      final currentState = await future;
      state = AsyncData(currentState._updateWith(isGeneratingImages: false));
      // Re-throw or handle error as needed
      rethrow;
    }
  }
}

class CharacterProfileState {
  CharacterProfileState({
    required this.characterDetail,
    required this.descriptionController,
    this.genImages = const [],
    this.seletedCharacterImage,
    this.isFetching = false,
    this.isGeneratingImages = false,
    this.editMode = false,
  });

  CharacterDetail characterDetail;
  TextEditingController descriptionController;
  List<GenImage> genImages;
  GenImage? seletedCharacterImage;
  bool isFetching, editMode, isGeneratingImages;

  CharacterProfileState _updateWith({
    CharacterDetail? characterDetail,
    TextEditingController? descriptionController,
    List<GenImage>? genImages,
    GenImage? seletedCharacterImage,
    bool? isFetching,
    bool? isGeneratingImages,
    bool? editMode,
  }) {
    return CharacterProfileState(
      characterDetail: characterDetail ?? this.characterDetail,
      descriptionController:
          descriptionController ?? this.descriptionController,
      genImages: genImages ?? this.genImages,
      seletedCharacterImage:
          seletedCharacterImage ?? this.seletedCharacterImage,
      isFetching: isFetching ?? this.isFetching,
      isGeneratingImages: isGeneratingImages ?? this.isGeneratingImages,
      editMode: editMode ?? this.editMode,
    );
  }
}
