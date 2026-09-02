part of 'recent_books_bloc.dart';

abstract class RecentBooksEvent extends Equatable {
  const RecentBooksEvent();

  @override
  List<Object?> get props => [];
}

class GetRecentBooksEvent extends RecentBooksEvent {
  const GetRecentBooksEvent();
  
}

class AddRecentBookEvent extends RecentBooksEvent {
  final BookEntity book;

  const AddRecentBookEvent(this.book);

  @override
  List<Object?> get props => [book];
}

class ClearRecentBooksEvent extends RecentBooksEvent {
  const ClearRecentBooksEvent();
}