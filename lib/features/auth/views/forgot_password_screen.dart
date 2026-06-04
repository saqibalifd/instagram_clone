import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/features/auth/widgets/auth_textfield_widget.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:instagram/shared_widgets/instagram_gradient_button.dart';
import 'package:instagram/utils/loading_utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ts = Theme.of(context).textTheme;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalMediumPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: IGColors.bgDark, width: 3),
              ),
              child: Center(child: Icon(Icons.lock_outline, size: 50.sp)),
            ),
            SizedBox(height: 30.h),
            Center(child: Text('Trouble logging in?', style: ts.displayLarge)),
            SizedBox(height: 30.h),
            Center(
              child: SizedBox(
                width: 250.w,

                child: Text(
                  textAlign: TextAlign.center,
                  "Enter your email and we'll send you a link to get back into your account.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: IGColors.gray,
                  ),
                ),
              ),
            ),

            SizedBox(height: 30.h),
            AuthTextfieldWidget(hintText: "Email"),

            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: InstagramGradientButton(
                label: 'Send reset link',
                onPressed: () async {
                  LoadingUtil.show();
                  await Future.delayed(Duration(seconds: 3));
                  LoadingUtil.dismiss();
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
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.register);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: IGColors.bgLight,
                  foregroundColor: IGColors.bgDark,
                  elevation: 0,
                  side: const BorderSide(color: IGColors.gray, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Create new account'),
              ),
            ),
            SizedBox(height: 20.h),
            Divider(),
            SizedBox(height: 40.h),
            GestureDetector(
              onTap: () => Get.back(),
              child: Text(
                'Back to login',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: IGColors.gray,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
