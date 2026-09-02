part of 'get_books_bloc.dart';

abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object?> get props => [];
}

class BookInitial extends BookState {
  const BookInitial();
}

class BookLoading extends BookState {
  const BookLoading();
}

class BookLoaded extends BookState {
  final List<BookEntity> books;
  const BookLoaded(this.books);

  @override
  List<Object?> get props => [books];
}

class BookError extends BookState {
  final String message;
  const BookError(this.message);

  @override
  List<Object?> get props => [message];
}