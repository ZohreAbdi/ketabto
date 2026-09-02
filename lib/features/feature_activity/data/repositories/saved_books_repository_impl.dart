import 'package:ketabto_test/features/feature_activity/data/data_source/saved_books_datasource.dart';
import 'package:ketabto_test/features/feature_activity/domain/repositories/saved_books_repository.dart';


class SavedBooksRepositoryImpl
    implements SavedBooksRepository {
  final SavedBooksLocalDataSource localDataSource;

  const SavedBooksRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<List<String>> getSavedBookIds() {
    return localDataSource.getSavedBookIds();
  }

  @override
  Future<void> saveBook(String bookId) {
    return localDataSource.saveBook(bookId);
  }

  @override
  Future<void> removeBook(String bookId) {
    return localDataSource.removeBook(bookId);
  }

  @override
  Future<void> clearSavedBooks() {
    return localDataSource.clearSavedBooks();
  }
}