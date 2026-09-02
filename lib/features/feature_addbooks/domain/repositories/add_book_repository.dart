import 'dart:io';

import 'package:ketabto_test/core/entities/book_entity.dart';

abstract class AddBookRepository {
  Future<String> uploadImage(File image);

  Future<void> addBook(BookEntity book);
}