import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '👋',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Text(
                    '406, Skyline Park Dale, MM Road...',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  SizedBox(width: 10.w),
                  const Icon(
                    Icons.keyboard_arrow_down_sharp,
                    size: 16,
                    color: Colors.green,
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Stack(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: SvgPicture.asset('assets/svg/Buy.svg', height: 22),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.red,
                  child: const Text(
                    '2',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
