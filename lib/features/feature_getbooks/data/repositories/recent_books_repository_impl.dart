import 'package:ketabto_test/core/entities/book_entity.dart';
import 'package:ketabto_test/features/feature_getbooks/data/data_source/recent_books_datasource.dart';
import 'package:ketabto_test/features/feature_getbooks/domain/repositories/recent_books_repository.dart';

class RecentBooksRepositoryImpl implements RecentBooksRepository {
  final RecentBooksLocalDataSource localDataSource;

  const RecentBooksRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<void> addRecentBook(BookEntity book) {
    return localDataSource.addRecentBook(book);
  }

  @override
  Future<void> clearRecentBooks() {
    return localDataSource.clearRecentBooks();
  }

  @override
  Future<List<BookEntity>> getRecentBooks() {
    return localDataSource.getRecentBooks();
  }
}