import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ketabto_test/core/models/user_model.dart';

class SignupRemoteDataSource {
  static const String _baseUrl =
      'https://graveyard-reformer-deceptive.ngrok-free.dev/api/v1/auth/register';

  Future<Map<String, dynamic>> signup(UserModel user) async {
    final url = Uri.parse(_baseUrl);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toSignupJson()),
      );

      print(response.statusCode);
      print(response.body);

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': body};
      }

      return {'success': false, 'message': body['message']};
    } catch (e) {
      print(e);

      return {
        'success': false,
        'message': 'Could not connect to the server. Check your connection.',
      };
    }
  }
}
