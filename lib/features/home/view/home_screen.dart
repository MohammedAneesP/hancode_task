import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hancode_task/features/home/widgets/banner.dart';
import 'package:hancode_task/features/home/widgets/cleaning_service_section.dart';
import 'package:hancode_task/features/home/widgets/home_header.dart';
import 'package:hancode_task/features/home/widgets/search_bar.dart';
import 'package:hancode_task/features/home/widgets/services_grid.dart';
import 'package:svg_flutter/svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 120.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),
              SizedBox(height: 16.h),
              const PromoBanner(),
              SizedBox(height: 20.h),
              const SearchBarSection(),
              SizedBox(height: 24.h),
              const ServiceGrid(),
              SizedBox(height: 28.h),
              const CleaningServicesSection(),
            ],
          ),
        ),
      ),
    );
  }
}
