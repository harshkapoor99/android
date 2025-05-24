import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/services/profile_settings_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../models/master/master_models.dart';
import '../services/hive_service.dart';
import 'master_data_provider.dart';

final profileSettingsProvider =
StateNotifierProvider.autoDispose<ProfileSettingsNotifier, ProfileSettingsState>(
      (ref) {
    final service = ref.watch(profileServiceProvider);
    return ProfileSettingsNotifier(ref, service);
  },
);

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
  ));

  void setDob(DateTime dob) => state = state.copyWith(dob: dob);

  void setGender(String gender) => state = state.copyWith(gender: gender);

  void updateCountryCityWith({Country? country, City? city}) {
    Country? updatedCountry = state.country;
    City? updatedCity = state.city;

    if (country != null && country.id != state.country?.id) {
      updatedCountry = country;
      updatedCity = null; // Reset city if country changes

      _ref.read(masterDataProvider.notifier).fetchCitiesByCountry(country: country);
    }

    if (city != null && city.id != state.city?.id) {
      updatedCity = city;
    }

    state = state.copyWith(
      country: updatedCountry,
      city: updatedCity,
    );
  }

  Future<bool> updateProfile() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final hiveService = _ref.read(hiveServiceProvider.notifier);
      final userInfo = hiveService.getUserInfo();

      if (userInfo?.id == null || userInfo!.id.isEmpty) {
        throw Exception('User ID not found. Please login again.');
      }

      if (state.dob == null) {
        throw Exception('Date of birth is required');
      }

      final formattedDob = DateFormat('yyyy-MM-dd').format(state.dob!);

      await _service.updateProfile(
        userId: userInfo.id,
        name: state.nameController.text.trim(),
        gender: state.gender ?? '',
        dateOfBirth: formattedDob,
        email: state.emailController.text.trim(),
        phone: state.phoneController.text.trim(),
        countryId: state.country?.id,
        cityId: state.city?.id,
      );

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> uploadProfileImage(XFile image) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _service.uploadProfileImage(image);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  @override
  void dispose() {
    state.nameController.dispose();
    state.emailController.dispose();
    state.phoneController.dispose();
    super.dispose();
  }
}
