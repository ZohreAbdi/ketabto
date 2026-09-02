import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ketabto_test/core/entities/book_entity.dart';
import 'package:ketabto_test/features/feature_getbooks/domain/usecases/get_book_usecase.dart';

part 'get_books_event.dart';
part 'get_books_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final GetBooksUseCase getBooksUseCase;
 
  BookBloc({required this.getBooksUseCase}) : super(const BookInitial()) {
    on<GetBooksEvent>(_onGetBooks);
  }
 
  Future<void> _onGetBooks(
    GetBooksEvent event,
    Emitter<BookState> emit,
  ) async {
    emit(const BookLoading());
    try {
      final books = await getBooksUseCase();
      emit(BookLoaded(books));
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }

  
}