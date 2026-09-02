import 'package:hive/hive.dart';

abstract class SavedBooksLocalDataSource {
  Future<List<String>> getSavedBookIds();

  Future<void> saveBook(String bookId);

  Future<void> removeBook(String bookId);

  Future<void> clearSavedBooks();
}

class SavedBooksLocalDataSourceImpl
    implements SavedBooksLocalDataSource {
  static const String boxName = 'saved_books';
  static const String key = 'book_ids';

  Future<Box> get _box async => Hive.openBox(boxName);

  @override
  Future<List<String>> getSavedBookIds() async {
    final box = await _box;

    final storedIds = box.get(
      key,
      defaultValue: <String>[],
    );

    return List<String>.from(storedIds);
  }

  @override
  Future<void> saveBook(String bookId) async {
    final box = await _box;

    final ids = await getSavedBookIds();

    if (ids.contains(bookId)) {
      return;
    }

    ids.add(bookId);

    await box.put(key, ids);
  }

  @override
  Future<void> removeBook(String bookId) async {
    final box = await _box;

    final ids = await getSavedBookIds();

    ids.remove(bookId);

    await box.put(key, ids);
  }

  @override
  Future<void> clearSavedBooks() async {
    final box = await _box;

    await box.delete(key);
  }
}