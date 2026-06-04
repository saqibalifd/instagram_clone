import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram/animations/floating_animation.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/features/auth/controllers/auth_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final AuthController _authController = Get.put(AuthController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authController.sessionManager();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: IGColors.splashBg,
      body: Center(
        child: FloatingAnimation(
          child: Image.asset('assets/icons/instaCloneAppLogo.png', height: 100),
        ),
      ),
    );
  }
}
