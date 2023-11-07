import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_chat/core/utils.dart';
import 'package:supabase_chat/data/datasources/providers/supabase_provider.dart';
import 'package:supabase_chat/presentation/controllers/user_controller.dart';
import 'package:supabase_chat/presentation/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends GetxController {
  LoginController({
    required this.supabaseProvider,
    required this.supabaseClient,
    required this.sharedPreferences,
    required this.userController,
  });
  //#region Variables

  RxBool isLoading = false.obs;
  RxBool hidePassword = true.obs;

  final formKey = GlobalKey<FormState>();
  final SupabaseProvider supabaseProvider;
  final SupabaseClient supabaseClient;
  final SharedPreferences sharedPreferences;
  final UserController userController;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //#endregion

  //#region Init & Close

/*   @override
  void onInit() {
    super.onInit();
  } */

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //#endregion

  //#region Functions

  void changePasswordValue() {
    hidePassword.value = !hidePassword.value;
  }

  Future<void> signIn() async {
    isLoading.value = true;

    try {
      final result = await supabaseProvider.signIn(
          username: emailController.text, password: passwordController.text);

      if (result != null && result.session != null) {
        sharedPreferences.setString(
            'session_data', result.session!.persistSessionString);
        await userController.setLoggedInUser(
          result.user!.id,
        );
        Get.offAllNamed(Routes.home, predicate: (route) => false);
      }
    } on AuthException catch (error) {
      Get.context!
          .showErrorSnackBar(message: '${error.statusCode}: ${error.message}');
    } catch (e) {
      Get.context!.showErrorSnackBar(
          message: "${'app.unexpectedErrorMessage'.tr} : ${e.toString()}");
    }
    isLoading.value = false;
  }

  //#endregion
}
