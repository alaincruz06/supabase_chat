import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_chat/presentation/controllers/chat_controller.dart';

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
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  autofocus: true,
                  controller: controller.textController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () => controller.sendPhotos(),
                      icon: const Icon(Icons.add_photo_alternate_outlined),
                    ),
                    hintText: 'app.typeAMessage'.tr,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.all(8),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => controller.submitMessage(),
                child: Text('app.send'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
