class ChatSummaryViewModel {
  ChatSummaryViewModel({
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
  final String lastMessage;

  /// The type of message written in the chat
  final String messageType;

  /// Date and time when the last message written in the chat was created
  final DateTime updatedAt;

  ChatSummaryViewModel.fromMap(Map<String, dynamic> map)
      : chatId = map['chat_id'],
        userIds = map['user_ids'].cast<String>(),
        usernames = map['usernames'].cast<String>(),
        lastMessage = map['last_message'],
        messageType = map['message_type'],
        updatedAt = DateTime.parse(map['updated_at']);
}
