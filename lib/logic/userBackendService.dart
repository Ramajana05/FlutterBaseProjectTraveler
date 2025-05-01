// user_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user.dart';

class UserBackendService {
  final String baseUrl;

  UserBackendService({required this.baseUrl});

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

  Future<bool> checkUsernameExists(String username) async {
    try {
      final baseUrl = 'http://192.168.0.122:3000';
      final url = '$baseUrl/users/checkUsernameExists?username=$username';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['exists'];
      } else {
        throw Exception(
            'Failed to check username. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error in checkUsernameExists: $error');
      throw Exception('Failed to check username: $error');
    }
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      final baseUrl = 'http://192.168.0.122:3000';
      final url = '$baseUrl/users/checkEmailExists?email=$email';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['exists'];
      } else {
        throw Exception(
            'Failed to check email. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error in checkEmailExists: $error');
      throw Exception('Failed to check email: $error');
    }
  }

  Future<User> createUser(
    String name,
    String email,
    String password,
    String color,
    double currentLatitude,
    double currentLongitude,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': name,
        'email': email,
        'password': password,
        'color': color,
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

  Future<void> updateUser(int id, String name, String email) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
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

  Future<User?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data);
      } else if (response.statusCode == 401) {
        return null;
      } else {
        throw Exception('Failed to log in');
      }
    } catch (error) {
      print('Error in login: $error');
      return null;
    }
  }

  Future<String> fetchUserIdByUsername(String username) async {
    final response =
        await http.get(Uri.parse('$baseUrl/userId?username=$username'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['userId'].toString();
    } else {
      throw Exception('Failed to load user ID');
    }
  }

  Future<List<Map<String, dynamic>>> fetchLocations(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/locations/$userId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load locations');
    }
  }
}
