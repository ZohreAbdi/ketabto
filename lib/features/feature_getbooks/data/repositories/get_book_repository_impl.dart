import 'package:ketabto_test/core/entities/book_entity.dart';
import 'package:ketabto_test/features/feature_getbooks/data/data_source/get_book_datasource.dart';
import 'package:ketabto_test/features/feature_getbooks/domain/repositories/get_book_repository.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDataSource remoteDataSource;

  const BookRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<BookEntity>> getBooks() {
    return remoteDataSource.getBooks();
  }
}