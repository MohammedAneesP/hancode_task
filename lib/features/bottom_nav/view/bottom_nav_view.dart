import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hancode_task/features/account/view/my_account_view.dart';
import 'package:hancode_task/features/bottom_nav/providers/bottom_providers.dart';
import 'package:hancode_task/features/cart/view/cart_view_screen.dart';
import 'package:hancode_task/features/home/view/home_screen.dart';

class BottomNavScreen extends ConsumerWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(bottomNavIndexProvider);

    final pages = const [HomeScreen(), CartViewScreen(), MyAccountView()];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ✅ Main page content
          pages[index],

          // ✅ Floating bottom nav
          const Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: FloatingBottomNav(),
          ),
        ],
      ),
    );
  }
}

class FloatingBottomNav extends ConsumerWidget {
  const FloatingBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(bottomNavIndexProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          _NavItem(
            label: 'Home',
            icon: Icons.home_filled,
            selected: index == 0,
            onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 0,
          ),
          _NavItem(
            label: 'Cart',
            icon: Icons.calendar_today,
            selected: index == 1,
            onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 1,
          ),
          _NavItem(
            label: 'Account',
            icon: Icons.person,
            selected: index == 2,
            onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 2,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 50),
          padding: EdgeInsets.symmetric(vertical: 10.sp),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFE9F8EF) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20.sp,
                color: selected ? Colors.green : Colors.grey,
              ),
              SizedBox(width: 10.w),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.green : Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
