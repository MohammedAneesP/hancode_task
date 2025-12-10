import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hancode_task/routes/route_constants.dart';
import 'package:svg_flutter/svg.dart';

class ServiceGrid extends StatelessWidget {
  const ServiceGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      ('Cleaning', 'assets/svg/cleaning 1.svg'),
      ('Waste Disposal', 'assets/svg/recycle_bin.svg'),
      ('Plumbing', 'assets/svg/plumbing 1.svg'),
      ('Plumbing', 'assets/svg/plumbing 1.svg'),
      ('Cleaning', 'assets/svg/cleaning 1.svg'),
      ('Waste Disposal', 'assets/svg/recycle_bin.svg'),
      ('Plumbing', 'assets/svg/plumbing 1.svg'),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: const Text(
                'Available Services',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),

            // SizedBox(height: 16.h),
            GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 15.h),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 15,

                // crossAxisSpacing: 5,
              ),
              itemCount: services.length + 1,
              itemBuilder: (_, index) {
                /// ✅ LAST ITEM — SEE ALL BUTTON
                if (index == services.length) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RouteConstants.cleaningService,
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.green, width: 1.5),
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        const Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                /// ✅ NORMAL SERVICE ITEM
                final item = services[index];
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Theme.of(context).canvasColor,
                      child: SvgPicture.asset(item.$2, height: 26),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      item.$1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
