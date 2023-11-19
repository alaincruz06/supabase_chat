import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_chat/data/datasources/providers/supabase_provider.dart';
import 'package:supabase_chat/data/datasources/providers_impl/supabase_provider_impl.dart';
import 'package:supabase_chat/env.dart';
import 'package:supabase_chat/presentation/controllers/language_controller.dart';
import 'package:supabase_chat/presentation/controllers/user_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DependencyInjection {
  static Future<void> init() async {
    _setupSupabase();

    await _setupStorage();

    _setupProvider();

    _setupController();
  }

  static void _setupController() {
    Get
      ..put<LanguageController>(LanguageController())
      ..put<UserController>(UserController(
        supabaseClient: Get.find<SupabaseClient>(),
        supabaseProvider: Get.find<SupabaseProvider>(),
      ));
  }

  static void _setupSupabase() async {
    //Supabase instance
    Get.put<SupabaseClient>(
        SupabaseClient(Env.supabaseProjectUrl, Env.apiKeyAnonPublic));
  }

  static Future<void> _setupStorage() async {
    Get.put<GetStorage>(GetStorage());

    //SharedPreferences
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    Get.put<SharedPreferences>(preferences);
  }

  static void _setupProvider() {
    Get.lazyPut<SupabaseProvider>(
        () => SupabaseProviderImpl(
              supabase: Get.find<SupabaseClient>(),
            ),
        fenix: true);
  }
}
