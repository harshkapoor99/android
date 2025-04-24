// ignore_for_file: unused_element

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guftagu_mobile/models/common/common_response_model.dart';
import 'package:guftagu_mobile/models/user_model.dart';
import 'package:guftagu_mobile/services/auth_service.dart';
import 'package:guftagu_mobile/services/hive_service.dart';
import 'package:guftagu_mobile/utils/validators.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/providers/auth_provider.gen.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  AuthState build() {
    final initialState = AuthState(
      nameController: TextEditingController(),
      credentialControler: TextEditingController(),
      otpControler: TextEditingController(),
      isLoading: false,
      isLoggedIn: false,
    );

    // Add listener
    initialState.credentialControler.addListener(_handleTextChange);
    initialState.otpControler.addListener(_handleOtpChange);

    // Dispose controller when provider is disposed
    ref.onDispose(() {
      initialState.credentialControler.clear();
      initialState.otpControler.clear();
    });

    return initialState;
  }

  void clearControllers() {
    state.credentialControler.clear();
    state.otpControler.clear();
  }

  void _handleTextChange() {
    state = state._updateWith(
      isEmail:
          !EmailOrPhoneValidator.isValidPhoneNumber(
            state.credentialControler.text,
          ),
    );
  }

  void _handleOtpChange() {
    state = state._updateWith(canVerify: state.otpControler.text.length == 6);
  }

  Future<CommonResponse> login() async {
    state = state._updateLoading(true);
    Response response;
    try {
      if (state.isEmail) {
        response = await ref
            .read(authServiceProvider)
            .loginWithEmail(state.credentialControler.text);
        state = state._updateLoggedIn();
      } else {
        response = await ref
            .read(authServiceProvider)
            .loginWithNumber("+91${state.credentialControler.text}");
      }
      return CommonResponse(
        message: response.data['message'],
        isSuccess: response.data['status'] == 200,
      );
    } catch (e) {
      if (kDebugMode) {
        rethrow;
      } else {
        return CommonResponse(
          message: "Something went wrong",
          isSuccess: false,
        );
      }
    } finally {
      state = state._updateLoading(false);
    }
  }

  Future<CommonResponse<User>> verifyOtp() async {
    state = state._updateLoading(true);
    Response response;
    try {
      if (state.isEmail) {
        response = await ref
            .read(authServiceProvider)
            .verifyEmailOtp(
              state.credentialControler.text,
              state.otpControler.text,
            );
        state = state._updateLoggedIn();
      } else {
        response = await ref
            .read(authServiceProvider)
            .verifyNumberOtp(
              "+91${state.credentialControler.text}",
              state.otpControler.text,
            );
        state = state._updateLoggedIn();
      }
      if (response.data['status'] != 200) {
        return CommonResponse<User>(
          message: response.data['message'],
          isSuccess: false,
        );
      }
      User user = User.fromMap(response.data['user_info']);
      String authAccessToken = response.data['access'];
      String authRefreshToken = response.data['refresh'];

      // Save user info and tokens to Hive or any other storage
      final hiver = ref.read(hiveServiceProvider.notifier);
      hiver.saveUserInfo(userInfo: user);
      hiver.saveUserAuthToken(
        accessToken: authAccessToken,
        refreshToken: authRefreshToken,
      );

      return CommonResponse<User>(
        message: response.data['message'],
        isSuccess: response.data['status'] == 200,
        response: user,
      );
    } catch (e) {
      if (kDebugMode) {
        rethrow;
      } else {
        return CommonResponse<User>(
          message: "Something went wrong",
          isSuccess: false,
        );
      }
    } finally {
      state = state._updateLoading(false);
    }
  }

  Future<CommonResponse> updateName() async {
    state = state._updateLoading(true);
    try {
      final response = await ref
          .read(authServiceProvider)
          .updateName(
            ref.read(hiveServiceProvider.notifier).getUserId()!,
            state.nameController.text,
          );
      if (response.statusCode == 200) {
        var userProfile = response.data["profile"];
        ref
            .read(hiveServiceProvider.notifier)
            .updateUserInfo(fullName: userProfile["full_name"]);
      }
      return CommonResponse(
        isSuccess: response.statusCode == 200,
        message: response.data["message"],
      );
    } catch (e) {
      return CommonResponse(isSuccess: false, message: "Some error occured");
    } finally {
      state = state._updateLoading(false);
    }
  }
}

class AuthState {
  AuthState({
    this.isEmail = true,
    this.canVerify = false,
    this.isLoggedIn = false,
    this.isLoading = false,
    required this.nameController,
    required this.credentialControler,
    required this.otpControler,
  });

  final bool isEmail, canVerify, isLoggedIn, isLoading;
  final TextEditingController nameController;
  final TextEditingController credentialControler;
  final TextEditingController otpControler;

  AuthState _updateWith({
    bool? isEmail,
    bool? canVerify,
    bool? isLoggedIn,
    bool? isLoading,
  }) {
    return AuthState(
      isEmail: isEmail ?? this.isEmail,
      canVerify: canVerify ?? this.canVerify,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      nameController: nameController,
      credentialControler: credentialControler,
      otpControler: otpControler,
    );
  }

  AuthState _updateLoading(bool value) {
    return _updateWith(isLoading: value);
  }

  AuthState _updateLoggedIn() {
    return _updateWith(isLoggedIn: true, isLoading: false);
  }
}
