import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:guftagu_mobile/configs/app_text_style.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class GoogleAuthButton extends StatelessWidget {
  const GoogleAuthButton({super.key, this.isLogin = false});
  final bool isLogin;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void _handleGoogleSignIn(BuildContext context) async {
    try {
      final userCredential = await signInWithGoogle();
      final user = userCredential.user;
      if (user != null) {
        // Optionally show a success snackbar or navigate
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome, ${user.displayName ?? 'User'}!')),
        );

        // TODO: Navigate to home screen or dashboard
        // context.pushReplacementNamed('/home');
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _handleGoogleSignIn(context),
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
              SvgPicture.asset("assets/svgs/ic_google.svg", height: 40),
              const SizedBox(width: 12),
              Text(
                '${isLogin ? "Log in" : "Sign up"} with Google',
                style: AppTextStyle(context).textSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
