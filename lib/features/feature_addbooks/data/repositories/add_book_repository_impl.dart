import 'dart:io';

import 'package:ketabto_test/core/entities/book_entity.dart';
import 'package:ketabto_test/core/models/book_model.dart';
import 'package:ketabto_test/features/feature_addbooks/data/data_source/add_book_datasource.dart';

import '../../domain/repositories/add_book_repository.dart';

class AddBookRepositoryImpl implements AddBookRepository {
  final AddBookRemoteDataSource remoteDataSource;

  AddBookRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addBook(BookEntity book) async {
    final model = BookModel.fromEntity(book);

    await remoteDataSource.addBook(model);
  }

  @override
  Future<String> uploadImage(File image) async {
    return await remoteDataSource.uploadImage(image);
  }
  
  
}