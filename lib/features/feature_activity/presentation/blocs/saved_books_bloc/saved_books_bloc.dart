import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ketabto_test/features/feature_activity/domain/usecases/saved_books_usecases.dart';

part 'saved_books_event.dart';
part 'saved_books_state.dart';

class SavedBooksBloc
    extends Bloc<SavedBooksEvent, SavedBooksState> {
  final GetSavedBooksUseCase getSavedBooksUseCase;
  final SaveBookUseCase saveBookUseCase;
  final RemoveSavedBookUseCase removeSavedBookUseCase;
  final ClearSavedBooksUseCase clearSavedBooksUseCase;

  SavedBooksBloc({
    required this.getSavedBooksUseCase,
    required this.saveBookUseCase,
    required this.removeSavedBookUseCase,
    required this.clearSavedBooksUseCase,
  }) : super(const SavedBooksInitial()) {
    on<GetSavedBooksEvent>(_onGetSavedBooks);
    on<SaveBookEvent>(_onSaveBook);
    on<RemoveSavedBookEvent>(_onRemoveSavedBook);
    on<ClearSavedBooksEvent>(_onClearSavedBooks);
  }

  Future<void> _onGetSavedBooks(
    GetSavedBooksEvent event,
    Emitter<SavedBooksState> emit,
  ) async {
    emit(const SavedBooksLoading());

    try {
      final ids = await getSavedBooksUseCase();

      emit(SavedBooksLoaded(ids));
    } catch (e) {
      emit(SavedBooksError(e.toString()));
    }
  }

  Future<void> _onSaveBook(
    SaveBookEvent event,
    Emitter<SavedBooksState> emit,
  ) async {
    try {
      await saveBookUseCase(event.bookId);

      final ids = await getSavedBooksUseCase();

      emit(SavedBooksLoaded(ids));
    } catch (e) {
      emit(SavedBooksError(e.toString()));
    }
  }

  Future<void> _onRemoveSavedBook(
    RemoveSavedBookEvent event,
    Emitter<SavedBooksState> emit,
  ) async {
    try {
      await removeSavedBookUseCase(event.bookId);

      final ids = await getSavedBooksUseCase();

      emit(SavedBooksLoaded(ids));
    } catch (e) {
      emit(SavedBooksError(e.toString()));
    }
  }

  Future<void> _onClearSavedBooks(
    ClearSavedBooksEvent event,
    Emitter<SavedBooksState> emit,
  ) async {
    try {
      await clearSavedBooksUseCase();

      emit(const SavedBooksLoaded([]));
    } catch (e) {
      emit(SavedBooksError(e.toString()));
    }
  }
}
