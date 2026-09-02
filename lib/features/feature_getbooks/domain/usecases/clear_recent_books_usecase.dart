import 'package:ketabto_test/features/feature_getbooks/domain/repositories/recent_books_repository.dart';

class ClearRecentBooksUseCase {
  final RecentBooksRepository repository;

  const ClearRecentBooksUseCase(this.repository);

  Future<void> call() {
    return repository.clearRecentBooks();
  }
}