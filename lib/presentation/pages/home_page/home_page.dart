import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_chat/data/models/chat_summary_view_model.dart';
import 'package:supabase_chat/presentation/controllers/home_controller.dart';
import 'package:supabase_chat/presentation/widgets/preloader_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: StreamBuilder(
        stream: controller.userChatsStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<ChatSummaryViewModel>?> snapshot) {
          if (snapshot.hasData) {
            var chats = snapshot.data!;
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => controller.goToChat(chats[index]),
                  title: Text(
                    controller.getOtherUsersNames(chats[index]),
                  ),
                  subtitle: Text(chats[index].lastMessage),
                  trailing: SizedBox(
                    width: 60,
                    child: Row(
                      children: [
                        Text(
                          format(chats[index].updatedAt, locale: 'en_short'),
                        ),
                        const Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const PreloaderWidget();
          }
        },
      ),
      /* Obx(
        () => ListView.builder(
          itemCount: controller.userChats.length,
          itemBuilder: (context, index) {
            return Obx(
              () => ListTile(
                onTap: () => controller.goToChat(controller.userChats[index]),
                title: Text(
                  controller.getOtherUsersNames(controller.userChats[index]),
                ),
                subtitle: Text(controller.userChats[index].lastMessage),
                trailing: SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      Text(
                        format(controller.userChats[index].updatedAt,
                            locale: 'en_short'),
                      ),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ), */
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.addChat(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
