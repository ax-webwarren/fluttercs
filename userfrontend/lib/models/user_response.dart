import 'user.dart'; // Import your existing User model

class UserResponse {
  final bool success;
  final List<User> users;

  UserResponse({required this.success, required this.users});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    var usersList = json['data'] as List;
    List<User> userObjects = usersList.map((i) => User.fromJson(i)).toList();

    return UserResponse(
      success: json['success'],
      users: userObjects,
    );
  }
}