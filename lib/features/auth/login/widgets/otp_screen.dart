import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hancode_task/features/auth/controller/otp_controller.dart';
import 'package:hancode_task/routes/route_constants.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OtpScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      ref
          .read(otpControllerFamilyProvider(widget.phoneNumber).notifier)
          .setInitialVerificationId(widget.verificationId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(otpControllerFamilyProvider(widget.phoneNumber));

    final controller = ref.read(
      otpControllerFamilyProvider(widget.phoneNumber).notifier,
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              /// Title
              const Text(
                'Verify OTP',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              /// Subtitle
              const Text(
                'Enter the 6-digit code sent to your phone',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),

              const SizedBox(height: 40),

              /// OTP input
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                style: const TextStyle(
                  fontSize: 22,
                  letterSpacing: 8,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: '------',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// Verify button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: state.isLoading
                      ? null
                      : () async {
                          final otp = otpController.text.trim();
                          if (otp.length != 6) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Enter a valid 6-digit OTP'),
                              ),
                            );
                            return;
                          }
                          try {
                            await controller.verifyOtp(
                              otpController.text.trim(),
                            );
                            Navigator.pushNamed(
                              context,
                              RouteConstants.bottomNav,
                            );
                            // ✅ AuthGate will move user
                          } catch (e) {
                            log(e.toString());
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                  child: state.isLoading
                      ? const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        )
                      : const Text('Verify', style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 20),

              /// Resend text (UI only for now)
              Center(
                child: TextButton(
                  onPressed: state.resendSeconds > 0
                      ? null
                      : () async {
                          try {
                            await controller.resendOtp();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                  child: Text(
                    state.resendSeconds > 0
                        ? 'Resend in ${state.resendSeconds}s'
                        : 'Resend OTP',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
