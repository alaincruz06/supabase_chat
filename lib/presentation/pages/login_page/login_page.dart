import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_chat/presentation/app/constants.dart';
import 'package:supabase_chat/presentation/controllers/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('app.signIn'.tr)),
      body: ListView(
        padding: formPadding,
        children: [
          TextFormField(
            controller: controller.emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          formSpacer,
          Obx(
            () => TextFormField(
              controller: controller.passwordController,
              decoration: InputDecoration(
                  labelText: 'app.password'.tr,
                  suffixIcon: IconButton(
                      onPressed: () => controller.changePasswordValue(),
                      icon: Icon(controller.hidePassword.value
                          ? CupertinoIcons.eye_slash
                          : CupertinoIcons.eye))),
              obscureText: controller.hidePassword.value,
            ),
          ),
          formSpacer,
          ElevatedButton(
            onPressed:
                controller.isLoading.value ? null : () => controller.signIn(),
            child: Text('app.signIn'.tr),
          ),
        ],
      ),
    );
  }
}
