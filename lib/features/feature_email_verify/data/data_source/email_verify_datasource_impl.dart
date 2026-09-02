import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ketabto_test/features/feature_email_verify/data/data_source/email_verify_datasource.dart';

class EmailVerificationRemoteDataSourceImpl
    implements EmailVerificationRemoteDataSource {

  static const String _baseUrl =
      'http://graveyard-reformer-deceptive.ngrok-free.dev/api/v1/auth/resend-verification';

  @override
  Future<void> resendVerificationEmail(String email) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
      }),
    );

    final body = jsonDecode(response.body);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(body['message'] ?? 'Failed to resend verification email');
    }
  }
}