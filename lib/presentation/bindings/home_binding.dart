import 'package:get/get.dart';
import 'package:supabase_chat/data/datasources/providers/supabase_provider.dart';
import 'package:supabase_chat/presentation/controllers/home_controller.dart';
import 'package:supabase_chat/presentation/controllers/user_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(
          supabaseProvider: Get.find<SupabaseProvider>(),
          userController: Get.find<UserController>(),
          supabaseClient: Get.find<SupabaseClient>(),
        ));
  }
}
