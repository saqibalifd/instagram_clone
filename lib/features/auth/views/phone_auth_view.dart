import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/core/validators/input_validators.dart';
import 'package:instagram/features/auth/controllers/auth_controller.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:instagram/shared_widgets/instagram_gradient_button.dart';

class PhoneAuthView extends StatefulWidget {
  const PhoneAuthView({super.key});

  @override
  State<PhoneAuthView> createState() => _PhoneAuthViewState();
}

class _PhoneAuthViewState extends State<PhoneAuthView> {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController phoneController = TextEditingController();
  String _selectedCountryCode = '+92';
  final args = Get.arguments;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ts = Theme.of(context).textTheme;
    final String email = args['email'];
    final String name = args['name'];

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalMediumPadding,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                  child: Center(child: Icon(AppIcons.phone, size: 50.sp)),
                ),
                SizedBox(height: 20.h),
                Center(
                  child: Text(
                    'Enter your phone number',
                    style: ts.displaySmall,
                  ),
                ),
                SizedBox(height: 20.h),

                Center(
                  child: SizedBox(
                    width: 260.w,
                    child: Text(
                      textAlign: TextAlign.center,
                      "Enter your phone number to get a verification code. Carrier rates may apply.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: IGColors.gray,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30.h),
                TextFormField(
                  cursorColor: cs.secondary,
                  controller: phoneController,
                  keyboardType: TextInputType.phone,

                  decoration: InputDecoration(
                    hintText: '3001234567',
                    hintStyle: TextStyle(
                      color: IGColors.gray.withValues(alpha: 0.5),
                    ),
                    prefixIcon: CountryCodePicker(
                      onChanged: (CountryCode code) {
                        setState(() {
                          _selectedCountryCode = code.dialCode ?? '+92';
                        });
                      },
                      initialSelection: 'PK',
                      favorite: const ['+92', 'PK'],
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 12,
                    ),
                  ),
                  validator: InputValidators.phone,
                ),

                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: InstagramGradientButton(
                    label: 'Send OTP',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _authController.sendOtp(
                          context,
                          _selectedCountryCode,
                          phoneController.text.trim(),
                          name,
                          email,
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
                TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.register);
                  },
                  child: Text('Sign up with email instead.'),
                ),
                SizedBox(height: 20.h),
                Divider(),
                SizedBox(height: 40.h),
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
      ),
    );
  }
}
