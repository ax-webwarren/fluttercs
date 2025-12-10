import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/user_response.dart';
import '../config/app_config.dart';

// Use 10.0.2.2 if running on Android Emulator and C# backend is on localhost
final String baseUrl = AppConfig.baseUrl; 

class ApiService {
  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final UserResponse userResponse = UserResponse.fromJson(jsonResponse);

      // Return just the nested list of users
      return userResponse.users; 
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) { // 201 Created
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }
  
  Future<bool> updateUser(int id, User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(user.toJson()),
    );
    return response.statusCode == 200; // 204 No Content for successful update
  }

  Future<bool> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    return response.statusCode == 200; // 204 No Content for successful delete
  }
}