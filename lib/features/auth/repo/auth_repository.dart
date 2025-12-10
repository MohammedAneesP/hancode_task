import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  AuthRepository() {
    _googleSignIn.initialize(
      serverClientId:
          '80437002958-gaa074a27486g4g060ltiuhaog3vi4hp.apps.googleusercontent.com',
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    if (!_googleSignIn.supportsAuthenticate()) {
      throw Exception('Google Sign-In not supported');
    }

    final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();

    if (googleUser == null) {
      throw Exception('Google sign-in cancelled');
    }

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),

      verificationCompleted: (PhoneAuthCredential credential) async {
        // ✅ Auto-verification (rare, mostly Android)
        // await _auth.signInWithCredential(credential);
      },

      verificationFailed: (FirebaseAuthException e) {
        onError(e.message ?? 'Verification failed');
      },

      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },

      codeAutoRetrievalTimeout: (String verificationId) {
        // optional
      },
    );
  }

  /// STEP 2: Verify OTP
  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      // 👇 Map Firebase error codes to readable messages
      if (e.code == 'invalid-verification-code') {
        throw Exception('The OTP you entered is invalid.');
      } else if (e.code == 'session-expired') {
        throw Exception('OTP expired. Please request a new one.');
      } else if (e.code == 'invalid-verification-id') {
        throw Exception('Verification failed. Please try again.');
      } else {
        throw Exception(e.message ?? 'OTP verification failed');
      }
    } catch (e) {
      // Fallback for anything unexpected
      throw Exception('Something went wrong during OTP verification.');
    }
  }
}
