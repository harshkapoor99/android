import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/models/common/common_response_model.dart';
import 'package:guftagu_mobile/models/gen_image.dart';
import 'package:guftagu_mobile/models/master/master_models.dart';
import 'package:guftagu_mobile/providers/master_data_provider.dart';
import 'package:guftagu_mobile/services/character_creation.dart';
import 'package:guftagu_mobile/services/hive_service.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/providers/character_creation_provider.gen.dart';

@riverpod
bool nextButtonStatus(Ref ref) {
  final provider = ref.watch(characterCreationProvider);
  if (provider.index == 0 &&
      provider.characterNameController.text.isNotEmpty &&
      provider.ageController.text.isNotEmpty &&
      provider.sexualOrientation != null &&
      provider.gender != null
  // && provider.voice != null
  ) {
    return true;
  } else if (provider.index == 1 &&
      provider.style != null &&
      provider.language != null
  // uncomment to make it mandatory
  // provider.country != null &&
  // provider.city != null
  ) {
    return true;
  } else if (provider.index == 2 &&
      provider.characterType != null &&
      provider.personality != null &&
      provider.relationship != null &&
      provider.behaviours.length == 3) {
    return true;
  } else if (provider.index == 3
  // uncomment to make it mandatory
  // && provider.refImageUrl != null &&
  // provider.descriptionController.text.isNotEmpty &&
  // provider.backstoryController.text.isNotEmpty
  ) {
    return true;
  } else if (provider.index == 4 && provider.seletedCharacterImage != null) {
    return true;
  }

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
      ageController: TextEditingController(),
      descriptionController: TextEditingController(),
      backstoryController: TextEditingController(),
    );
    initState.characterNameController.addListener(() {
      state = state._updateWith(
        characterNameController: initState.characterNameController,
      );
    });
    //change
    initState.ageController.addListener(() {
      state = state._updateWith(ageController: initState.ageController);
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
    List<Behaviour>? behaviours,
    Voice? voice,
    CharacterType? characterType,
    Country? country,
    City? city,
    String? refImageUrl,
    XFile? uploadImage,
    GenImage? seletedCharacterImage,
  }) {
    state = state._updateWith(
      // age: age,
      gender: gender,
      style: style,
      sexualOrientation: sexualOrientation,
      language: language,
      personality: personality,
      relationship: relationship,
      behaviours: behaviours,
      characterType: characterType,
      voice: voice,
      country: country,
      city: city,
      refImageUrl: refImageUrl,
      // uploadImage: uploadImage,
      seletedCharacterImage: seletedCharacterImage,
    );
  }

  void updateRPBWith({
    CharacterType? characterType,
    Personality? personality,
    Relationship? relationship,
    List<Behaviour>? behaviours,
  }) {
    if (characterType != null) {
      state.characterType = characterType;
      state.relationship = null;
      state.personality = null;
      state.behaviours = [];
    } else if (relationship != null) {
      state.relationship = relationship;
      state.personality = null;
      state.behaviours = [];
    } else if (personality != null) {
      state.personality = personality;
      state.behaviours = [];
    } else if (behaviours != null) {
      state.behaviours = behaviours;
    }
    state = state._updateWithState(state);
  }

  void updateIndex(int index) {
    state = state._updateWith(index: index);
  }

  void resetState() {
    state = state._clear();
    state.pageController.jumpToPage(0);
    state.characterNameController.clear();
    state.ageController.clear();
    state.descriptionController.clear();
    state.backstoryController.clear();
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
            age: state.ageController.text,
            gender: state.gender!,
            style: state.style!,
            languageId: state.language!.id,
            charactertypeId: state.characterType!.id,
            relationshipId: state.relationship!.id,
            personalityId: state.personality!.id,
            behaviourIds: state.behaviours.map((b) => b.id).toList(),
            voiceId: state.voice?.id,
            countryId: state.country?.id,
            cityId: state.city?.id,
            refImage: state.refImageUrl,
            refImageDescription: state.descriptionController.text,
            refImageBackstory: state.backstoryController.text,
          );
      if (response.statusCode == 201) {
        final List<dynamic> imageGallery = response.data['image_gallery'];
        final List<GenImage> images =
            imageGallery.map((image) => GenImage.fromMap(image)).toList();
        state = state._updateWith(
          characterImages: images,
          chracterId: response.data['character_id'],
        );
      } else {
        AppConstants.showSnackbar(
          message: "Unable to create character",
          isSuccess: true,
        );
      }
    } on DioException {
      rethrow;
    } finally {
      state = state._updateWith(isCharacterGenerating: false);
    }
  }

  void uploadImage({XFile? image}) {
    state = state._updateWith(isImageUploading: true);
    ref
        .read(characterServiceProvider)
        .uploadImage(image) // ?? state.uploadImage!
        .then((response) {
          if (response.statusCode == 200) {
            state = state._updateWith(
              refImageUrl: response.data['url'],
              isImageUploading: false,
            );
          } else {
            state = state._updateWith(isImageUploading: false);
          }
        })
        .catchError((error) {
          state = state._updateWith(isImageUploading: false);
        });
  }

  Future<CommonResponse> selectCharacterImage() async {
    state = state._updateWith(isCharacterGenerating: true);
    try {
      final response = await ref
          .read(characterServiceProvider)
          .selectImage(
            characterId: state.chracterId,
            creatorId: ref.read(hiveServiceProvider.notifier).getUserId()!,
            imageId: state.seletedCharacterImage!.id,
          );
      if (response.statusCode == 200) {
        return CommonResponse(
          isSuccess: true,
          message: response.data["message"],
        );
      } else {
        return CommonResponse(isSuccess: false, message: "Could not create Ai");
      }
    } on DioException {
      return CommonResponse(isSuccess: false, message: "Something went wrong");
    } finally {
      state = state._updateWith(isCharacterGenerating: false);
    }
  }
}

class CharacterCreationState {
  CharacterCreationState({
    required this.pageController,
    required this.index,
    required this.characterNameController,
    required this.ageController, // change
    this.gender,
    this.style,
    this.sexualOrientation,
    this.language,
    this.personality,
    this.relationship,
    this.behaviours = const [],
    this.voice,
    this.country,
    this.city,
    this.characterType,
    // this.uploadImage,
    this.isImageUploading = false,
    this.refImageUrl,
    required this.descriptionController,
    required this.backstoryController,
    this.isCharacterGenerating = false,
    this.characterImages = const [],
    this.chracterId = "",
    this.seletedCharacterImage,
  });

  PageController pageController;
  int index;

  TextEditingController characterNameController;
  TextEditingController ageController; // change
  String? gender;
  String? style;
  String? sexualOrientation;
  Language? language;
  Personality? personality;
  Relationship? relationship;
  List<Behaviour> behaviours;
  Voice? voice;
  Country? country;
  City? city;
  CharacterType? characterType;
  //  XFile? uploadImage;
  String? refImageUrl;
  TextEditingController descriptionController;
  TextEditingController backstoryController;

  bool isCharacterGenerating, isImageUploading;
  String chracterId;
  List<GenImage> characterImages;
  GenImage? seletedCharacterImage;

  // _updateWith method to update the state
  CharacterCreationState _updateWith({
    PageController? pageController,
    int? index,
    TextEditingController? characterNameController,
    TextEditingController? ageController,
    String? gender,
    String? style,
    String? sexualOrientation,
    Language? language,
    Personality? personality,
    Relationship? relationship,
    List<Behaviour>? behaviours,
    Voice? voice,
    Country? country,
    City? city,
    CharacterType? characterType,
    String? refImageUrl,
    // XFile? uploadImage,
    bool? isImageUploading,
    TextEditingController? descriptionController,
    TextEditingController? backstoryController,
    bool? isCharacterGenerating,
    List<GenImage>? characterImages,
    String? chracterId,
    GenImage? seletedCharacterImage,
  }) {
    return CharacterCreationState(
      pageController: pageController ?? this.pageController,
      index: index ?? this.index,
      characterNameController:
          characterNameController ?? this.characterNameController,
      ageController: ageController ?? this.ageController,
      gender: gender ?? this.gender,
      style: style ?? this.style,
      sexualOrientation: sexualOrientation ?? this.sexualOrientation,
      language: language ?? this.language,
      personality: personality ?? this.personality,
      relationship: relationship ?? this.relationship,
      behaviours: behaviours ?? this.behaviours,
      voice: voice ?? this.voice,
      country: country ?? this.country,
      city: city ?? this.city,
      characterType: characterType ?? this.characterType,
      refImageUrl: refImageUrl ?? this.refImageUrl,
      // uploadImage: uploadImage ?? this.uploadImage,
      isImageUploading: isImageUploading ?? this.isImageUploading,
      descriptionController:
          descriptionController ?? this.descriptionController,
      backstoryController: backstoryController ?? this.backstoryController,
      isCharacterGenerating:
          isCharacterGenerating ?? this.isCharacterGenerating,
      characterImages: characterImages ?? this.characterImages,
      chracterId: chracterId ?? this.chracterId,
      seletedCharacterImage:
          seletedCharacterImage ?? this.seletedCharacterImage,
    );
  }

  // _updateWith method to update the state
  CharacterCreationState _updateWithState(CharacterCreationState state) {
    return CharacterCreationState(
      pageController: state.pageController,
      index: state.index,
      characterNameController: state.characterNameController,
      ageController: state.ageController,
      gender: state.gender,
      style: state.style,
      sexualOrientation: state.sexualOrientation,
      language: state.language,
      personality: state.personality,
      relationship: state.relationship,
      behaviours: state.behaviours,
      voice: state.voice,
      country: state.country,
      city: state.city,
      characterType: state.characterType,
      refImageUrl: state.refImageUrl,
      // uploadImage: state.uploadImage ,
      isImageUploading: state.isImageUploading,
      descriptionController: state.descriptionController,
      backstoryController: state.backstoryController,
      isCharacterGenerating: state.isCharacterGenerating,
      characterImages: state.characterImages,
      chracterId: state.chracterId,
      seletedCharacterImage: state.seletedCharacterImage,
    );
  }

  CharacterCreationState _clear() {
    return CharacterCreationState(
      pageController: pageController,
      index: 0,
      characterNameController: characterNameController,
      ageController: ageController,
      gender: null,
      style: null,
      sexualOrientation: null,
      language: null,
      personality: null,
      relationship: null,
      behaviours: [],
      voice: null,
      country: null,
      city: null,
      refImageUrl: null,
      isImageUploading: false,
      descriptionController: descriptionController,
      backstoryController: backstoryController,
      isCharacterGenerating: false,
      characterImages: [],
      chracterId: "",
      seletedCharacterImage: null,
    );
  }
}
