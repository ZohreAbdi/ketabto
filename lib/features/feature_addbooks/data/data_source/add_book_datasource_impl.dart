import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ketabto_test/core/data_source/user_data_source.dart';

import 'package:ketabto_test/core/models/book_model.dart';
import 'package:ketabto_test/features/feature_addbooks/data/data_source/add_book_datasource.dart';

class AddBookRemoteDataSourceImpl implements AddBookRemoteDataSource {
  final UserLocalDataSource localDataSource;

  AddBookRemoteDataSourceImpl(this.localDataSource);
  static const String apiKey = '616bfeb88a3ec1412709f255a44ea7bc';

  @override
  Future<String> uploadImage(File image) async {
    final uri = Uri.parse('https://api.imgbb.com/1/upload?key=$apiKey');

    final request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      return json['data']['url'];
      // یا اگر خواستی:
      // return json['data']['display_url'];
    }

    throw Exception('Image upload failed');
  }

  @override
  Future<void> addBook(BookModel book) async {
    final uri = Uri.parse(
      'https://graveyard-reformer-deceptive.ngrok-free.dev/api/v1/books',
    );

    final body = jsonEncode(book.toJson());

    print('========== ADD BOOK ==========');
    print('URL: $uri');
    print('Headers:');
    print({'Content-Type': 'application/json'});
    print('Body:');
    print(body);

    final user = await localDataSource.getUser();

    if (user == null || user.token.isEmpty) {
      throw Exception('User is not logged in.');
    }

    final token = user?.token ?? '';

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    print('========== RESPONSE ==========');
    print('Status Code: ${response.statusCode}');
    print('Headers: ${response.headers}');
    print('Body: ${response.body}');
    print('==============================');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        'Failed to add book\n'
        'Status: ${response.statusCode}\n'
        'Body: ${response.body}',
      );
    }
  }
}
