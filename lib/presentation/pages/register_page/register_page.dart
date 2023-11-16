import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_chat/presentation/app/constants.dart';
import 'package:supabase_chat/presentation/controllers/register_controller.dart';
import 'package:supabase_chat/presentation/routes/app_pages.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app.register'.tr),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: formPadding,
          children: [
            TextFormField(
              controller: controller.emailController,
              decoration: const InputDecoration(
                label: Text('Email'),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'app.required'.tr;
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            formSpacer,
            Obx(
              () => TextFormField(
                controller: controller.passwordController,
                obscureText: controller.hidePassword.value,
                decoration: InputDecoration(
                    label: Text('app.password'.tr),
                    suffixIcon: IconButton(
                        onPressed: () => controller.changePasswordValue(),
                        icon: Icon(controller.hidePassword.value
                            ? CupertinoIcons.eye_slash
                            : CupertinoIcons.eye))),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'app.required'.tr;
                  }
                  if (val.length < 6) {
                    return 'app.sixCharsMinimum'.tr;
                  }
                  return null;
                },
              ),
            ),
            formSpacer,
            TextFormField(
              controller: controller.usernameController,
              decoration: InputDecoration(
                label: Text('app.username'.tr),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'app.required'.tr;
                }
                final isValid = RegExp(r'^[A-Za-z0-9_]{3,24}$').hasMatch(val);
                if (!isValid) {
                  return 'app.threeToTwentyFourChars'.tr;
                }
                return null;
              },
            ),
            formSpacer,
            ElevatedButton(
              onPressed:
                  controller.isLoading.value ? null : () => controller.signUp(),
              child: Text('app.register'.tr),
            ),
            formSpacer,
            TextButton(
              onPressed: () => Get.offAllNamed(Routes.login),
              child: Text('app.iAlreadyHaveAnAccount'.tr),
            )
          ],
        ),
      ),
    );
  }
}
