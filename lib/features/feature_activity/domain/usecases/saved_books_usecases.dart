import 'package:ketabto_test/features/feature_activity/domain/repositories/saved_books_repository.dart';

class GetSavedBooksUseCase {
  final SavedBooksRepository repository;

  const GetSavedBooksUseCase(this.repository);

  Future<List<String>> call() {
    return repository.getSavedBookIds();
  }
}

class SaveBookUseCase {
  final SavedBooksRepository repository;

  const SaveBookUseCase(this.repository);

  Future<void> call(String bookId) {
    return repository.saveBook(bookId);
  }
}

class RemoveSavedBookUseCase {
  final SavedBooksRepository repository;

  const RemoveSavedBookUseCase(this.repository);

  Future<void> call(String bookId) {
    return repository.removeBook(bookId);
  }
}


class ClearSavedBooksUseCase {
  final SavedBooksRepository repository;

  const ClearSavedBooksUseCase(this.repository);

  Future<void> call() {
    return repository.clearSavedBooks();
  }
}
