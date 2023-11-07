import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_chat/data/datasources/providers/supabase_provider.dart';
import 'package:supabase_chat/data/models/chat_summary_view_model.dart';
import 'package:supabase_chat/presentation/controllers/user_controller.dart';
import 'package:supabase_chat/presentation/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  HomeController({
    required this.supabaseProvider,
    required this.supabaseClient,
    required this.userController,
  });
  //#region Variables

  final SupabaseProvider supabaseProvider;
  final UserController userController;
  final SupabaseClient supabaseClient;
  late RealtimeChannel realtimeChannel;
  Stream<List<ChatSummaryViewModel>?> userChatsStream = const Stream.empty();
  RxString activeUserId = ''.obs;

  //#endregion

  //#region Init & Close

  @override
  void onInit() async {
    super.onInit();
    activeUserId.value = userController.profileDomain.value.userId;
    await getUserChats();
  }

/*   @override
  void dispose() {
    super.dispose();
  } */

//#endregion

  //#region Functions

  Future<void> getUserChats() async {
    try {
      realtimeChannel = supabaseClient.channel('public:chats').on(
          RealtimeListenTypes.postgresChanges,
          ChannelFilter(event: '*', schema: 'public', table: 'chats'), (payload,
              [ref]) {
        debugPrint(
            'Change received realtimeChannel on public:chats: ${payload.toString()}');
        loadUserChatsStream();
      });
      realtimeChannel.subscribe();

      loadUserChatsStream();
    } catch (e) {
      debugPrint('Error on getUserChats: $e');
    }
  }

  void loadUserChatsStream() {
    userChatsStream = supabaseProvider.getChatsStream(activeUserId.value);
  }

  void addChat() {
    Get.toNamed(Routes.users);
  }

  void goToChat(ChatSummaryViewModel chatSummaryViewModel) {
    Get.toNamed(Routes.chat, arguments: {'chatSummmary': chatSummaryViewModel});
  }

  String getOtherUsersNames(ChatSummaryViewModel chatSummaryViewModel) {
    String names = '';
    if (chatSummaryViewModel.usernames.length !=
        chatSummaryViewModel.userIds.length) {
      throw ArgumentError(
          'The "usernames" and "usersIds" lists must have the same lenght');
    }
    int activeUserIndex =
        chatSummaryViewModel.userIds.indexOf(activeUserId.value);
    if (chatSummaryViewModel.usernames.length !=
        chatSummaryViewModel.userIds.length) {
      throw ArgumentError('User has not been foung in the chats list');
    }

    var namesTemp = List.of(chatSummaryViewModel.usernames)
      ..removeAt(activeUserIndex);
    names = namesTemp.join(', ');

    return names;
  }

  //#endregion
}
