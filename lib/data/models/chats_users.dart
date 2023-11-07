class ChatsUsersModel {
  ChatsUsersModel({
    required this.id,
    required this.chatId,
    required this.userId,
    required this.createdAt,
  });

  /// ID of the chat-user table
  final int id;

  /// ID of the chat
  final int chatId;

  /// ID of the user who sent the message
  final int userId;

  /// Date and time when the profile was created
  final DateTime createdAt;

  ChatsUsersModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        chatId = map['chat_id'],
        userId = map['user_id'],
        createdAt = DateTime.parse(map['created_at']);
}
