class UserModel {
  final int userId;
  final String name;
  final String mobileNumber;
  final String userToken;
  final String userType;

  UserModel({
    required this.userId,
    required this.name,
    required this.mobileNumber,
    required this.userToken,
    required this.userType,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? 0,
      name: json['name'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      userToken: json['userToken'] ?? '',
      userType: json['userType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'mobileNumber': mobileNumber,
      'userToken': userToken,
      'userType': userType,
    };
  }
}

class LoginResponse {
  final String status;
  final String message;
  final List<UserModel> userDetails;

  LoginResponse({
    required this.status,
    required this.message,
    required this.userDetails,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      userDetails: (json['userDetails'] as List<dynamic>?)
          ?.map((user) => UserModel.fromJson(user))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'userDetails': userDetails.map((user) => user.toJson()).toList(),
    };
  }

  bool get isSuccess => status.toLowerCase() == 'success';
}
