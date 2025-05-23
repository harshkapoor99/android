import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/services/profile_settings_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../services/hive_service.dart';

// part '../gen/providers/profile_settings_provider.gen.dart';

final profileSettingsProvider =
StateNotifierProvider.autoDispose<ProfileSettingsNotifier, ProfileSettingsState>(
      (ref) {
    final service = ref.watch(profileServiceProvider);
    return ProfileSettingsNotifier(ref,service);
  },
);

class ProfileSettingsState {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final DateTime? dob;
  final String? gender;
  final String? countryId;
  final String? cityId;
  final bool isLoading;
  final String? error;

  ProfileSettingsState({
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    this.dob,
    this.gender,
    this.countryId,
    this.cityId,
    this.isLoading = false,
    this.error,
  });

  ProfileSettingsState copyWith({
    TextEditingController? nameController,
    TextEditingController? emailController,
    TextEditingController? phoneController,
    DateTime? dob,
    String? gender,
    String? countryId,
    String? cityId,
    bool? isLoading,
    String? error,
  }) {
    return ProfileSettingsState(
      nameController: nameController ?? this.nameController,
      emailController: emailController ?? this.emailController,
      phoneController: phoneController ?? this.phoneController,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      countryId: countryId ?? this.countryId,
      cityId: cityId ?? this.cityId,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ProfileSettingsNotifier extends StateNotifier<ProfileSettingsState> {
  final Ref ref;
  final ProfileService _service;

  ProfileSettingsNotifier(this.ref, this._service)
      : super(
    ProfileSettingsState(
      nameController: TextEditingController(),
      emailController: TextEditingController(),
      phoneController: TextEditingController(),
    ),
  );

  void setDob(DateTime dob) => state = state.copyWith(dob: dob);
  void setGender(String gender) => state = state.copyWith(gender: gender);
  void setCountry(String countryId) => state = state.copyWith(countryId: countryId);
  void setCity(String cityId) => state = state.copyWith(cityId: cityId);

  Future<bool> updateProfile() async {
    try {
      state = state.copyWith(isLoading: true);

      final hiveService = ref.read(hiveServiceProvider.notifier);
      final userId = hiveService.getUserId();
      final formattedDob = DateFormat('yyyy-MM-dd').format(state.dob!);

      // await _service.updateProfile(
      //   userId: userId,
      //   name: state.nameController.text.trim(),
      //   gender: state.gender ?? '',
      //   dateOfBirth: formattedDob,
      //   email: state.emailController.text.trim(),
      //   phone: state.phoneController.text.trim(),
      //   countryId: state.countryId,
      //   cityId: state.cityId,
      // );

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> uploadProfileImage(XFile image) async {
    try {
      state = state.copyWith(isLoading: true);
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