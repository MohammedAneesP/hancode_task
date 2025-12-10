import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:hancode_task/features/auth/state/auth_state.dart';
import '../repo/auth_repository.dart';
import '../providers/auth_providers.dart';

final otpControllerFamilyProvider =
    StateNotifierProvider.family<OtpController, OtpState, String>((
      ref,
      phoneNumber,
    ) {
      final repo = ref.read(authRepositoryProvider);
      return OtpController(repo, phoneNumber);
    });

class OtpController extends StateNotifier<OtpState> {
  final AuthRepository _repo;
  final String phoneNumber;
  Timer? _timer;
  OtpController(this._repo, this.phoneNumber) : super(OtpState.initial());

  /// ✅ Call this once when screen opens
  void setInitialVerificationId(String verificationId) {
    if (state.verificationId.isEmpty) {
      state = state.copyWith(verificationId: verificationId);
    }
  }

  Future<void> verifyOtp(String otp) async {
    state = state.copyWith(isLoading: true);

    try {
      await _repo.verifyOtp(verificationId: state.verificationId, otp: otp);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// ✅ RESEND OTP (creates NEW verificationId safely)
  Future<void> resendOtp() async {
    _timer?.cancel();

    await _repo.sendOtp(
      phoneNumber: phoneNumber,
      onCodeSent: (newVerificationId) {
        state = state.copyWith(
          verificationId: newVerificationId,
          resendSeconds: 60,
        );
        _startTimer();
      },
      onError: (error) {
        throw Exception(error);
      },
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendSeconds == 0) {
        timer.cancel();
      } else {
        state = state.copyWith(resendSeconds: state.resendSeconds - 1);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
