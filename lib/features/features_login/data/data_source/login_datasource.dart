import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ketabto_test/core/models/user_model.dart';

class LoginRemoteDataSource {
  static const String _baseUrl =
      'https://graveyard-reformer-deceptive.ngrok-free.dev/api/v1/auth/login';

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.trim().toLowerCase(),
          'password': password,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response: ${response.body}');

      final body =
    response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(body);
      }

      throw Exception(body['message'] ?? 'Login failed.');
    } on http.ClientException {
      throw Exception('Could not connect to the server.');
    } on FormatException {
      throw Exception('Invalid response from server.');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Could not connect to the server.');
    }
  }
}
