import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_chat/core/constants.dart';
import 'package:supabase_chat/core/function_utils.dart';
import 'package:supabase_chat/data/models/chat_messages_info_view_model.dart';
import 'package:supabase_chat/data/models/chats_messages.dart';
import 'package:supabase_chat/domain/models/message_domain.dart';
import 'package:supabase_chat/domain/models/profile_domain.dart';
import 'package:supabase_chat/presentation/controllers/chat_controller.dart';
import 'package:supabase_chat/presentation/widgets/preloader_widget.dart';
import 'package:timeago/timeago.dart';

import '../../../../data/models/profile_model.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.message,
    required this.isMine,
    required this.controller,
  }) : super(key: key);

  final ChatsMessagesModel message;
  final ChatController controller;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      if (!isMine)
        FutureBuilder(
            future: controller.getUser(message),
            builder:
                (BuildContext context, AsyncSnapshot<ProfileModel> snapshot) {
              if (snapshot.hasData) {
                return CircleAvatar(
                  child: Text(snapshot.data!.username.substring(0, 2)),
                );
              } else {
                return const PreloaderWidget();
              }
            }),
      const SizedBox(width: 12),
      Flexible(
        child: Column(
          crossAxisAlignment:
              isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              height:
                  message.messageType == MessageType.photo.name ? 150 : null,
              width: message.messageType == MessageType.photo.name
                  ? Get.width * 0.5
                  : null,
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color:
                    !isMine ? Theme.of(context).primaryColor : Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: message.messageType == MessageType.photo.name
                  ? FutureBuilder(
                      future: FunctionUtils.base64decodeImageFromBase64String(
                          message.message),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Image.memory(snapshot.data!);
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else {
                          return const PreloaderWidget();
                        }
                      })
                  : Text(message.message),
            ),
            Text(format(message.createdAt!, locale: 'en_short')),
          ],
        ),
      ),
    ];
    if (isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
