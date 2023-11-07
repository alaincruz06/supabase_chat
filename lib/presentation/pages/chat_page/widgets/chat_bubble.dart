import 'package:flutter/material.dart';
import 'package:supabase_chat/data/models/chat_messages_info_view_model.dart';
import 'package:supabase_chat/data/models/chats_messages.dart';
import 'package:supabase_chat/domain/models/message_domain.dart';
import 'package:supabase_chat/domain/models/profile_domain.dart';
import 'package:supabase_chat/presentation/widgets/preloader_widget.dart';
import 'package:timeago/timeago.dart';

import '../../../../data/models/profile_model.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.message,
    required this.isMine,
    required this.profileName,
  }) : super(key: key);

  final ChatsMessagesModel message;
  final String profileName;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      if (!isMine)
        CircleAvatar(
          child: Text(profileName.substring(0, 2)),
        ),
      const SizedBox(width: 12),
      Flexible(
        child: Column(
          crossAxisAlignment:
              isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color:
                    !isMine ? Theme.of(context).primaryColor : Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(message.message),
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
