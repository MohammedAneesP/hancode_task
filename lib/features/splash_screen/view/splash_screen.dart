import 'package:flutter/material.dart';
import 'package:hancode_task/routes/route_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    goto();
  }

  void goto() async {
    await Future.delayed(const Duration(seconds: 2)).then(
      (value) => Navigator.pushReplacementNamed(context, RouteConstants.login),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage("assets/images/app_image.png"),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
