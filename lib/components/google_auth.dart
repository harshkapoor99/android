import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/configs/app_text_style.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/models/user_model.dart';
import 'package:guftagu_mobile/services/hive_service.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';

import '../configs/endpoint.dart';
import '../routes.dart';

class GoogleAuthButton extends ConsumerStatefulWidget {
  const GoogleAuthButton({super.key, this.isLogin = false});
  final bool isLogin;

  @override
  ConsumerState<GoogleAuthButton> createState() => _GoogleAuthButtonState();
}

class _GoogleAuthButtonState extends ConsumerState<GoogleAuthButton> {
  bool _isLoading = false;

  void _handleGoogleSignIn(BuildContext context) async {
    setState(() => _isLoading = true);

    try {
      // Google Sign-In
      debugPrint('Starting Google Sign-In process...');
      final userCredential = await _signInWithGoogle();
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Firebase user is null after successful sign-in');
      }

      debugPrint('Google Sign-In successful: ${firebaseUser.email}');

      // Get ID Token
      debugPrint('Getting Firebase ID token...');
      final idToken = await firebaseUser.getIdToken();

      if (idToken == null || idToken.isEmpty) {
        throw Exception('Failed to retrieve ID token from Firebase');
      }

      debugPrint('ID Token retrieved successfully');

      // Backend Authentication
      debugPrint('Authenticating with backend...');
      final backendResponse = await _authenticateWithBackend(idToken);

      debugPrint('Backend response: ${backendResponse.toString()}');

      if (backendResponse['status'] == 200 || backendResponse['success'] == true) {
        // Parse and Save User Data
        debugPrint('Parsing user data and saving tokens...');

        if (backendResponse['user_info'] == null) {
          throw Exception('user_info is missing from backend response');
        }

        final user = User.fromMap(backendResponse['user_info']);
        final accessToken = backendResponse['access'];
        final refreshToken = backendResponse['refresh'];

        if (accessToken == null || refreshToken == null) {
          throw Exception('Access token or refresh token missing from response');
        }

        // Save to Hive storage
        final hiveService = ref.read(hiveServiceProvider.notifier);
        await hiveService.saveUserInfo(userInfo: user);
        await hiveService.saveUserAuthToken(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );

        debugPrint('User data saved successfully');

        AppConstants.showSnackbar(
          message: 'Welcome, ${user.profile.fullName ?? firebaseUser.displayName ?? 'User'}!',
          isSuccess: true,
        );

        // Navigate to dashboard
        if (context.mounted) {
          context.nav.pushReplacementNamed(Routes.dashboard);
        }
      } else {
        throw Exception(backendResponse['message'] ?? 'Backend authentication failed');
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error: ${e.code} - ${e.message}');
      String errorMessage = _getFirebaseErrorMessage(e.code);

      if (context.mounted) {
        AppConstants.showSnackbar(
          message: errorMessage,
          isSuccess: false,
        );
      }
    } on DioException catch (e) {
      debugPrint('Network Error: ${e.type} - ${e.message}');
      String errorMessage = _getDioErrorMessage(e);

      if (context.mounted) {
        AppConstants.showSnackbar(
          message: errorMessage,
          isSuccess: false,
        );
      }
    } catch (e) {
      debugPrint('General Error: $e');
      if (context.mounted) {
        String errorMessage = _getGeneralErrorMessage(e.toString());

        AppConstants.showSnackbar(
          message: errorMessage,
          isSuccess: false,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return 'Account exists with different credentials. Try signing in with your original method.';
      case 'invalid-credential':
        return 'Invalid credentials. Please try again.';
      case 'operation-not-allowed':
        return 'Google Sign-In is not enabled. Please contact support.';
      case 'user-disabled':
        return 'Your account has been disabled. Please contact support.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'user-token-expired':
        return 'Session expired. Please try signing in again.';
      default:
        return 'Google Sign-In failed. Please try again.';
    }
  }

  String _getDioErrorMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Request timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server response timeout. Please try again.';
      case DioExceptionType.badCertificate:
        return 'Security certificate error. Please try again.';
      case DioExceptionType.connectionError:
        return 'Connection error. Please check your internet connection.';
      case DioExceptionType.unknown:
        return 'Network error. Please try again.';
      default:
        if (e.response?.statusCode == 400) {
          return 'Invalid request. Please try again.';
        } else if (e.response?.statusCode == 401) {
          return 'Authentication failed. Please try again.';
        } else if (e.response?.statusCode == 500) {
          return 'Server error. Please try again later.';
        }
        return 'Network error. Please try again.';
    }
  }

  String _getGeneralErrorMessage(String error) {
    if (error.toLowerCase().contains('cancelled') || error.toLowerCase().contains('canceled')) {
      return 'Sign-in cancelled by user.';
    } else if (error.toLowerCase().contains('network')) {
      return 'Network error. Please check your internet connection.';
    } else if (error.toLowerCase().contains('timeout')) {
      return 'Request timeout. Please try again.';
    } else if (error.toLowerCase().contains('token')) {
      return 'Authentication token error. Please try again.';
    }
    return 'Sign-in failed. Please try again.';
  }

  Future<Map<String, dynamic>> _authenticateWithBackend(String idToken) async {
    final dio = Dio();

    // Add timeout configurations
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.sendTimeout = const Duration(seconds: 10);

    try {
      debugPrint('Sending request to: ${RemoteEndpoint.googleAuthenticationByEmail.url}');

      final response = await dio.post(
        RemoteEndpoint.googleAuthenticationByEmail.url,
        data: {'idToken': idToken},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 200) {
        return response.data is Map<String, dynamic>
            ? response.data
            : {'status': 200, 'success': true, 'data': response.data};
      } else {
        return {
          'status': response.statusCode ?? 500,
          'message': response.data?['message'] ?? 'Backend authentication failed',
          'success': false,
        };
      }
    } on DioException catch (e) {
      debugPrint('Dio Exception: ${e.type} - ${e.message}');
      debugPrint('Response: ${e.response?.data}');

      return {
        'status': e.response?.statusCode ?? 500,
        'message': e.response?.data?['message'] ?? 'Network error occurred',
        'success': false,
      };
    } catch (e) {
      debugPrint('Backend Auth Error: $e');
      return {
        'status': 500,
        'message': 'Unexpected error: $e',
        'success': false,
      };
    }
  }

  Future<firebase_auth.UserCredential> _signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        hostedDomain: null,
      );
      debugPrint('Checking Google Sign-In availability...');

      await googleSignIn.signOut();
      await firebase_auth.FirebaseAuth.instance.signOut();

      debugPrint('Starting Google Sign-In flow...');
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign-in was cancelled by user');
      }

      debugPrint('Google account selected: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.accessToken == null) {
        throw Exception('Failed to get Google access token');
      }

      if (googleAuth.idToken == null) {
        throw Exception('Failed to get Google ID token');
      }

      debugPrint('Google authentication tokens retrieved');

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      debugPrint('Signing in with Firebase...');
      final userCredential = await firebase_auth.FirebaseAuth.instance.signInWithCredential(credential);

      debugPrint('Firebase sign-in successful');
      return userCredential;

    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Exception in _signInWithGoogle: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('General Exception in _signInWithGoogle: $e');
      throw Exception('Google Sign-In setup failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: _isLoading ? null : () => _handleGoogleSignIn(context),
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: context.colorExt.border, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                SvgPicture.asset("assets/svgs/ic_google.svg", height: 40),
              const SizedBox(width: 12),
              Text(
                _isLoading
                    ? 'Signing in...'
                    : '${widget.isLogin ? "Log in" : "Sign up"} with Google',
                style: AppTextStyle(context).textSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}