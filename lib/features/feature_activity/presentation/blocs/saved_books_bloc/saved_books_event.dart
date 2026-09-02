part of 'saved_books_bloc.dart';

abstract class SavedBooksEvent extends Equatable {
  const SavedBooksEvent();

  @override
  List<Object?> get props => [];
}

class GetSavedBooksEvent extends SavedBooksEvent {
  const GetSavedBooksEvent();
}

class SaveBookEvent extends SavedBooksEvent {
  final String bookId;

  const SaveBookEvent(this.bookId);

  @override
  List<Object?> get props => [bookId];
}

class RemoveSavedBookEvent extends SavedBooksEvent {
  final String bookId;

  const RemoveSavedBookEvent(this.bookId);

  @override
  List<Object?> get props => [bookId];
}

class ClearSavedBooksEvent extends SavedBooksEvent {
  const ClearSavedBooksEvent();
}
