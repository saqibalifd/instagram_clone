import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/core/constants/asset_paths.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/features/auth/controllers/auth_controller.dart';
import 'package:instagram/features/auth/widgets/auth_textfield_widget.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:instagram/shared_widgets/instagram_gradient_button.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final AuthController _authController = Get.put(AuthController());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ts = Theme.of(context).textTheme;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalMediumPadding,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 140.h),
              Center(child: Text(AppConstants.appName, style: ts.displayLarge)),
              SizedBox(height: 30.h),
              Center(
                child: SizedBox(
                  width: 250.w,

                  child: Text(
                    textAlign: TextAlign.center,
                    'Sign up to see photos and videos from your friends.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: IGColors.gray,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30.h),
              AuthTextfieldWidget(
                controller: emailController,
                hintText: "Email",
              ),
              SizedBox(height: 10.h),
              AuthTextfieldWidget(
                controller: nameController,
                hintText: "Full name",
              ),

              SizedBox(height: 10.h),
              AuthTextfieldWidget(
                controller: passwordController,
                hintText: "Password",
              ),

              SizedBox(height: 20.h),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                  children: [
                    const TextSpan(text: 'By signing up, you agree to our '),
                    TextSpan(
                      text: 'Terms',
                      style: const TextStyle(color: IGColors.bgDark),
                    ),
                    const TextSpan(text: ', '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: const TextStyle(color: IGColors.bgDark),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Cookies Policy',
                      style: const TextStyle(color: IGColors.bgDark),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),

              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: InstagramGradientButton(
                  label: 'Sign up',
                  onPressed: () async {
                    await _authController.register(
                      context,
                      emailController,
                      nameController,
                      passwordController,
                    );
                  },
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(child: Divider()),
                  Text('  OR  '),
                  Expanded(child: Divider()),
                ],
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () async {
                  await _authController.registerWithGoogle(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AssetPaths.googleSvg,
                      height: 20.h,
                      width: 20.w,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'Signup with Google',
                      style: TextStyle(
                        color: cs.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.phoneAuth);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AssetPaths.phoneSvg,
                      height: 20.h,
                      width: 20.w,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'Signup with Phone',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? '),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.login);
                    },
                    child: Text(
                      'Log in',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
