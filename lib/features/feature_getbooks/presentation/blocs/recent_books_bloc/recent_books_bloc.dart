import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ketabto_test/core/entities/book_entity.dart';
import 'package:ketabto_test/features/feature_getbooks/domain/usecases/add_recent_books_usecase.dart';
import 'package:ketabto_test/features/feature_getbooks/domain/usecases/clear_recent_books_usecase.dart';
import 'package:ketabto_test/features/feature_getbooks/domain/usecases/get_recent_books_usecase.dart';

part 'recent_books_event.dart';
part 'recent_books_state.dart';

class RecentBooksBloc extends Bloc<RecentBooksEvent, RecentBooksState> {
  final GetRecentBooksUseCase getRecentBooksUseCase;
  final AddRecentBookUseCase addRecentBookUseCase;
  final ClearRecentBooksUseCase clearRecentBooksUseCase;

  RecentBooksBloc({
    required this.getRecentBooksUseCase,
    required this.addRecentBookUseCase,
    required this.clearRecentBooksUseCase,
  }) : super(RecentBooksInitial()) {
    on<GetRecentBooksEvent>(_onGetRecentBooks);
    on<AddRecentBookEvent>(_onAddRecentBook);
    on<ClearRecentBooksEvent>(_onClearRecentBooks);
  }

  Future<void> _onGetRecentBooks(
    GetRecentBooksEvent event,
    Emitter<RecentBooksState> emit,
  ) async {
    emit(RecentBooksLoading());

    try {
      final books = await getRecentBooksUseCase();
      print("GetRecentBooksEvent");
      emit(RecentBooksLoaded(books));
      print(books.length);
      print(books);
    } catch (e) {
      emit(RecentBooksError(e.toString()));
    }
  }

 Future<void> _onAddRecentBook(
  AddRecentBookEvent event,
  Emitter<RecentBooksState> emit,
) async {
  try {
    print("ADD => ${event.book.name}");

    await addRecentBookUseCase(event.book);

    final books = await getRecentBooksUseCase();

    print("RECENT COUNT => ${books.length}");
    print(books.map((e) => e.name).toList());

    emit(RecentBooksLoaded(books));
  } catch (e) {
    print(e);
    emit(RecentBooksError(e.toString()));
  }
}

  Future<void> _onClearRecentBooks(
    ClearRecentBooksEvent event,
    Emitter<RecentBooksState> emit,
  ) async {
    try {
      await clearRecentBooksUseCase();

      emit(const RecentBooksLoaded([]));
    } catch (e) {
      emit(RecentBooksError(e.toString()));
    }
  }
}
