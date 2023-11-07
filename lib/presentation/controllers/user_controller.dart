import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_chat/data/datasources/providers/supabase_provider.dart';
import 'package:supabase_chat/domain/mappers/profile_mapper.dart';
import 'package:supabase_chat/domain/models/profile_domain.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserController extends GetxController {
  UserController({
    required this.supabaseProvider,
    required this.supabaseClient,
  });

  //#region Variables
  final Rx<ProfileDomain> profileDomain = ProfileDomain.initData().obs;
  final SupabaseProvider supabaseProvider;
  final SupabaseClient supabaseClient;

  //#endregion

  //#region Init & Close

/*   @override
  void onInit() async {
    super.onInit();
  }
 */
/*   @override
  void dispose() {
    userSubscription?.cancel();
    super.dispose();
  }
 */
  //#endregion

  //#region Functions
  Future<void> setLoggedInUser(String userId) async {
    try {
      var profile = await supabaseProvider.getUser(userUuid: userId);
      profileDomain.value =
          ProfileMapperImpl().profileDomainByProfileProvider(profile);
    } catch (e) {
      debugPrint('Error at setLoggedInUser: $e');
    }
  }

  //#endregion
}
