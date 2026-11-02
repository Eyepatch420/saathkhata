import 'user_model.dart';

// Response from POST /auth/otp/verify
// existingUser=true  → full auth tokens + user
// existingUser=false → signupToken only (no user yet)
class OtpVerifyResponseModel {
  final bool existingUser;
  final UserModel? user;
  final TokensModel? tokens;
  final String? signupToken;

  const OtpVerifyResponseModel({
    required this.existingUser,
    this.user,
    this.tokens,
    this.signupToken,
  });

  factory OtpVerifyResponseModel.fromJson(Map<String, dynamic> json) {
    final existing = json['existingUser'] as bool;
    return OtpVerifyResponseModel(
      existingUser: existing,
      user: existing
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      tokens: existing
          ? TokensModel.fromJson(json['tokens'] as Map<String, dynamic>)
          : null,
      signupToken: existing ? null : json['signupToken'] as String?,
    );
  }
}

class TokensModel {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  const TokensModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory TokensModel.fromJson(Map<String, dynamic> json) => TokensModel(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
        expiresIn: json['expiresIn'] as int,
      );
}

class AuthResponseModel {
  final UserModel user;
  final TokensModel tokens;

  const AuthResponseModel({required this.user, required this.tokens});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      AuthResponseModel(
        user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
        tokens: TokensModel.fromJson(json['tokens'] as Map<String, dynamic>),
      );
}
