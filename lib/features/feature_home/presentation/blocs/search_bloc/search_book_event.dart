part of 'search_book_bloc.dart';


abstract class SearchBooksEvent extends Equatable {
  const SearchBooksEvent();

  @override
  List<Object?> get props => [];
}

class SearchBooks extends SearchBooksEvent {
  final String query;
  final List<BookEntity> books;

  const SearchBooks({
    required this.query,
    required this.books,
  });

  @override
  List<Object?> get props => [query, books];
}

class ClearSearchResults extends SearchBooksEvent {
  const ClearSearchResults();
}