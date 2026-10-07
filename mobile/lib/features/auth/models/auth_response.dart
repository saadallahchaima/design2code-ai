import 'user_model.dart';

class AuthResponse {
  final String token;
  final String type;
  final UserModel user;

  AuthResponse({
    required this.token,
    required this.type,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      type: json['type'] ?? 'Bearer',
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
