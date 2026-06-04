// ============================================================
//  WHAT GOES HERE
//  Master list of GetPage definitions.
//  Wires: route name → View + Binding + optional Middleware.
//  This file is imported ONLY by main.dart / GetMaterialApp.
//  Never import GetPage definitions from feature folders.
// ============================================================

import 'package:get/get.dart';
import 'package:instagram/features/auth/views/forgot_password_screen.dart';
import 'package:instagram/features/auth/views/otp_screen.dart';
import 'package:instagram/features/auth/views/phone_auth_screen.dart';
import 'package:instagram/features/auth/views/splash_view.dart';
import 'package:instagram/features/bottom_navbar/custom_bottom_navbar.dart';
import '../features/auth/views/login_view.dart';
import '../features/auth/views/register_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.bottomNavbar,
      page: () => CustomBottomNavbar(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.phoneAuth,
      page: () => const PhoneAuthScreen(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.otp,
      page: () => const OtpScreen(),
      // binding: AuthBinding(),
    ),
  ];
}
