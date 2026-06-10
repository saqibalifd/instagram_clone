// ============================================================
//  WHAT GOES HERE
//  Master list of GetPage definitions.
//  Wires: route name → View + Binding + optional Middleware.
//  This file is imported ONLY by main.dart / GetMaterialApp.
//  Never import GetPage definitions from feature folders.
// ============================================================

import 'package:get/get.dart';
import 'package:instagram/features/auth/views/forgot_password_view.dart';
import 'package:instagram/features/auth/views/otp_view.dart';
import 'package:instagram/features/auth/views/phone_auth_view.dart';
import 'package:instagram/features/auth/views/splash_view.dart';
import 'package:instagram/features/bottom_navbar/custom_bottom_navbar.dart';
import 'package:instagram/features/dm/view/chat_view.dart';
import 'package:instagram/features/home/views/add_post_view.dart';
import 'package:instagram/features/home/views/notification_view.dart';
import 'package:instagram/features/home/views/public_profile_view.dart';
import 'package:instagram/features/profile/views/edit_profile_view.dart';
import 'package:instagram/features/profile/views/share_profile_view.dart';
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
      page: () => const ForgotPasswordView(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.bottomNavbar,
      page: () => CustomBottomNavbar(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.phoneAuth,
      page: () => const PhoneAuthView(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.otp,
      page: () => const OtpView(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.notification,
      page: () => const NotificationView(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileView(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.shareProfile,
      page: () => const ShareProfileView(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.addPost,
      page: () => const AddPostView(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.publicProfile,
      page: () => const PublicProfileView(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatView(),
      // binding: AuthBinding(),
    ),
  ];
}
