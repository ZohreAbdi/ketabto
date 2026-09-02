import 'package:ketabto_test/core/entities/book_entity.dart';

abstract class RecentBooksRepository {
  Future<List<BookEntity>> getRecentBooks();

  Future<void> addRecentBook(BookEntity book);

  Future<void> clearRecentBooks();
}