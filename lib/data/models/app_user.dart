/// App user model — replaces Firebase User for auth state.
/// Contains user info from our backend, not Firebase.
class AppUser {
  final int id;
  final String? email;
  final String? displayName;
  final String? avatarUrl;
  final bool isAnonymous;

  const AppUser({
    required this.id,
    this.email,
    this.displayName,
    this.avatarUrl,
    this.isAnonymous = true,
  });

  bool get hasGoogleLinked => !isAnonymous && email != null;

  /// Create from backend JSON response
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as int,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      isAnonymous: json['isAnonymous'] as bool? ?? true,
    );
  }

  AppUser copyWith({
    int? id,
    String? email,
    String? displayName,
    String? avatarUrl,
    bool? isAnonymous,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }
}
