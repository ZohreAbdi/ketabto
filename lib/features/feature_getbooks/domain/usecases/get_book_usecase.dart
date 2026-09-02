import 'package:ketabto_test/core/entities/book_entity.dart';
import 'package:ketabto_test/features/feature_getbooks/domain/repositories/get_book_repository.dart';

class GetBooksUseCase {
  final BookRepository repository;

  const GetBooksUseCase(this.repository);

  Future<List<BookEntity>> call() {
    return repository.getBooks();
  }
}