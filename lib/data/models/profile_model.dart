class ProfileModel {
  ProfileModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.createdAt,
  });

  /// User ID of the profile
  final int id;

  /// User uuID (schema: auth-users table) of the profile
  final String userId;

  /// Username of the profile
  final String username;

  /// Date and time when the profile was created
  final DateTime createdAt;

  ProfileModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        userId = map['user_id'],
        username = map['username'],
        createdAt = DateTime.parse(map['created_at']);
}
