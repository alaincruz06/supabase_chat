import 'package:get/get.dart';
import 'package:supabase_chat/data/datasources/providers/supabase_provider.dart';
import 'package:supabase_chat/presentation/controllers/user_controller.dart';
import 'package:supabase_chat/presentation/controllers/view_users_controller.dart';

class ViewUsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ViewUsersController(
        supabaseProvider: Get.find<SupabaseProvider>(),
        userController: Get.find<UserController>(),
      ),
    );
  }
}
