import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user.dart';

class UserService {
  final String baseUrl;

  UserService({required this.baseUrl});

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<User> users =
          body.map((dynamic item) => User.fromJson(item)).toList();
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> getUserById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$id'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<User> createUser({
    required String username,
    required String email,
    required String password,
    String? color,
    DateTime? lastTimeOnline,
    required bool visibility,
    double? currentLatitude,
    double? currentLongitude,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'color': color,
        'lastTimeOnline': lastTimeOnline?.toIso8601String(),
        'visibility': visibility,
        'currentLatitude': currentLatitude,
        'currentLongitude': currentLongitude,
      }),
    );

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<void> updateUser({
    required int id,
    String? username,
    String? email,
    String? password,
    String? color,
    DateTime? lastTimeOnline,
    bool? visibility,
    double? currentLatitude,
    double? currentLongitude,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        if (username != null) 'username': username,
        if (email != null) 'email': email,
        if (password != null) 'password': password,
        if (color != null) 'color': color,
        if (lastTimeOnline != null)
          'lastTimeOnline': lastTimeOnline.toIso8601String(),
        if (visibility != null) 'visibility': visibility,
        if (currentLatitude != null) 'currentLatitude': currentLatitude,
        if (currentLongitude != null) 'currentLongitude': currentLongitude,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }
}
