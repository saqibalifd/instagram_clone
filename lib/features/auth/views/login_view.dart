import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/constants/asset_paths.dart';
import 'package:instagram/core/validators/input_validators.dart';
import 'package:instagram/features/auth/controllers/auth_controller.dart';
import 'package:instagram/features/auth/controllers/password_visibility_controller.dart';
import 'package:instagram/features/auth/widgets/auth_textfield_widget.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:instagram/shared_widgets/instagram_gradient_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthController _authController = Get.put(AuthController());
  final PasswordVisibilityController _passwordVisibilityController = Get.put(
    PasswordVisibilityController(),
  );

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ts = Theme.of(context).textTheme;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalMediumPadding,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Text(AppConstants.appName, style: ts.displayLarge)),
              SizedBox(height: 50.h),
              AuthTextfieldWidget(
                validator: InputValidators.email,
                controller: emailController,
                hintText: "Email",
              ),
              SizedBox(height: 10.h),
              Obx(
                () => AuthTextfieldWidget(
                  hintText: "Password",

                  controller: passwordController,
                  validator: InputValidators.password,
                  obSecure:
                      !_passwordVisibilityController.isPasswordVisible.value,
                  suffix: IconButton(
                    onPressed:
                        _passwordVisibilityController.togglePasswordVisibility,
                    icon: Icon(
                      _passwordVisibilityController.isPasswordVisible.value
                          ? AppIcons.eyeOpen
                          : AppIcons.eyeClose,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.forgotPassword);
                  },
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cs.secondary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: InstagramGradientButton(
                  label: 'Login',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _authController.login(
                        context,
                        emailController,
                        passwordController,
                      );
                    }
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
                      'Log in with Google',
                      style: TextStyle(
                        color: cs.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // GestureDetector(
              //   onTap: () {
              //     Get.toNamed(AppRoutes.phoneAuth);
              //   },
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       SvgPicture.asset(
              //         AssetPaths.phoneSvg,
              //         height: 20.h,
              //         width: 20.w,
              //       ),
              //       SizedBox(width: 10.w),
              //       Text(
              //         'Log in with Phone',
              //         style: TextStyle(fontWeight: FontWeight.bold),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(height: 20.h),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.register);
                    },
                    child: Text(
                      'Sign up',
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
