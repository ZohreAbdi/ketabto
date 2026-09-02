part of 'search_book_bloc.dart';

abstract class SearchBooksState extends Equatable {
  const SearchBooksState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchBooksState {
  const SearchInitial();
}

class SearchLoaded extends SearchBooksState {
  final List<BookEntity> results;
  final String query;

  const SearchLoaded({
    required this.results,
    required this.query,
  });

  @override
  List<Object?> get props => [results, query];
}
