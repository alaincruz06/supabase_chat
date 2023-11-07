import 'package:get/get.dart';
import 'package:supabase_chat/data/datasources/providers/supabase_provider.dart';
import 'package:supabase_chat/presentation/controllers/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() =>
        RegisterController(supabaseProvider: Get.find<SupabaseProvider>()));
  }
}
