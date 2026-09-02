import 'package:ketabto_test/core/entities/book_entity.dart';
import 'package:ketabto_test/features/feature_getbooks/domain/repositories/recent_books_repository.dart';

class GetRecentBooksUseCase {
  final RecentBooksRepository repository;

  const GetRecentBooksUseCase(this.repository);

  Future<List<BookEntity>> call() {
    return repository.getRecentBooks();
  }
}