import 'dart:io';

import 'package:ketabto_test/core/models/book_model.dart';

abstract class AddBookRemoteDataSource {
  Future<String> uploadImage(File image);

  Future<void> addBook(BookModel book);
}