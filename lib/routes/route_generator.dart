import 'package:flutter/cupertino.dart';
import 'package:hancode_task/features/account/view/my_account_view.dart';
import 'package:hancode_task/features/auth/login/view/login_screen.dart';
import 'package:hancode_task/features/auth/login/widgets/number_typing_screen.dart';
import 'package:hancode_task/features/auth/login/widgets/otp_screen.dart';
import 'package:hancode_task/features/bottom_nav/view/bottom_nav_view.dart';
import 'package:hancode_task/features/cart/view/cart_view_screen.dart';
import 'package:hancode_task/features/cleaning_services/view/cleaning_service_view.dart';
import 'package:hancode_task/features/home/view/home_screen.dart';
import 'package:hancode_task/features/splash_screen/view/splash_screen.dart';
import 'package:hancode_task/routes/route_constants.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.splash:
        return _buildRoute(RouteConstants.splash, const SplashScreen());
      case RouteConstants.home:
        return _buildRoute(RouteConstants.home, const HomeScreen());
      case RouteConstants.login:
        return _buildRoute(RouteConstants.login, const LoginScreen());
      case RouteConstants.loginNumber:
        return _buildRoute(
          RouteConstants.loginNumber,
          const PhoneNumberScreen(),
        );
      case RouteConstants.otpScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final verificationId = args["verificationId"];
        final phoneNumber = args["phoneNumber"];
        return _buildRoute(
          RouteConstants.otpScreen,
          OtpScreen(verificationId: verificationId, phoneNumber: phoneNumber),
        );
      case RouteConstants.bottomNav:
        return _buildRoute(RouteConstants.bottomNav, const BottomNavScreen());
      case RouteConstants.cart:
        return _buildRoute(RouteConstants.cart, const CartViewScreen());
      case RouteConstants.myAccount:
        return _buildRoute(RouteConstants.myAccount, const MyAccountView());
      case RouteConstants.cleaningService:
        return _buildRoute(
          RouteConstants.cleaningService,
          const CleaningServicesScreen(),
        );

      default:
        return _buildRoute(RouteConstants.splash, const SplashScreen());
    }
  }

  static Route<dynamic> _buildRoute(String route, Widget widget) {
    return CupertinoPageRoute(
      settings: RouteSettings(name: route),
      builder: (_) => widget,
    );
  }
}
