import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:powersync/powersync.dart';
import 'package:powersync/sqlite3.dart' as sqlite;

class ChatsMessagesModel {
  ChatsMessagesModel({
    this.id,
    required this.chatId,
    required this.userId,
    required this.userUuid,
    this.createdAt,
    required this.message,
    required this.messageType,
  });

  /// ID of the message
  final String? id;

  /// ID of the chat
  final int chatId;

  /// ID of the user who sent the message
  final int userId;

  /// UUID of the user who sent the message
  final String userUuid;

  /// Message content (base64 encoded if messageType != text)
  final String message;

  /// Name of the Message Enum Type
  final String messageType;

  /// Date and time when the profile was created
  final DateTime? createdAt;

  ChatsMessagesModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        chatId = map['chat_id'],
        userId = map['user_id'],
        userUuid = map['user_uuid'],
        message = map['message'],
        messageType = map['message_type'],
        createdAt = DateTime.parse(map['created_at']);

  Map<String, dynamic> toJson() => {
        "chat_id": chatId,
        "user_id": userId,
        "user_uuid": userUuid,
        "message": message,
        "message_type": messageType,
      };

  factory ChatsMessagesModel.fromRow(sqlite.Row row) {
    return ChatsMessagesModel(
        chatId: row['chat_id'],
        userId: row['user_id'],
        userUuid: row['user_uuid'],
        createdAt: row['created_at'] != null
            ? DateTime.parse(row['created_at'])
            : DateTime.now(),
        message: row['message'],
        messageType: row['message_type']);
  }

  static Stream<List<ChatsMessagesModel>> watchMessages(int chatId) {
    try {
      return Get.find<PowerSyncDatabase>()
          .watch('SELECT * FROM chats_messages WHERE chat_id = $chatId')
          .map(
            (event) => event
                .map(
                  (e) => ChatsMessagesModel.fromRow(e),
                )
                .toList(growable: false),
          );
    } catch (e) {
      debugPrint('Error on watchMessages: $e');
      return const Stream.empty();
    }
  }

  static Future<void> createMessage(
      ChatsMessagesModel chatsMessagesModel) async {
    try {
      Get.find<PowerSyncDatabase>().execute(
          "INSERT INTO chats_messages(id, chat_id, message, message_type, user_id, user_uuid) VALUES(uuid(), ${chatsMessagesModel.chatId}, '${chatsMessagesModel.message}', '${chatsMessagesModel.messageType}', ${chatsMessagesModel.userId}, '${chatsMessagesModel.userUuid}')");
    } catch (e) {
      debugPrint('Error on createMessage: $e');
    }
  }
}
