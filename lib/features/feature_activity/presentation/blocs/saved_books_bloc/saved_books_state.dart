part of 'saved_books_bloc.dart';

abstract class SavedBooksState extends Equatable {
  const SavedBooksState();

  @override
  List<Object?> get props => [];
}

class SavedBooksInitial extends SavedBooksState {
  const SavedBooksInitial();
}

class SavedBooksLoading extends SavedBooksState {
  const SavedBooksLoading();
}

class SavedBooksLoaded extends SavedBooksState {
  final List<String> bookIds;

  const SavedBooksLoaded(this.bookIds);

  @override
  List<Object?> get props => [bookIds];
}

class SavedBooksError extends SavedBooksState {
  final String message;

  const SavedBooksError(this.message);

  @override
  List<Object?> get props => [message];
}
