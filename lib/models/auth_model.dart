class AuthResponse {
  final bool success;
  final String message;
  final AuthData? data;

  AuthResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    var data = json['data'];
    AuthData? reqData;
    if (data != null) {
      reqData = AuthData.fromJson(json['data']);
    } else {
      reqData = null;
    }
    return AuthResponse(
      success: json['success'],
      message: json['message'],
      data: reqData,
    );
  }
}

class AuthData {
  final String? token;
  final String? fullname;

  AuthData({
    required this.token,
    required this.fullname,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      token: json['token'],
      fullname: json['fullname'],
    );
  }
}

class AuthRequest {
  final String username;
  final String password;
  final String company;

  AuthRequest({
    required this.username,
    required this.password,
    required this.company,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "company": company,
    };
  }
}
