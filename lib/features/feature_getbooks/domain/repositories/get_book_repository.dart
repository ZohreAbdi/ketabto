import 'package:ketabto_test/core/entities/book_entity.dart';

abstract class BookRepository {
  Future<List<BookEntity>> getBooks();
}