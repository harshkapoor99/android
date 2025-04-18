import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/configs/endpoint.dart';
import 'package:guftagu_mobile/services/api_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/services/character_creation.gen.dart';

@riverpod
CharacterService characterService(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);

  return CharacterServiceImpl(apiClient);
}

abstract class CharacterService {
  Future<Response> uploadImage(XFile? uploadImage);
  Future<Response> createCharacter({
    required String creatorId,
    required String creatorUserType,
    required String name,
    required String age,
    required String gender,
    required String style,
    required String languageId,
    required String behaviourId,
    required String personalityId,
    required String relationshipId,
    String? voiceId,
    String? countryId,
    String? cityId,
    String? refImage,
    String? refImageDescription,
    String? refImageBackstory,
  });

  Future<Response> selectImage({
    required String characterId,
    required String creatorId,
    required String imageId,
  });
}

class CharacterServiceImpl implements CharacterService {
  final ApiClient _apiClient;
  CharacterServiceImpl(this._apiClient);

  @override
  Future<Response> uploadImage(XFile? uploadImage) async {
    return _apiClient.post(
      RemoteEndpoint.refImageUpload.url,
      data: FormData.fromMap({
        'image': await MultipartFile.fromFile(
          uploadImage!.path,
          filename: uploadImage.name,
        ),
      }),
      timeout: const Duration(seconds: 30),
    );
  }

  @override
  Future<Response> createCharacter({
    required String creatorId,
    required String creatorUserType,
    required String name,
    required String age,
    required String gender,
    required String style,
    required String languageId,
    required String behaviourId,
    required String personalityId,
    required String relationshipId,
    String? voiceId,
    String? countryId,
    String? cityId,
    String? refImage,
    String? refImageDescription,
    String? refImageBackstory,
  }) async {
    final response = await _apiClient.post(
      RemoteEndpoint.createCharacter.url,
      data: {
        "creator_id": creatorId,
        "creator_user_type": creatorUserType,
        "name": name,
        "age": age,
        "gender": gender,
        "style": style,
        "language_id": languageId,
        "behaviour_id": behaviourId,
        "personality_id": personalityId,
        "relationship_id": relationshipId,
        "voice_id": voiceId,
        "country_id": countryId,
        "city_id": cityId,
        "ref_image": refImage,
        "ref_image_description": refImageDescription,
        "ref_image_backstory": refImageBackstory,
      },
      timeout: const Duration(seconds: 30),
    );
    return response;
  }

  @override
  Future<Response> selectImage({
    required String characterId,
    required String creatorId,
    required String imageId,
  }) {
    // TODO: implement selectImage
    throw UnimplementedError();
  }
}
