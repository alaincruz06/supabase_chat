import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_chat/core/extensions.dart';
import 'package:supabase_chat/data/datasources/providers/supabase_provider.dart';
import 'package:supabase_chat/data/models/chat_messages_info_view_model.dart';
import 'package:supabase_chat/data/models/chat_summary_model.dart';
import 'package:supabase_chat/data/models/chats_messages.dart';
import 'package:supabase_chat/data/models/profile_model.dart';
import 'package:supabase_chat/presentation/controllers/home_controller.dart';
import 'package:supabase_chat/presentation/controllers/user_controller.dart';
import 'package:supabase_chat/presentation/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewUsersController extends GetxController {
  ViewUsersController({
    required this.supabaseProvider,
    required this.userController,
  });
  //#region Variables

  final UserController userController;
  final SupabaseProvider supabaseProvider;
  Stream<List<ProfileModel>> usersStream = const Stream.empty();
  RxString activeUserId = ''.obs;

  //#endregion

  //#region Init & Close

  @override
  void onInit() async {
    super.onInit();
    activeUserId.value = userController.profileDomain.value.userId;
    await getUsers();
  }

  //#endregion

  //#region Functions

  Future<void> getUsers() async {
    try {
      usersStream =
          supabaseProvider.getAvailableUsers(userUuid: activeUserId.value) ??
              const Stream.empty();
    } catch (e) {
      debugPrint('Error on getUsers: $e');
    }
  }

  void selectUser(String userId) async {
    try {
      ChatSummaryModel? chatSummaryModel = await supabaseProvider
          .existsChatAlready(usersIds: [activeUserId.value, userId]);
      if (chatSummaryModel != null) {
        Get.offNamed(Routes.chat,
            arguments: {'chatSummmary': chatSummaryModel});
        Get.find<HomeController>().loadUserChatsStream();
      } else {
        await supabaseProvider
            .createChat(usersIds: [activeUserId.value, userId]);

        ChatSummaryModel? chatSummaryModel = await supabaseProvider
            .existsChatAlready(usersIds: [activeUserId.value, userId]);

        Get.offNamed(Routes.chat,
            arguments: {'chatSummmary': chatSummaryModel});
        Get.find<HomeController>().loadUserChatsStream();
      }
    } on PostgrestException catch (error) {
      debugPrint('Error on selectUser: $error');
      Get.context!.showErrorSnackBar(message: error.message);
    } catch (e) {
      debugPrint('Error on selectUser: $e');
      Get.context!.showErrorSnackBar(message: 'app.unexpectedErrorMessage'.tr);
    }
  }

  //#endregion
}
