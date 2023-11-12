class ChatsModel {
  ChatsModel({
    this.id,
    required this.lastMessage,
    required this.messageType,
    this.createdAt,
  });

  /// User ID of the chat
  final int? id;

  /// Username of the profile
  final String lastMessage;

  /// The type of message written in the chat
  final String messageType;

  /// Date and time when the profile was created
  final DateTime? createdAt;

  ChatsModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        lastMessage = map['last_message'],
        messageType = map['message_type'],
        createdAt = DateTime.parse(map['updated_at']);

  Map<String, dynamic> toJson() => {
        "last_message": lastMessage,
        "message_type": messageType,
      };
}
