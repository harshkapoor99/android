import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/services/profile_settings_service.dart';
import 'package:guftagu_mobile/utils/entensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../models/master/master_models.dart';
import '../services/hive_service.dart';
import '../models/user_model.dart';
import 'master_data_provider.dart';

final profileSettingsProvider = StateNotifierProvider.autoDispose<ProfileSettingsNotifier, ProfileSettingsState>((ref) {
  final service = ref.watch(profileServiceProvider);
  return ProfileSettingsNotifier(ref, service);
});

class ProfileSettingsState {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final DateTime? dob;
  final String? gender;
  final Country? country;
  final City? city;
  final bool isLoading;
  final String? error;
  final User? initialUserInfo; // To store the original user info for comparison

  ProfileSettingsState({
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    this.dob,
    this.gender,
    this.country,
    this.city,
    this.isLoading = false,
    this.error,
    this.initialUserInfo,
  });

  ProfileSettingsState copyWith({
    TextEditingController? nameController,
    TextEditingController? emailController,
    TextEditingController? phoneController,
    DateTime? dob,
    String? gender,
    Country? country,
    City? city,
    bool? isLoading,
    String? error,
    User? initialUserInfo,
  }) {
    return ProfileSettingsState(
      nameController: nameController ?? this.nameController,
      emailController: emailController ?? this.emailController,
      phoneController: phoneController ?? this.phoneController,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      city: city ?? this.city,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      initialUserInfo: initialUserInfo ?? this.initialUserInfo,
    );
  }
}

class ProfileSettingsNotifier extends StateNotifier<ProfileSettingsState> {
  final Ref _ref;
  final ProfileService _service;

  ProfileSettingsNotifier(this._ref, this._service)
      : super(ProfileSettingsState(
    nameController: TextEditingController(),
    emailController: TextEditingController(),
    phoneController: TextEditingController(),
  )) {
    _loadUserData(); // Load user data
  }

  final List<String> genders = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  void _loadUserData() {
    final hiveService = _ref.read(hiveServiceProvider.notifier);
    final userInfo = hiveService.getUserInfo();

    if (userInfo != null) {
      state.nameController.text = userInfo.profile.fullName ?? '';
      state.emailController.text = userInfo.email.hasValue ? userInfo.email : "N/A";
      state.phoneController.text = userInfo.mobileNumber.hasValue ? userInfo.mobileNumber : "N/A";

      DateTime? initialDob;
      if (userInfo.profile.dateOfBirth != null && userInfo.profile.dateOfBirth!.isNotEmpty) {
        try {
          initialDob = DateTime.parse(userInfo.profile.dateOfBirth!);
        } catch (e) {
          // Handle parsing error if date format is unexpected
          initialDob = null;
        }
      }

      // Update the state with loaded data and initial user info
      state = state.copyWith(
        dob: initialDob,
        gender: userInfo.profile.gender,
        initialUserInfo: userInfo, // Store original user info
      );

      _loadLocationData(userInfo);
    }
  }

  void _loadLocationData(User userInfo) {
    if (userInfo.profile.country != null || userInfo.profile.city != null) {
      // Deferring this to the next frame to ensure masterData is available
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final masterData = _ref.read(masterDataProvider);

        if (userInfo.profile.country != null && userInfo.profile.country!.isNotEmpty) {
          final country = masterData.countries.where((c) =>
          c.countryName.toLowerCase() == userInfo.profile.country!.toLowerCase()
          ).firstOrNull;

          if (country != null) {
            updateCountryCityWith(country: country);

            if (userInfo.profile.city != null && userInfo.profile.city!.isNotEmpty) {
              final city = masterData.cities.where((c) =>
              c.cityName.toLowerCase() == userInfo.profile.city!.toLowerCase() &&
                  c.countryId == country.id
              ).firstOrNull;

              if (city != null) {
                updateCountryCityWith(city: city);
              }
            }
          }
        }
      });
    }
  }


  void setDob(DateTime dob) {
    state = state.copyWith(dob: dob);
  }

  void setGender(String? gender) {
    state = state.copyWith(gender: gender);
  }

  void updateCountryCityWith({Country? country, City? city}) {
    Country? updatedCountry = state.country;
    City? updatedCity = state.city;

    if (country != null && country.id != state.country?.id) {
      updatedCountry = country;
      updatedCity = null;

      if (country.id != null) {
        _ref.read(masterDataProvider.notifier).fetchCitiesByCountry(country: country);
      }
    }

    if (city != null && city.id != state.city?.id) {
      updatedCity = city;
    }

    state = state.copyWith(country: updatedCountry, city: updatedCity);
  }

  Future<bool> updateProfile() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final hiveService = _ref.read(hiveServiceProvider.notifier);
      final userInfo = hiveService.getUserInfo();

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
        countryId: state.country?.id,
        cityId: state.city?.id,
      );

      if (response.statusCode == 200) {
        hiveService.updateUserInfo(
          username: userInfo.username,
          email: state.emailController.text.trim() != "N/A" ? state.emailController.text.trim() : userInfo.email,
          mobileNumber: state.phoneController.text.trim() != "N/A" ? state.phoneController.text.trim() : userInfo.mobileNumber,
          fullName: state.nameController.text.trim(),
          gender: state.gender,
          dateOfBirth: formattedDob,
          country: state.country?.countryName,
          city: state.city?.cityName,
          profilePicture: userInfo.profile.profilePicture,
          bio: userInfo.profile.bio,
          timezone: userInfo.profile.timezone,
          status: userInfo.status,
        );
        state = state.copyWith(
          isLoading: false,
          initialUserInfo: hiveService.getUserInfo(), // Update initial user info after successful save
        );
        return true;
      } else {
        throw Exception(response.data['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> uploadProfileImage(XFile image) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await _service.uploadProfileImage(image);

      if (response.statusCode == 200) {
        // Potentially update profile picture in hive service and state
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        throw Exception(response.data['message'] ?? 'Image upload failed');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  bool hasUnsavedChanges() {
    final originalInfo = state.initialUserInfo;
    if (originalInfo == null) return false;

    if (state.nameController.text.trim() != (originalInfo.profile.fullName ?? '')) {
      return true;
    }

    if (state.gender != originalInfo.profile.gender) {
      return true;
    }

    final currentEmail = state.emailController.text.trim();
    final originalEmail = originalInfo.email.hasValue ? originalInfo.email : "N/A";
    if (currentEmail != "N/A" && currentEmail != originalEmail) {
      return true;
    }

    final currentPhone = state.phoneController.text.trim();
    final originalPhone = originalInfo.mobileNumber.hasValue ? originalInfo.mobileNumber : "N/A";
    if (currentPhone != "N/A" && currentPhone != originalPhone) {
      return true;
    }

    DateTime? originalDob;
    if (originalInfo.profile.dateOfBirth != null && originalInfo.profile.dateOfBirth!.isNotEmpty) {
      try {
        originalDob = DateTime.parse(originalInfo.profile.dateOfBirth!);
      } catch (e) {
        originalDob = null;
      }
    }
    if (state.dob != originalDob) {
      return true;
    }

    if (state.country?.countryName != originalInfo.profile.country) {
      return true;
    }

    if (state.city?.cityName != originalInfo.profile.city) {
      return true;
    }

    return false;
  }


  @override
  void dispose() {
    state.nameController.dispose();
    state.emailController.dispose();
    state.phoneController.dispose();
    super.dispose();
  }
}