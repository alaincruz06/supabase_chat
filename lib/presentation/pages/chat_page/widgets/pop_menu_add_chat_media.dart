import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_chat/presentation/controllers/chat_controller.dart';

class PopMenuAddChatMedia extends StatelessWidget {
  const PopMenuAddChatMedia({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            value: 'pick_photo',
            child: Row(
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  color: Theme.of(context).iconTheme.color,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text('app.pickPhotos'.tr),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'take_photo',
            child: Row(
              children: [
                Icon(
                  Icons.add_a_photo_outlined,
                  color: Theme.of(context).iconTheme.color,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text('app.takePhotos'.tr),
              ],
            ),
          ),
        ];
      },
      padding: const EdgeInsets.all(15.0),
      elevation: 3.0,
      offset: const Offset(1.0, 0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      icon: Icon(
        Icons.add,
        color: Theme.of(context).iconTheme.color,
      ),
      onSelected: (selectedItem) async {
        switch (selectedItem) {
          case 'pick_photo':
            controller.pickPhotos();
            break;
          case 'take_photo':
            controller.takePhotos();
            break;
        }
      },
    );
  }
}
