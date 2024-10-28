class AuthResponse {
  final String authorizationUrl;
  final String accessCode;
  final String reference;

  AuthResponse({
    required this.authorizationUrl,
    required this.accessCode,
    required this.reference,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      authorizationUrl: json['authorization_url'],
      accessCode: json['access_code'],
      reference: json['reference'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorization_url': authorizationUrl,
      'access_code': accessCode,
      'reference': reference,
    };
  }
}
