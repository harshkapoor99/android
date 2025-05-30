import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:guftagu_mobile/services/profile_settings_service.dart';
import 'package:guftagu_mobile/utils/entensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../models/master/master_models.dart';
import '../services/hive_service.dart';
import '../models/user_model.dart';
import 'master_data_provider.dart';

part '../gen/providers/profile_settings_provider.gen.dart';

@riverpod
class ProfileSettings extends _$ProfileSettings {
  ProfileService get _service => ref.read(profileServiceProvider);
  HiveService get _hiveService => ref.read(hiveServiceProvider.notifier);

  @override
  ProfileSettingsState build() {
    final user = _loadUserData();
    final countries = ref.read(masterDataProvider).countries;
    final initialState = ProfileSettingsState(
      nameController: TextEditingController(),
      emailController: TextEditingController(),
      phoneController: TextEditingController(),
      otpController: TextEditingController(),
      initialUserInfo: user,
      gender:
          user?.profile.gender.isNotEmpty == true ? user!.profile.gender : null,
      country:
          user?.profile.country.isNotEmpty == true
              ? user?.profile.country
              : null,
      countryId:
          countries
              .firstWhereOrNull(
                (element) => element.countryName == user?.profile.country,
              )
              ?.id,
      city: user?.profile.city.isNotEmpty == true ? user?.profile.city : null,
      dob: DateTime.tryParse(user?.profile.dateOfBirth ?? ""),
    );

    initialState.nameController.setText(user?.profile.fullName ?? "--");
    initialState.emailController.setText(user?.email ?? "--");
    initialState.phoneController.setText(user?.mobileNumber ?? "--");

    ref.onDispose(() {
      state.nameController.dispose();
      state.emailController.dispose();
      state.phoneController.dispose();
    });

    return initialState;
  }

  User? _loadUserData() {
    return _hiveService.getUserInfo();
  }

  void setDob(DateTime dob) {
    state = state.updateWith(dob: dob);
  }

  void setGender(String? gender) {
    state = state.updateWith(gender: gender);
  }

  void updateCountryCityWith({Country? country, City? city}) {
    String? updatedCountryName = state.country;
    String? updatedCityName = state.city;

    if (country != null && country.countryName != state.country) {
      updatedCountryName = country.countryName;
      updatedCityName = null;
      state.countryId = country.id;

      ref
          .read(masterDataProvider.notifier)
          .fetchCitiesByCountry(country: country);
    }

    if (city != null && city.cityName != state.city) {
      updatedCityName = city.cityName;
    }

    state.country = updatedCountryName;
    state.city = updatedCityName;

    state = state.update(state);
  }

  Future<bool> updateProfile() async {
    try {
      state = state.updateWith(isLoading: true, error: null);

      final userInfo = _hiveService.getUserInfo();

      if (userInfo?.id == null || userInfo!.id.isEmpty) {
        throw Exception('User ID not found. Please log in again.');
      }

      if (state.dob == null) {
        throw Exception('Date of Birth is required.');
      }

      final formattedDob = DateFormat('yyyy-MM-dd').format(state.dob!);

      final response = await _service.updateProfile(
        userId: userInfo.id,
        name: state.nameController.text.trim(),
        gender: state.gender ?? '',
        dateOfBirth: formattedDob,
        email: state.emailController.text.trim(),
        phone: state.phoneController.text.trim(),
        country: state.country,
        city: state.city,
        imageUrl: state.imageUrl,
      );

      if (response.statusCode == 200) {
        _hiveService.updateUserInfo(
          username: userInfo.username,
          email:
              state.emailController.text.trim() != "N/A"
                  ? state.emailController.text.trim()
                  : userInfo.email,
          mobileNumber:
              state.phoneController.text.trim() != "N/A"
                  ? state.phoneController.text.trim()
                  : userInfo.mobileNumber,
          fullName: state.nameController.text.trim(),
          gender: state.gender,
          dateOfBirth: formattedDob,
          country: state.country,
          city: state.city,
          profilePicture: state.imageUrl,
          bio: userInfo.profile.bio,
        );

        state = state.updateWith(
          isLoading: false,
          initialUserInfo: _hiveService.getUserInfo(),
        );
        return true;
      } else {
        throw Exception(response.data['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      state = state.updateWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> uploadProfileImage(XFile image) async {
    try {
      state = state.updateWith(isLoading: true, error: null);

      final response = await _service.uploadProfileImage(
        ref.read(hiveServiceProvider.notifier).getUserId()!,
        image,
      );

      if (response.statusCode == 200) {
        state = state.updateWith(
          isLoading: false,
          imageUrl: response.data["profile_picture_url"],
        );
        return true;
      } else {
        throw Exception(response.data['message'] ?? 'Image upload failed');
      }
    } catch (e) {
      state = state.updateWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  bool hasUnsavedChanges() {
    final originalInfo = state.initialUserInfo;
    if (originalInfo == null) return false;

    if (state.nameController.text.trim() != (originalInfo.profile.fullName)) {
      return true;
    }

    if (state.gender != originalInfo.profile.gender) {
      return true;
    }

    final currentEmail = state.emailController.text.trim();
    final originalEmail =
        originalInfo.email.hasValue ? originalInfo.email : "N/A";
    if (currentEmail != "N/A" && currentEmail != originalEmail) {
      return true;
    }

    final currentPhone = state.phoneController.text.trim();
    final originalPhone =
        originalInfo.mobileNumber.hasValue ? originalInfo.mobileNumber : "N/A";
    if (currentPhone != "N/A" && currentPhone != originalPhone) {
      return true;
    }

    DateTime? originalDob;
    if (originalInfo.profile.dateOfBirth != null &&
        originalInfo.profile.dateOfBirth!.isNotEmpty) {
      try {
        originalDob = DateTime.parse(originalInfo.profile.dateOfBirth!);
      } catch (e) {
        originalDob = null;
      }
    }
    if (state.dob != originalDob) {
      return true;
    }

    if (state.country != originalInfo.profile.country) {
      return true;
    }

    if (state.city != originalInfo.profile.city) {
      return true;
    }

    return false;
  }
}

class ProfileSettingsState {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController otpController;
  DateTime? dob;
  String? gender;
  String? country;
  String? countryId;
  String? city;
  bool isLoading;
  String? error;
  String? imageUrl;
  User? initialUserInfo;
  final List<String> genders = ['Male', 'Female', 'Others'];

  ProfileSettingsState({
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.otpController,
    this.dob,
    this.gender,
    this.country,
    this.countryId,
    this.city,
    this.isLoading = false,
    this.error,
    this.imageUrl,
    this.initialUserInfo,
  });

  ProfileSettingsState updateWith({
    TextEditingController? nameController,
    TextEditingController? emailController,
    TextEditingController? phoneController,
    TextEditingController? otpController,
    DateTime? dob,
    String? gender,
    String? country,
    String? city,
    bool? isLoading,
    String? error,
    String? imageUrl,
    User? initialUserInfo,
  }) {
    return ProfileSettingsState(
      nameController: nameController ?? this.nameController,
      emailController: emailController ?? this.emailController,
      phoneController: phoneController ?? this.phoneController,
      otpController: otpController ?? this.otpController,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      city: city ?? this.city,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      imageUrl: imageUrl ?? this.imageUrl,
      initialUserInfo: initialUserInfo ?? this.initialUserInfo,
    );
  }

  ProfileSettingsState update(ProfileSettingsState state) {
    return ProfileSettingsState(
      nameController: state.nameController,
      emailController: state.emailController,
      phoneController: state.phoneController,
      otpController: state.otpController,
      dob: state.dob,
      gender: state.gender,
      country: state.country,
      countryId: state.countryId,
      city: state.city,
      isLoading: state.isLoading,
      error: state.error,
      imageUrl: state.imageUrl,
      initialUserInfo: state.initialUserInfo,
    );
  }
}
