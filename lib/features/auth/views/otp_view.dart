import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/features/auth/controllers/auth_controller.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:instagram/shared_widgets/instagram_gradient_button.dart';
import 'package:pinput/pinput.dart';

class OtpView extends StatefulWidget {
  const OtpView({super.key});

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final AuthController _authController = AuthController();
  final TextEditingController otpController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final args = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final String verificationId = args['verificationId'];
    final String phone = args['phone'];
    final String name = args['name'];
    final String email = args['email'];

    final cs = Theme.of(context).colorScheme;
    final ts = Theme.of(context).textTheme;
    final defaultPinTheme = PinTheme(
      width: 52,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: IGColors.bgDark,
      ),
      decoration: BoxDecoration(
        color: IGColors.gray.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: IGColors.gray.withValues(alpha: 0.3)),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: IGColors.bgLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: IGColors.blue, width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: IGColors.blue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: IGColors.blue),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: IGColors.like.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: IGColors.like),
      ),
    );

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
              SizedBox(height: 90.h),
              Center(child: Text('Instagram', style: ts.displayLarge)),
              SizedBox(height: 30.h),
              Container(
                height: 100.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: IGColors.bgDark, width: 3),
                ),
                child: Center(child: Icon(AppIcons.message, size: 50.sp)),
              ),
              SizedBox(height: 20.h),
              Center(
                child: Text('Enter confirmation code', style: ts.displaySmall),
              ),
              SizedBox(height: 20.h),

              Center(
                child: SizedBox(
                  width: 260.w,

                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                      children: [
                        const TextSpan(text: 'Enter 6 digit code we sent to '),
                        TextSpan(
                          text: phone,
                          style: const TextStyle(color: IGColors.bgDark),
                        ),
                        const TextSpan(
                          text: ' it may take a moment to arrive. ',
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30.h),
              Center(
                child: Pinput(
                  length: 6,
                  controller: otpController,
                  focusNode: focusNode,
                  autofocus: true,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  errorPinTheme: errorPinTheme,
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  onCompleted: (value) {
                    _authController.verifyOtp;
                  },
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Please enter the complete OTP';
                    }
                    return null;
                  },
                ),
              ),

              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: InstagramGradientButton(
                  label: 'Confirm',
                  onPressed: () async {
                    await _authController.verifyOtp(
                      context,
                      otpController.text,
                      verificationId,
                      name,
                      name.trim(),
                      email,
                      phone,
                    );
                  },
                ),
              ),
              SizedBox(height: 20.h),

              Text(
                "Didn't receive the code?",
                style: TextStyle(color: IGColors.gray),
              ),

              TextButton(
                onPressed: () async {
                  await _authController.resendOtp(context, phone);
                },
                child: Text('Resend code'),
              ),

              SizedBox(height: 10.h),
              TextButton(
                onPressed: () {
                  Get.offAllNamed(AppRoutes.phoneAuth);
                },
                child: Text(
                  "Wrong phone number?",
                  style: TextStyle(color: IGColors.gray),
                ),
              ),

              Divider(),
              SizedBox(height: 10.h),
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
