class AuthEntity {
  final String userId;
  final String email;
  final String? name;
  final String? role;
  final String? accessToken;
  final String? refreshToken;
  const AuthEntity({
    required this.userId,
    required this.email,
    this.name,
    this.role,
    this.accessToken,
    this.refreshToken,
  });
}
