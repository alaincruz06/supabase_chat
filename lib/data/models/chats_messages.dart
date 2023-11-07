import 'package:json_annotation/json_annotation.dart';

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
  @JsonKey(includeIfNull: false)
  final int? id;

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
}
