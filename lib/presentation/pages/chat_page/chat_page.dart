import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_chat/domain/models/message_domain.dart';
import 'package:supabase_chat/presentation/controllers/chat_controller.dart';
import 'package:supabase_chat/presentation/pages/chat_page/widgets/chat_bubble.dart';
import 'package:supabase_chat/presentation/pages/chat_page/widgets/message_bar_widget.dart';
import 'package:supabase_chat/presentation/widgets/preloader_widget.dart';

/// Page to chat with someone.
///
/// Displays chat bubbles as a ListView and TextField to enter new chat.
class ChatPage extends GetView<ChatController> {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: NotificationListener(
              onNotification: (ScrollMetricsNotification t) {
                if (t.metrics.maxScrollExtent != 0 &&
                    t.metrics.maxScrollExtent > controller.maxExtent.value) {
                  controller.maxExtent.value = t.metrics.maxScrollExtent;
                  controller.goToBottom();
                }

                return true;
              },
              child: Obx(
                () => ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: controller.messagesScrollController,
                  itemCount: controller.messages.length,
                  itemBuilder: ((context, index) => ChatBubble(
                      message: controller.messages[index],
                      isMine: controller.messages[index].userUuid ==
                          controller.activeUserId.value,
                      controller: controller)),
                ),
              ),
            ),
          ),
          const MessageBar(),
        ],
      ),
    );
  }
}
