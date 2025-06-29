class AppUser {
  final String email;
  final Map<String, dynamic>? device;
  final List<String> quizzes; // quiz IDs created by this user
  final List<String> pastResults; // result IDs for completed quizzes

  AppUser({
    required this.email,
    this.device,
    this.quizzes = const [],
    this.pastResults = const [],
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      email: json['email'] as String,
      device: json['device'] as Map<String, dynamic>?,
      quizzes: (json['quizzes'] as List<dynamic>?)?.cast<String>() ?? [],
      pastResults:
          (json['pastResults'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'device': device,
      'quizzes': quizzes,
      'pastResults': pastResults,
    };
  }

  AppUser copyWith({
    String? email,
    Map<String, dynamic>? device,
    List<String>? quizzes,
    List<String>? pastResults,
  }) {
    return AppUser(
      email: email ?? this.email,
      device: device ?? this.device,
      quizzes: quizzes ?? this.quizzes,
      pastResults: pastResults ?? this.pastResults,
    );
  }
}
