// ============================================================
//  WHAT GOES HERE
//  Registration screen — same pattern as LoginView.
//  Fields: username, email, password.
//  On submit: controller.signUp(email, password, username)
// ============================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../core/validators/input_validators.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // AuthTextField(controller: usernameCtrl, label: 'Username', validator: InputValidators.required),
            const SizedBox(height: 12),
            // AuthTextField(controller: emailCtrl,    label: 'Email',    validator: InputValidators.email),
            const SizedBox(height: 12),
            // AuthTextField(controller: passCtrl,     label: 'Password', obscure: true, validator: InputValidators.password),
            const SizedBox(height: 24),
            Obx(
              () => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => controller.signUp(
                        emailCtrl.text,
                        passCtrl.text,
                        usernameCtrl.text,
                      ),
                      child: const Text('Register'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
