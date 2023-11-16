import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_chat/data/datasources/providers/supabase_provider.dart';
import 'package:supabase_chat/data/models/chat_summary_model.dart';
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

  StreamSubscription<List<ChatSummaryModel>?>? userChatsSubscription;
  RxList<ChatSummaryModel>? chats = <ChatSummaryModel>[].obs;
  RxString activeUserId = ''.obs;

  //#endregion

  //#region Init & Close

  @override
  void onInit() async {
    super.onInit();
    activeUserId.value = userController.profileDomain.value.userId;
    await getUserChats();
  }

  @override
  void dispose() {
    userChatsSubscription?.cancel();
    super.dispose();
  }

  //#endregion

  //#region Functions

  Future<void> getUserChats() async {
    try {
      realtimeChannel = supabaseClient.channel('public:chat_summary').on(
          RealtimeListenTypes.postgresChanges,
          ChannelFilter(event: '*', schema: 'public', table: 'chat_summary'),
          (payload, [ref]) {
        loadUserChatsStream();
      });
      realtimeChannel.subscribe();
      loadUserChatsStream();
    } catch (e) {
      debugPrint('Error on getUserChats: $e');
    }
  }

  void loadUserChatsStream() {
    userChatsSubscription =
        supabaseProvider.getChatsStream(activeUserId.value).listen((chatsData) {
      chats?.value = chatsData?.obs ?? <ChatSummaryModel>[].obs;
    });
  }

  void addChat() {
    Get.toNamed(Routes.users);
  }

  void goToChat(ChatSummaryModel chatSummaryModel) {
    Get.toNamed(Routes.chat, arguments: {'chatSummmary': chatSummaryModel});
  }

  String getOtherUsersNames(ChatSummaryModel chatSummaryModel) {
    String names = '';
    if (chatSummaryModel.usernames.length != chatSummaryModel.userIds.length) {
      throw ArgumentError(
          'The "usernames" and "usersIds" lists must have the same lenght');
    }
    int activeUserIndex = chatSummaryModel.userIds.indexOf(activeUserId.value);
    if (chatSummaryModel.usernames.length != chatSummaryModel.userIds.length) {
      throw ArgumentError('User has not been foung in the chats list');
    }

    var namesTemp = List.of(chatSummaryModel.usernames)
      ..removeAt(activeUserIndex);
    names = namesTemp.join(', ');

    return names;
  }

  Future<void> signOut() async {
    supabaseProvider.signOut();
    final prefs = Get.find<SharedPreferences>();
    await prefs.remove('session_data');
    Get.offAllNamed(Routes.register, predicate: (route) => false);
  }

  //#endregion
}
