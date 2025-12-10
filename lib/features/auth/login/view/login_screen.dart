import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hancode_task/features/auth/controller/auth_controller.dart';
import 'package:hancode_task/routes/route_constants.dart';
import 'package:svg_flutter/svg.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              const Spacer(flex: 2),

              /// ✅ LOGO (ASSET IMAGE)
              SizedBox(
                height: 300.h,
                child: Image.asset(
                  'assets/images/app_image.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16.h),

              /// ✅ WELCOME TEXT
              Text(
                'Welcome to Hancod',
                style: textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 6.h),

              /// ✅ SUBTITLE TEXT
              Text(
                'Book trusted services quickly and easily',
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 3),

              /// ✅ GOOGLE SIGN IN BUTTON
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      await ref.read(authControllerProvider).signInWithGoogle();

                      // ✅ navigate after success
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(
                          context,
                          RouteConstants.bottomNav,
                        );
                      }
                    } catch (e) {
                      log(e.toString());
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 5.h),
                        child: SvgPicture.asset(
                          'assets/svg/Google Icon.svg',
                          // height: 30.h,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      const Text(
                        'Continue with Google',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              /// ✅ PHONE LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RouteConstants.loginNumber);
                  },
                  child: const Text(
                    'Phone',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
