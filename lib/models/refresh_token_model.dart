class RefreshTokenModel {
  final String token;
  final String refreshToken;

  RefreshTokenModel({required this.token, required this.refreshToken});

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenModel(
      token: json['AccessToken'],
      refreshToken: json['RefreshToken'],
    );
  }
}
