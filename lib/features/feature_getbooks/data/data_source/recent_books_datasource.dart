import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:ketabto_test/core/models/book_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ketabto_test/core/entities/book_entity.dart';

abstract class RecentBooksLocalDataSource {
  Future<List<BookEntity>> getRecentBooks();

  Future<void> addRecentBook(BookEntity book);

  Future<void> clearRecentBooks();
}

class RecentBooksLocalDataSourceImpl
    implements RecentBooksLocalDataSource {
  static const String boxName = 'recent_books';
  static const String key = 'books';
  static const int maxRecentBooks = 10;

  Future<Box> get _box async => await Hive.openBox(boxName);

  @override
  Future<void> addRecentBook(BookEntity book) async {
    final box = await _box;

    final List<dynamic> storedList = box.get(key, defaultValue: []);

    final books = storedList
        .map((e) => BookModel.fromJson(
              Map<String, dynamic>.from(jsonDecode(e)),
            ))
        .toList();
        print('NEW BOOK ID => ${book.id}');
print(
  'EXISTING IDS => ${books.map((e) => e.id).toList()}',
);
    books.removeWhere((element) => element.id == book.id);

    books.insert(0, BookModel.fromEntity(book));

    if (books.length > maxRecentBooks) {
      books.removeLast();
    }

    final encoded = books
        .map((e) => jsonEncode(e.toLocalJson()))
        .toList();

    await box.put(key, encoded);
  }

  @override
  Future<void> clearRecentBooks() async {
    final box = await _box;
    await box.delete(key);
  }

  @override
  Future<List<BookEntity>> getRecentBooks() async {
    final box = await _box;

    final List<dynamic> storedList = box.get(key, defaultValue: []);

    return storedList
        .map(
          (e) => BookModel.fromJson(
            Map<String, dynamic>.from(jsonDecode(e)),
          ),
        )
        .toList();
  }
}