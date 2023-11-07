/* class ChatMessagesInfoViewModel {
  ChatMessagesInfoViewModel({
    required this.chatId,
    required this.username,
    required this.userId,
    required this.message,
    required this.messageType,
    required this.createdAt,
  });

  /// ID of the chat
  final int chatId;

  /// User name of the user sending the message
  final String username;

  /// User ID of the user sending the message
  final String userId;

  /// The message written in the chat
  final String message;

  /// The type of message written in the chat
  final String messageType;

  /// Date and time when the message was written in the chat
  final DateTime createdAt;

  ChatMessagesInfoViewModel.fromMap(Map<String, dynamic> map)
      : chatId = map['chat_id'],
        userId = map['user_id'],
        username = map['username'],
        message = map['message'],
        messageType = map['message_type'],
        createdAt = DateTime.parse(map['created_at']);
}
 */