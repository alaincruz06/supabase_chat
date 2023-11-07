import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_chat/data/datasources/providers/supabase_provider.dart';
import 'package:supabase_chat/presentation/controllers/login_controller.dart';
import 'package:supabase_chat/presentation/controllers/user_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => LoginController(
        supabaseProvider: Get.find<SupabaseProvider>(),
        supabaseClient: Get.find<SupabaseClient>(),
        sharedPreferences: Get.find<SharedPreferences>(),
        userController: Get.find<UserController>(),
      ),
    );
  }
}
