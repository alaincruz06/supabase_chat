import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_chat/core/extensions.dart';
import 'package:supabase_chat/data/datasources/providers/supabase_provider.dart';
import 'package:supabase_chat/presentation/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterController extends GetxController {
  RegisterController({
    required this.supabaseProvider,
  });
  //#region Variables

  RxBool isLoading = false.obs;
  RxBool hidePassword = true.obs;

  final formKey = GlobalKey<FormState>();
  final SupabaseProvider supabaseProvider;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

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
    usernameController.dispose();
    super.dispose();
  }

  //#endregion

  //#region Functions

  void changePasswordValue() {
    hidePassword.value = !hidePassword.value;
  }

  Future<void> signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    final email = emailController.text;
    final password = passwordController.text;
    final username = usernameController.text;
    try {
      await supabaseProvider.signUp(
          username: username, email: email, password: password);
      Get.offAllNamed(Routes.home, predicate: (route) => false);
    } on AuthException catch (error) {
      Get.context!
          .showErrorSnackBar(message: '${error.statusCode}: ${error.message}');
    } catch (error) {
      Get.context!.showErrorSnackBar(message: 'app.unexpectedErrorMessage'.tr);
    }
  }

  //#endregion
}
