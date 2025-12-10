import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hancode_task/features/bottom_nav/providers/bottom_providers.dart';
import 'package:hancode_task/features/cart/provider/cart_provider.dart';
import '../repo/auth_repository.dart';
import '../providers/auth_providers.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return AuthController(repo);
});

class AuthController {
  final AuthRepository _repo;

  AuthController(this._repo);

  // ✅ GOOGLE AUTH
  Future<void> signInWithGoogle() async {
    await _repo.signInWithGoogle();
  }

  Future<void> signOut(WidgetRef ref) async {
    await _repo.signOut();
    // ✅ RESET UI STATE
    ref.invalidate(bottomNavIndexProvider);
    ref.invalidate(cartProvider); // optional but recommended
  }

  // ✅ PHONE AUTH – STEP 1: SEND OTP
  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    await _repo.sendOtp(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onError: onError,
    );
  }

  // ✅ PHONE AUTH – STEP 2: VERIFY OTP
  Future<void> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    await _repo.verifyOtp(verificationId: verificationId, otp: otp);
  }
}
