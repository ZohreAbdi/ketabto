import 'package:ketabto_test/core/entities/book_entity.dart';
import 'package:ketabto_test/features/feature_getbooks/domain/repositories/recent_books_repository.dart';

class AddRecentBookUseCase {
  final RecentBooksRepository repository;

  const AddRecentBookUseCase(this.repository);

  Future<void> call(BookEntity book) {
    return repository.addRecentBook(book);
  }
}