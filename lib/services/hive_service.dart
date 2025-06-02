import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:guftagu_mobile/configs/hive_contants.dart';
import 'package:guftagu_mobile/models/user_model.dart';
import 'package:guftagu_mobile/services/api_client.dart';

part '../gen/services/hive_service.gen.dart';

@Riverpod(keepAlive: true)
class HiveService extends _$HiveService {
  // Box getters for easy access
  Box get _authBox => Hive.box(AppHSC.authBox);
  Box get _userBox => Hive.box(AppHSC.userBox);
  Box get _appSettingsBox => Hive.box(AppHSC.appSettingsBox);

  @override
  void build() {
    // Initialization logic if needed
  }

  // Auth Token Operations
  Future<void> saveUserAuthToken({
    required String accessToken,
    String? refreshToken,
  }) async {
    _authBox.put(AppHSC.accessToken, accessToken);
    ref.read(apiClientProvider).updateToken(accessToken);
    if (refreshToken != null) {
      _authBox.put(AppHSC.refreshToken, refreshToken);
    }
  }

  Future<void> removeUserAuthToken() async {
    await _authBox.delete(AppHSC.accessToken);
    await _authBox.delete(AppHSC.refreshToken);
  }

  String? getAuthToken() {
    return _authBox.get(AppHSC.accessToken);
  }

  // User Data Operations
  Future<void> saveUserInfo({required User userInfo}) async {
    await _userBox.put(AppHSC.userInfo, userInfo.toMap());
  }

  User? getUserInfo() {
    Map<dynamic, dynamic>? userInfo = _userBox.get(AppHSC.userInfo);
    if (userInfo != null) {
      return User.fromMap(userInfo.cast<String, dynamic>());
    }
    return null;
  }

  void updateUserInfo({
    // complete user object
    User? user,

    // indivisual values
    String? username,
    String? email,
    String? mobileNumber,
    int? status,
    String? fullName,
    String? dateOfBirth,
    String? gender,
    String? profilePicture,
    String? bio,
    String? country,
    String? city,
    String? timezone,
    List<String>? characterTypeIds,
  }) {
    // Get current user info
    User? currentUser = user ?? getUserInfo();

    if (currentUser != null) {
      // Create updated profile
      Profile updatedProfile = Profile(
        fullName: fullName ?? currentUser.profile.fullName,
        dateOfBirth: dateOfBirth ?? currentUser.profile.dateOfBirth,
        gender: gender ?? currentUser.profile.gender,
        profilePicture: profilePicture ?? currentUser.profile.profilePicture,
        bio: bio ?? currentUser.profile.bio,
        country: country ?? currentUser.profile.country,
        city: city ?? currentUser.profile.city,
        timezone: timezone ?? currentUser.profile.timezone,
      );

      // Create updated user
      User updatedUser = User(
        id: currentUser.id,
        username: username ?? currentUser.username,
        email: email ?? currentUser.email,
        mobileNumber: mobileNumber ?? currentUser.mobileNumber,
        createdDate: currentUser.createdDate,
        updatedDate: DateTime.now(), // Update the updatedDate to current time
        status: status ?? currentUser.status,
        profile: updatedProfile,
        characterTypeIds: characterTypeIds ?? currentUser.characterTypeIds,
      );

      // Save the updated user info back to the box
      _userBox.put(AppHSC.userInfo, updatedUser.toMap());
    }
  }

  String? getUserId() {
    return getUserInfo()?.id;
  }

  Future<void> removeUserData() async {
    await _userBox.clear();
  }

  // App Settings Operations
  Future<void> setOnboardingValue({required bool value}) async {
    await _appSettingsBox.put(AppHSC.onBoarded, value);
  }

  Future<void> setDarkTheme({required bool value}) async {
    await _appSettingsBox.put(AppHSC.isDarkTheme, value);
  }

  bool getTheme() {
    return _appSettingsBox.get(AppHSC.isDarkTheme, defaultValue: false);
  }

  bool getOnboardingStatus() {
    return _appSettingsBox.get(AppHSC.onBoarded, defaultValue: false);
  }

  bool getHasStartedChat() {
    return _appSettingsBox.get(AppHSC.hasStartedChat, defaultValue: false);
  }

  Future<void> setHasStartedChat({required bool value}) async {
    await _appSettingsBox.put(AppHSC.hasStartedChat, value);
  }

  // Combined Operations
  Future<List<dynamic>> loadTokenAndUser() async {
    return [getOnboardingStatus(), getAuthToken(), getUserInfo()];
  }

  Future<bool> removeAllData() async {
    try {
      await removeUserAuthToken();
      await removeUserData();
      ref.read(apiClientProvider).updateTokenDefault();
      return true;
    } catch (e) {
      return false;
    }
  }

  // JSON conversion helpers (optional)
  static User userFromMap(String str) => User.fromMap(json.decode(str));
  static String userToMap(User data) => json.encode(data.toMap());
}
