abstract class SavedBooksRepository {
  Future<List<String>> getSavedBookIds();

  Future<void> saveBook(String bookId);

  Future<void> removeBook(String bookId);

  Future<void> clearSavedBooks();
}