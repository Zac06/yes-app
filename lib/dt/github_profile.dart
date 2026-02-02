class GithubProfile {
  final String avatarUrl;
  final String name;
  final String profileUrl;
  final String website;
  final String username;

  GithubProfile({
    required this.avatarUrl,
    required this.name,
    required this.profileUrl,
    required this.website,
    required this.username
  });

  factory GithubProfile.fromJson(Map<String, dynamic> json) {
    return GithubProfile(
      avatarUrl: json['avatar_url'],
      name: json['name'] ?? 'Unknown',
      profileUrl: json['html_url'],
      website: json['blog'] ?? '',
      username: json['login'] ?? '',
    );
  }
}
