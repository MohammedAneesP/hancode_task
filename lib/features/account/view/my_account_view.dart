import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hancode_task/features/auth/controller/auth_controller.dart';
import 'package:hancode_task/routes/route_constants.dart';

class MyAccountView extends ConsumerWidget {
  const MyAccountView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              /// Title
              Text(
                "My Account",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
              ),

              SizedBox(height: 24.h),

              /// PROFILE ROW
              Row(
                children: [
                  /// Initials avatar
                  Container(
                    height: 55.h,
                    width: 55.h,
                    decoration: BoxDecoration(
                      color: const Color(0xff2DBE62),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Text(
                        "FE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 14.w),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Fathima Ebrahim",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "+91 908 786 4233",
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              /// WALLET
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  color: const Color(0xffE5F8EB),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Wallet",
                      style: TextStyle(
                        color: const Color(0xff2DBE62),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 6.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        "Balance - 125",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              /// MENU LIST
              _menuTile(Icons.person_outline, "Edit Profile"),
              _menuTile(Icons.location_on_outlined, "Saved Address"),
              _menuTile(Icons.description_outlined, "Terms & Conditions"),
              _menuTile(Icons.privacy_tip_outlined, "Privacy Policy"),
              _menuTile(Icons.group_outlined, "Refer a friend"),
              _menuTile(Icons.call_outlined, "Customer Support"),
              GestureDetector(
                onTap: () => _showLogoutDialog(context, ref),
                child: _menuTile(Icons.logout, "Log Out"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuTile(IconData icon, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.grey.shade700),
            SizedBox(width: 14.w),
            Text(
              title,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

void _showLogoutDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text("Log out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context); // close dialog first

              await ref.read(authControllerProvider).signOut(ref);

              if (context.mounted) {
                // ✅ Go back to AuthGate / Login
                Navigator.pushNamedAndRemoveUntil(
                  context,
                RouteConstants.login, // or AuthGate route
                  (route) => false,
                );
              }
            },
            child: const Text("Log Out", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
