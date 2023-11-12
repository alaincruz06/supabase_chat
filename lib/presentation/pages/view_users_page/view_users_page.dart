import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_chat/data/models/profile_model.dart';
import 'package:supabase_chat/presentation/controllers/view_users_controller.dart';
import 'package:supabase_chat/presentation/widgets/preloader_widget.dart';

class ViewUsersPage extends GetView<ViewUsersController> {
  const ViewUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('app.users'.tr)),
      body: StreamBuilder(
          stream: controller.usersStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<ProfileModel>> snapshot) {
            if (snapshot.hasData) {
              var users = snapshot.data!;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () => controller.selectUser(users[index].userId),
                    title: Text(
                      users[index].username,
                    ),
                    subtitle: Text(users[index].userId),
                    trailing: const Icon(Icons.chat_bubble_outline),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return const PreloaderWidget();
            }
          }),
    );
  }
}
