/* class MessageDomain {
  late String id;
  late String profileId;
  late String content;
  late DateTime createdAt;
  late bool isMine;

  MessageDomain({
    required this.id,
    required this.profileId,
    required this.content,
    required this.createdAt,
    required this.isMine,
  });

  MessageDomain.initData({
    String? id,
    String? profileId,
    String? content,
    DateTime? createdAt,
    bool? isMine,
  })  : id = id ?? '',
        profileId = profileId ?? '',
        content = content ?? '',
        createdAt = createdAt ?? DateTime.now(),
        isMine = isMine ?? false;

  MessageDomain.empty();

  MessageDomain copyWith({
    String? id,
    String? profileId,
    String? content,
    DateTime? createdAt,
    bool? isMine,
  }) {
    return MessageDomain(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isMine: isMine ?? this.isMine,
    );
  }

  @override
  String toString() {
    return "MessageDomain:{ id: $id, profileId:$profileId, content:$content, createdAt:$createdAt, isMine:$isMine}";
  }
}
 */