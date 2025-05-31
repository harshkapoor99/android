import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/configs/endpoint.dart';
import 'package:guftagu_mobile/services/api_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/services/profile_settings_service.gen.dart';

@riverpod
ProfileService profileService(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProfileServiceImpl(apiClient);
}

abstract class ProfileService {
  Future<Response> updateName(String userId, String name);
  Future<Response> updateProfile({
    required String userId,
    required String name,
    required String gender,
    required String dateOfBirth,
    // required String email,
    // required String phone,
    String? country,
    String? city,
    String? imageUrl,
  });

  Future<Response> getUserDetails(String userId);
  Future<Response> uploadProfileImage(String userId, XFile image);

  Future<Response> userVerify(String userId, {String? email, String? phone});
  Future<Response> userVerifyOtp(
    String userId, {
    required String otp,
    String? email,
    String? phone,
  });
}

class ProfileServiceImpl implements ProfileService {
  final ApiClient _apiClient;

  ProfileServiceImpl(this._apiClient);

  @override
  Future<Response> updateName(String userId, String name) async {
    try {
      final response = await _apiClient.post(
        RemoteEndpoint.updateName.url,
        data: {"user_id": userId, "user_name": name},
      );
      return response;
    } catch (e) {
      throw Exception('Failed to update name: $e');
    }
  }

  @override
  Future<Response> updateProfile({
    required String userId,
    required String name,
    required String gender,
    required String dateOfBirth,
    // required String email,
    // required String phone,
    String? country,
    String? city,
    String? imageUrl,
  }) async {
    final response = await _apiClient.post(
      RemoteEndpoint.updateProfile.url,
      data: {
        "user_id": userId,
        "profile": {
          "full_name": name,
          "date_of_birth": dateOfBirth,
          "gender": gender,
          // "bio": null,
          "profile_picture": imageUrl,
          "country": country,
          "city": city,
        },
      },
    );
    return response;
  }

  @override
  Future<Response> uploadProfileImage(String userId, XFile image) async {
    return _apiClient.post(
      RemoteEndpoint.updateProfileImage.url,
      data: FormData.fromMap({
        "user_id": userId,
        'image': await MultipartFile.fromFile(image.path, filename: image.name),
      }),
    );
  }

  @override
  Future<Response> getUserDetails(String userId) async {
    final response = await _apiClient.post(
      RemoteEndpoint.profileDetails.url,
      data: {"user_id": userId},
    );
    return response;
  }

  @override
  Future<Response> userVerify(
    String userId, {
    String? email,
    String? phone,
  }) async {
    final response = await _apiClient.post(
      RemoteEndpoint.userVerify.url,
      data: {"user_id": userId, "email": email, "phone": phone},
      headers: _apiClient.authHeader,
    );
    return response;
  }

  @override
  Future<Response> userVerifyOtp(
    String userId, {
    required String otp,
    String? email,
    String? phone,
  }) async {
    final response = await _apiClient.post(
      RemoteEndpoint.userVerifyOtp.url,
      data: {"user_id": userId, "email": email, "phone": phone, "otp": otp},

      headers: _apiClient.authHeader,
    );
    return response;
  }
}
