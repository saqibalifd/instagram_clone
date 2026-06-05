import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram/animations/floating_animation.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/features/auth/controllers/auth_controller.dart';
import 'package:instagram/services/notification_service.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final AuthController _authController = Get.put(AuthController());
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    _authController.sessionManager();
    notificationServices.requestNotificationPermission();
    notificationServices.getDeviceToken();
    notificationServices.firebaseInit(context);
    notificationServices.setupIntractMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: IGColors.bgLight,
      body: Center(
        child: FloatingAnimation(
          child: Image.asset('assets/icons/instaCloneAppLogo.png', height: 100),
        ),
      ),
    );
  }
}
