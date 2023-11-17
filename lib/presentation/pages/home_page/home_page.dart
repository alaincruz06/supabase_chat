import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_chat/core/constants.dart';
import 'package:supabase_chat/presentation/controllers/home_controller.dart';
import 'package:timeago/timeago.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
              onPressed: () => controller.signOut(),
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Obx(
        () => ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: controller.chats?.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () => controller.goToChat(controller.chats![index]),
              title: Text(
                controller.getOtherUsersNames(controller.chats![index]),
              ),
              subtitle:
                  controller.chats?[index].messageType == MessageType.text.name
                      ? Text(controller.chats?[index].lastMessage ?? '')
                      : controller.chats?[index].messageType ==
                              MessageType.photo.name
                          ? Row(
                              children: [
                                const Icon(Icons.image),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text('app.image'.tr),
                                ),
                              ],
                            )
                          : controller.chats?[index].messageType ==
                                  MessageType.audio.name
                              ? Row(
                                  children: [
                                    const Icon(Icons.audiotrack),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text('app.voiceNote'.tr),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
              trailing: SizedBox(
                width: 60,
                child: Row(
                  children: [
                    Text(
                      format(controller.chats![index].updatedAt,
                          locale: 'en_short'),
                    ),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.addChat(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
