class ProfileDomain {
  late int id;
  late String userId;
  late String username;
  late DateTime createdAt;

  ProfileDomain({
    required this.id,
    required this.userId,
    required this.username,
    required this.createdAt,
  });

  ProfileDomain.initData({
    int? id,
    String? userId,
    String? username,
    DateTime? createdAt,
  })  : id = id ?? 0,
        userId = userId ?? '',
        username = username ?? '',
        createdAt = createdAt ?? DateTime.now();

  ProfileDomain.empty();

  ProfileDomain copyWith({
    int? id,
    String? userId,
    String? username,
    DateTime? createdAt,
  }) {
    return ProfileDomain(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return "ProfileDomain:{ id: $id, userId: $userId ,username:$username, createdAt:$createdAt}";
  }
}
