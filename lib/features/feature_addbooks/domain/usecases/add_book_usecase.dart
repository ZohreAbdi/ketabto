import 'package:ketabto_test/core/entities/book_entity.dart';

import '../repositories/add_book_repository.dart';

class AddBookUseCase {
  final AddBookRepository repository;

  AddBookUseCase(this.repository);

  Future<void> call(BookEntity book) {
    return repository.addBook(book);
  }
}