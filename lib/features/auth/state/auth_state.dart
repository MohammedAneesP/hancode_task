class OtpState {
  final bool isLoading;
  final String verificationId;
  final int resendSeconds;

  const OtpState({
    required this.isLoading,
    required this.verificationId,
    required this.resendSeconds,
  });

  factory OtpState.initial() => const OtpState(
        isLoading: false,
        verificationId: '', // start empty
        resendSeconds: 0,
      );

  OtpState copyWith({
    bool? isLoading,
    String? verificationId,
    int? resendSeconds,
  }) {
    return OtpState(
      isLoading: isLoading ?? this.isLoading,
      verificationId: verificationId ?? this.verificationId,
      resendSeconds: resendSeconds ?? this.resendSeconds,
    );
  }
}
