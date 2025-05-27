import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/configs/endpoint.dart';
import 'package:guftagu_mobile/services/api_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/services/profile_settings_service.gen.dart';

@riverpod
ProfileService profileService(ProfileServiceRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProfileServiceImpl(apiClient);
}

abstract class ProfileService {
  Future<Response> updateProfile({
    required String userId,
    required String name,
    required String gender,
    required String dateOfBirth,
    required String email,
    required String phone,
    String? countryId,
    String? cityId,
    String? refNewImageUrl,
  });

  Future<Response> uploadProfileImage(XFile image);
}

class ProfileServiceImpl implements ProfileService {
  final ApiClient _apiClient;

  ProfileServiceImpl(this._apiClient);

  @override
  Future<Response> updateProfile({
    required String userId,
    required String name,
    required String gender,
    required String dateOfBirth,
    required String email,
    required String phone,
    String? countryId,
    String? cityId,
    String? refNewImageUrl,
  }) async {
    final response = await _apiClient.post(
      RemoteEndpoint.updateProfile.url,
      data: {
        "user_id": userId,
        "name": name,
        "gender": gender,
        "date_of_birth": dateOfBirth,
        "email": email,
        "phone": phone,
        "country": countryId,
        "city": cityId,
        "ref_new_image_url": refNewImageUrl,
      },
      timeout: const Duration(seconds: 30),
    );
    return response;
  }

  @override
  Future<Response> uploadProfileImage(XFile image) async {
    return _apiClient.post(
      RemoteEndpoint.updateProfileImage.url,
      data: FormData.fromMap({
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.name,
        ),
      }),
      timeout: const Duration(seconds: 30),
    );
  }
}