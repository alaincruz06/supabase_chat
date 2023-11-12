import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powersync/powersync.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_chat/data/datasources/providers/supabase_provider.dart';
import 'package:supabase_chat/data/datasources/providers_impl/supabase_provider_impl.dart';
import 'package:supabase_chat/data/models/powersync_schema.dart';
import 'package:supabase_chat/env.dart';
import 'package:supabase_chat/powersync.dart';
import 'package:supabase_chat/presentation/controllers/language_controller.dart';
import 'package:supabase_chat/presentation/controllers/user_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DependencyInjection {
  static Future<void> init() async {
    await _setupSupabase();

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

  static Future<void> _setupSupabase() async {
    final dir = await getApplicationSupportDirectory();
    final path = join(dir.path, 'powersync-offline-chat.db');
    // Setup the database.
    Get.put<PowerSyncDatabase>(
        PowerSyncDatabase(schema: powerSyncSchema, path: path));
    await Get.find<PowerSyncDatabase>().initialize();

    //Supabase instance
    Get.put<SupabaseClient>(
        SupabaseClient(Env.supabaseProjectUrl, Env.apiKeyAnonPublic));

    final isLoggedIn =
        Get.find<SupabaseClient>().auth.currentSession?.accessToken != null;

    SupabaseConnector? supabaseConnector;
    if (isLoggedIn) {
      supabaseConnector =
          SupabaseConnector(powerSyncDatabase: Get.find<PowerSyncDatabase>());
      Get.find<PowerSyncDatabase>().connect(connector: supabaseConnector);
    }
    Get.find<SupabaseClient>().auth.onAuthStateChange.listen((data) async {
      final AuthChangeEvent authChangeEvent = data.event;
      if (authChangeEvent == AuthChangeEvent.signedIn) {
        supabaseConnector =
            SupabaseConnector(powerSyncDatabase: Get.find<PowerSyncDatabase>());
        Get.find<PowerSyncDatabase>().connect(connector: supabaseConnector!);
      } else if (authChangeEvent == AuthChangeEvent.signedOut) {
        supabaseConnector = null;
        await Get.find<PowerSyncDatabase>().disconnect();
      } else if (authChangeEvent == AuthChangeEvent.tokenRefreshed) {
        supabaseConnector?.prefetchCredentials();
      }
    });
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
