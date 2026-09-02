import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class ForgotPasswordRemoteDataSource {
  Future<void> forgotPassword(String email);
}

class ForgotPasswordRemoteDataSourceImpl
    implements ForgotPasswordRemoteDataSource {
  final http.Client client;

  ForgotPasswordRemoteDataSourceImpl(this.client);

  @override
  Future<void> forgotPassword(String email) async {
    final response = await client.post(
      Uri.parse('YOUR_BASE_URL/api/v1/auth/forgot-password'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send reset password email');
    }
  }
}