class ClipTagUser {
  final String username;
  final String email;
  final bool isModerator;

  ClipTagUser({
    required this.username,
    required this.email,
    required this.isModerator,
  });

  factory ClipTagUser.fromJson(Map<String, dynamic> json) => ClipTagUser(
        username: json['username'],
        email: json['email'],
        isModerator: json['isModerator'],
      );
}
