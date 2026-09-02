import 'dart:io';

import '../repositories/add_book_repository.dart';

class UploadImageUseCase {
  final AddBookRepository repository;

  UploadImageUseCase(this.repository);

  Future<String> call(File image) {
    return repository.uploadImage(image);
  }
}