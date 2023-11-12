import 'dart:convert';

import 'package:get/get.dart';
import 'package:powersync/powersync.dart';
import 'package:powersync/sqlite3.dart' as sqlite;

class ChatSummaryModel {
  ChatSummaryModel({
    required this.chatId,
    required this.usernames,
    required this.userIds,
    required this.lastMessage,
    required this.messageType,
    required this.updatedAt,
  });

  /// User ID of the chat
  final int chatId;

  /// User name of the users in the chat
  final List<String> usernames;

  /// User IDs of the users in the chat
  final List<String> userIds;

  /// Last message written in the chat
  final String? lastMessage;

  /// The type of message written in the chat
  final String? messageType;

  /// Date and time when the last message written in the chat was created
  final DateTime updatedAt;

  ChatSummaryModel.fromMap(Map<String, dynamic> map)
      : chatId = map['chat_id'],
        userIds = map['user_ids'].cast<String>(),
        usernames = map['usernames'].cast<String>(),
        lastMessage = map['last_message'],
        messageType = map['message_type'],
        updatedAt = DateTime.parse(map['updated_at']);

  factory ChatSummaryModel.fromRow(sqlite.Row row) {
    return ChatSummaryModel(
        chatId: row['chat_id'],
        userIds: List<String>.from(jsonDecode(row['user_ids'])),
        usernames: List<String>.from(jsonDecode(row['usernames'])),
        updatedAt: DateTime.parse(row['updated_at']),
        lastMessage: row['last_message'],
        messageType: row['message_type']);
  }

  static Stream<List<ChatSummaryModel>> watchChats(String myUserId) {
    return Get.find<PowerSyncDatabase>()
        .watch(
            "SELECT * FROM chat_summary WHERE user_ids LIKE '%$myUserId%' ORDER BY updated_at asc")
        .map(
          (event) => event
              .map(
                (e) => ChatSummaryModel.fromRow(e),
              )
              .toList(growable: false),
        );
  }
}
