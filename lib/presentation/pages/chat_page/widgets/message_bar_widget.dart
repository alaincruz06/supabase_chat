import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_chat/core/constants.dart';
import 'package:supabase_chat/presentation/controllers/chat_controller.dart';
import 'package:supabase_chat/presentation/pages/chat_page/widgets/pop_menu_add_chat_media.dart';

/// Set of widget that contains TextField and Button to submit message
class MessageBar extends GetView<ChatController> {
  const MessageBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[200],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            children: [
              PopMenuAddChatMedia(
                controller: controller,
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  autofocus: true,
                  controller: controller.textController,
                  decoration: InputDecoration(
                    focusedBorder:
                        const OutlineInputBorder(borderSide: BorderSide()),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    hintText: 'app.typeAMessage'.tr,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(8),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => controller.submitMessage(
                    messageToSend: controller.textController.text,
                    messageType: MessageType.text),
                icon: const Icon(
                  Icons.send,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.mic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
