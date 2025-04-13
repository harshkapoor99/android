import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/services/api_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:guftagu_mobile/configs/endpoint.dart';

part '../gen/services/auth_service.gen.dart';

@riverpod
AuthService authService(Ref ref) {
  final apiClient = ref.read(apiClientProvider);
  return AuthService(apiClient);
}

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  Future<Response> loginWithNumber(String phoneNumber) async {
    try {
      final response = await _apiClient.post(
        RemoteEndpoint.loginPhone.url,
        data: {'mobile_number': phoneNumber},
        headers: _apiClient.authHeader,
      );
      return response;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<Response> verifyNumberOtp(String phoneNumber, String otp) async {
    try {
      final response = await _apiClient.post(
        RemoteEndpoint.otpPhone.url,
        data: {'phone_number': phoneNumber, 'otp': otp},
        headers: _apiClient.authHeader,
      );
      return response;
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }

  Future<Response> loginWithEmail(String email) async {
    try {
      final response = await _apiClient.post(
        RemoteEndpoint.loginEmail.url,
        data: {'email': email},
        headers: _apiClient.authHeader,
      );
      return response;
    } catch (e) {
      throw Exception('Failed to login with email: $e');
    }
  }

  Future<Response> verifyEmailOtp(String email, String otp) async {
    try {
      final response = await _apiClient.post(
        RemoteEndpoint.otpEmail.url,
        data: {'email': email, 'otp': otp},
        headers: _apiClient.authHeader,
      );
      return response;
    } catch (e) {
      throw Exception('Failed to verify email OTP: $e');
    }
  }
}
