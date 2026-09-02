import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ketabto_test/core/entities/book_entity.dart';

part 'search_book_event.dart';
part 'search_book_state.dart';

class SearchBooksBloc extends Bloc<SearchBooksEvent, SearchBooksState> {
  SearchBooksBloc() : super(const SearchInitial()) {
    on<SearchBooks>(_onSearchBooks);
    on<ClearSearchResults>((event, emit) {
      emit(SearchInitial());
    });
  }

  void _onSearchBooks(SearchBooks event, Emitter<SearchBooksState> emit) {
    final query = event.query.trim().toLowerCase();

    if (query.isEmpty) {
      emit(const SearchLoaded(results: [], query: ''));
      return;
    }

    final results = event.books.where((book) {
      final title = book.name.toLowerCase();

      return title.contains(query);
    }).toList();

    emit(SearchLoaded(results: results, query: event.query));
  }
}
