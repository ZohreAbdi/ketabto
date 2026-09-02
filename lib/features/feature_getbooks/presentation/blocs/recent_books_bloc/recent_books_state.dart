part of 'recent_books_bloc.dart';

abstract class RecentBooksState extends Equatable {
  const RecentBooksState();

  @override
  List<Object?> get props => [];
}

class RecentBooksInitial extends RecentBooksState {}

class RecentBooksLoading extends RecentBooksState {}

class RecentBooksLoaded extends RecentBooksState {
  final List<BookEntity> books;

  const RecentBooksLoaded(this.books);

  @override
  List<Object?> get props => [books];
}

class RecentBooksError extends RecentBooksState {
  final String message;

  const RecentBooksError(this.message);

  @override
  List<Object?> get props => [message];
}