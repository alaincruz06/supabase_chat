import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_chat/core/utils.dart';
import 'package:supabase_chat/data/datasources/providers/supabase_provider.dart';
import 'package:supabase_chat/data/models/chat_summary_view_model.dart';
import 'package:supabase_chat/data/models/chats_messages.dart';
import 'package:supabase_chat/data/models/profile_model.dart';
import 'package:supabase_chat/presentation/controllers/user_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatController extends GetxController {
  ChatController({
    required this.supabaseProvider,
    required this.supabaseClient,
    required this.userController,
  });
  //#region Variables

  final UserController userController;
  final SupabaseProvider supabaseProvider;
  final SupabaseClient supabaseClient;
  late RealtimeChannel realtimeChannel;
  StreamSubscription<List<ChatsMessagesModel>>? chatMessagesSubscription;
  RxList<ChatsMessagesModel> messages = <ChatsMessagesModel>[].obs;
  RxString activeUserId = ''.obs;
  RxDouble maxExtent = 0.0.obs;

  final ScrollController messagesScrollController = ScrollController();
  final TextEditingController textController = TextEditingController();

  //late vars
  late ChatSummaryViewModel chatSummaryViewModel;

  //#endregion

  //#region Init & Close

  @override
  void onInit() async {
    super.onInit();
    activeUserId.value = userController.profileDomain.value.userId;
    chatSummaryViewModel =
        Get.arguments['chatSummmary'] as ChatSummaryViewModel;
    await getMessages();

    // Add listener to the list
    messages.listen((p0) {
      goToBottom();
    });
  }

  @override
  void dispose() {
    chatMessagesSubscription?.cancel();
    messagesScrollController.dispose();
    textController.dispose();
    super.dispose();
  }

  //#endregion

  //#region Functions

  Future<void> getMessages() async {
    try {
      realtimeChannel = supabaseClient.channel('public:chats_messages').on(
          RealtimeListenTypes.postgresChanges,
          ChannelFilter(
              event: 'INSERT',
              schema: 'public',
              table: 'chats_messages'), (payload, [ref]) {
        loadMessagesStream();
      });
      realtimeChannel.subscribe();
      loadMessagesStream();
    } catch (e) {
      debugPrint('Error on getMessages: $e');
    }
  }

  void loadMessagesStream() {
    chatMessagesSubscription = supabaseProvider
        .getMessagesStream(chatId: chatSummaryViewModel.chatId)
        ?.listen((chatsData) {
      messages.value = chatsData.obs;
    });
  }

  Future<ProfileModel> getUser(ChatsMessagesModel chat) async {
    return await supabaseProvider.getUser(userUuid: chat.userUuid);
  }

  void goToBottom() {
    messagesScrollController.animateTo(
      maxExtent.value,
      duration: const Duration(microseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  void submitMessage() async {
    final text = textController.text;
    if (text.isEmpty) {
      return;
    }
    textController.clear();
    try {
      //TODO differents messageTypes
      await supabaseProvider.sendMessage(
          chatsMessagesModel: ChatsMessagesModel(
              chatId: chatSummaryViewModel.chatId,
              userId: userController.profileDomain.value.id,
              userUuid: userController.profileDomain.value.userId,
              message: text,
              messageType: 'text'));
      textController.clear();
      await getMessages();
    } on PostgrestException catch (error) {
      Get.context!.showErrorSnackBar(message: error.message);
    } catch (_) {
      Get.context!.showErrorSnackBar(message: 'app.unexpectedErrorMessage'.tr);
    }
  }

  //#endregion
}
