import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/core/constants/asset_paths.dart';
import 'package:instagram/features/auth/widgets/auth_textfield_widget.dart';
import 'package:instagram/shared_widgets/instagram_gradient_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
            Center(child: Text(AppConstants.appName, style: ts.displayLarge)),
            SizedBox(height: 50.h),
            AuthTextfieldWidget(hintText: "Email"),
            SizedBox(height: 10.h),
            AuthTextfieldWidget(hintText: "Password"),
            SizedBox(height: 10.h),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Forgot password?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: cs.secondary,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: InstagramGradientButton(label: 'Login', onPressed: () {}),
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
            InkWell(
              onTap: () {
                print('Login with Google');
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
            InkWell(
              onTap: () {
                print('Login with phone');
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
                    'Log in with Phone',
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
                Text('Don\'t have an account?'),
                TextButton(onPressed: () {}, child: Text('Sign up')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
