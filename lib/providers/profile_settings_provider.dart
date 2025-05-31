import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:guftagu_mobile/utils/validators.dart';
import 'package:pinput/pinput.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:guftagu_mobile/services/profile_settings_service.dart';
import 'package:guftagu_mobile/utils/extensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../models/master/master_models.dart';
import '../services/hive_service.dart';
import '../models/user_model.dart';
import 'master_data_provider.dart';

part '../gen/providers/profile_settings_provider.gen.dart';

@riverpod
bool hasUnsavedChanges(Ref ref) {
  final state = ref.watch(profileSettingsProvider);
  final originalInfo = state.initialUserInfo;
  if (originalInfo == null) return false;

  if (state.nameController.text.trim() != (originalInfo.profile.fullName)) {
    return true;
  }

  if (state.gender != null && state.gender != originalInfo.profile.gender) {
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

  if (state.country != null && state.country != originalInfo.profile.country) {
    return true;
  }

  if (state.city != null && state.city != originalInfo.profile.city) {
    return true;
  }

  return false;
}

@riverpod
bool hasEmailChanged(Ref ref) {
  final state = ref.watch(profileSettingsProvider);
  final originalInfo = state.initialUserInfo;
  if (originalInfo == null) return false;
  final currentEmail = state.emailController.text.trim();
  final originalEmail = originalInfo.email.hasValue ? originalInfo.email : "";
  if (currentEmail != "" && currentEmail != originalEmail) {
    return true && EmailOrPhoneValidator.isValidEmail(currentEmail);
  }
  if (state.isEmailVerified) return false;
  return false;
}

@riverpod
bool hasPhoneChanged(Ref ref) {
  final state = ref.watch(profileSettingsProvider);
  final originalInfo = state.initialUserInfo;
  if (originalInfo == null) return false;
  final currentPhone = state.phoneController.text.trim();
  final originalPhone =
      originalInfo.mobileNumber.hasValue ? originalInfo.mobileNumber : "";
  if (currentPhone != "" &&
      currentPhone != originalPhone &&
      currentPhone.length == 10) {
    return true && EmailOrPhoneValidator.isValidPhoneNumber(currentPhone);
  }
  if (state.isPhoneVerified) return false;
  return false;
}

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
      emailOtpController: TextEditingController(),
      phoneOtpController: TextEditingController(),
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

    initialState.nameController.addListener(() {
      state = state.updateWith(nameController: initialState.nameController);
    });
    initialState.emailController.addListener(() {
      state = state.updateWith(emailController: initialState.emailController);
    });
    initialState.phoneController.addListener(() {
      state = state.updateWith(phoneController: initialState.phoneController);
    });

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

  Future<void> sendOtp(bool isEmail) async {
    final userId = ref.read(hiveServiceProvider.notifier).getUserId()!;
    // Determine which controller/text and which state‐flags to update
    final contactValue =
        isEmail
            ? state.emailController.text
            : '+91${state.phoneController.text}';
    // 1) set loading = true for either email or phone
    state =
        isEmail
            ? state.updateWith(isEmailLoading: true)
            : state.updateWith(isPhoneLoading: true);

    // 2) call the correct userVerify(...) method
    final res =
        isEmail
            ? await _service.userVerify(userId, email: contactValue)
            : await _service.userVerify(userId, phone: contactValue);

    // 3) show snackbar for success/failure
    AppConstants.showSnackbar(
      message: res.data["message"],
      isSuccess: res.statusCode == 200,
    );

    // 4) if successful, unfocus and flip the “OTP sent” flag
    if (res.statusCode == 200) {
      FocusManager.instance.primaryFocus?.unfocus();
      if (isEmail) {
        state.isEmailOtpSent = true;
      } else {
        state.isPhoneOtpSent = true;
      }
    }

    // 5) set loading = false for whichever field we set to true earlier
    state =
        isEmail
            ? state.updateWith(isEmailLoading: false)
            : state.updateWith(isPhoneLoading: false);

    // 6) push the final state object back
    state = state.update(state);
  }

  Future<void> verifyOtp(bool isEmail, String otp) async {
    final userId = ref.read(hiveServiceProvider.notifier).getUserId()!;
    // Determine the same “contact string” logic
    final contactValue =
        isEmail
            ? state.emailController.text
            : '+91${state.phoneController.text}';
    // 1) set loading = true
    state =
        isEmail
            ? state.updateWith(isEmailLoading: true)
            : state.updateWith(isPhoneLoading: true);

    // 2) call the correct userVerifyOtp(...) method
    final res =
        isEmail
            ? await _service.userVerifyOtp(
              userId,
              otp: otp,
              email: contactValue,
            )
            : await _service.userVerifyOtp(
              userId,
              otp: otp,
              phone: contactValue,
            );

    // 3) show snackbar
    AppConstants.showSnackbar(
      message: res.data["message"],
      isSuccess: res.statusCode == 200,
    );

    // 4) if successful, flip the “verified” flag
    if (res.statusCode == 200) {
      if (isEmail) {
        _hiveService.updateUserInfo(email: state.emailController.text);
        state.initialUserInfo = state.initialUserInfo!.copyWith(
          email: contactValue,
        );
        state.isEmailVerified = true;
      } else {
        _hiveService.updateUserInfo(mobileNumber: state.phoneController.text);
        state.initialUserInfo = state.initialUserInfo!.copyWith(
          mobileNumber: contactValue,
        );
        state.isPhoneVerified = true;
      }
    }

    // 5) set loading = false
    state =
        isEmail
            ? state.updateWith(isEmailLoading: false)
            : state.updateWith(isPhoneLoading: false);

    // 6) push the final state
    state = state.update(state);
  }
}

class ProfileSettingsState {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController emailOtpController;
  final TextEditingController phoneOtpController;
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

  // Email booleans
  bool isEmailOtpSent, isEmailVerified, isEmailLoading;
  // Phone booleans
  bool isPhoneOtpSent, isPhoneVerified, isPhoneLoading;

  ProfileSettingsState({
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.emailOtpController,
    required this.phoneOtpController,
    this.dob,
    this.gender,
    this.country,
    this.countryId,
    this.city,
    this.isLoading = false,
    this.isEmailOtpSent = false,
    this.isEmailVerified = false,
    this.isEmailLoading = false,
    this.isPhoneOtpSent = false,
    this.isPhoneVerified = false,
    this.isPhoneLoading = false,
    this.error,
    this.imageUrl,
    this.initialUserInfo,
  });

  ProfileSettingsState updateWith({
    TextEditingController? nameController,
    TextEditingController? emailController,
    TextEditingController? phoneController,
    TextEditingController? emailOtpController,
    TextEditingController? phoneOtpController,
    DateTime? dob,
    String? gender,
    String? country,
    String? city,
    bool? isLoading,
    bool? isEmailOtpSent,
    bool? isEmailVerified,
    bool? isEmailLoading,
    bool? isPhoneOtpSent,
    bool? isPhoneVerified,
    bool? isPhoneLoading,
    String? error,
    String? imageUrl,
    User? initialUserInfo,
  }) {
    return ProfileSettingsState(
      nameController: nameController ?? this.nameController,
      emailController: emailController ?? this.emailController,
      phoneController: phoneController ?? this.phoneController,
      emailOtpController: emailOtpController ?? this.emailOtpController,
      phoneOtpController: phoneOtpController ?? this.phoneOtpController,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      city: city ?? this.city,
      isLoading: isLoading ?? this.isLoading,
      isEmailOtpSent: isEmailOtpSent ?? this.isEmailOtpSent,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isEmailLoading: isEmailLoading ?? this.isEmailLoading,
      isPhoneOtpSent: isPhoneOtpSent ?? this.isPhoneOtpSent,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isPhoneLoading: isPhoneLoading ?? this.isPhoneLoading,
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
      emailOtpController: state.emailOtpController,
      phoneOtpController: state.phoneOtpController,
      dob: state.dob,
      gender: state.gender,
      country: state.country,
      countryId: state.countryId,
      city: state.city,
      isLoading: state.isLoading,
      isEmailOtpSent: state.isEmailOtpSent,
      isEmailVerified: state.isEmailVerified,
      isEmailLoading: state.isEmailLoading,
      isPhoneOtpSent: state.isPhoneOtpSent,
      isPhoneVerified: state.isPhoneVerified,
      isPhoneLoading: state.isPhoneLoading,
      error: state.error,
      imageUrl: state.imageUrl,
      initialUserInfo: state.initialUserInfo,
    );
  }
}
