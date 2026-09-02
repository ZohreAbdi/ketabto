import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ketabto_test/core/entities/book_entity.dart';
import 'package:ketabto_test/features/feature_addbooks/domain/usecases/add_book_upload_image_usecase.dart';
import 'package:ketabto_test/features/feature_addbooks/domain/usecases/add_book_usecase.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/models/add_book_draft.dart';

part 'addbook_event.dart';
part 'addbook_state.dart';

class AddBookBloc extends Bloc<AddBookEvent, AddBookState> {
  final UploadImageUseCase uploadImageUseCase;
  final AddBookUseCase addBookUseCase;

  /// Owner info is fixed for the lifetime of one add-book flow, so it's
  /// injected here rather than carried in the draft.
  final String ownerId;
  final String ownerName;

  AddBookBloc({
    required this.uploadImageUseCase,
    required this.addBookUseCase,
    required this.ownerId,
    required this.ownerName,
  }) : super(const AddBookState()) {
    on<AddBookDraftUpdated>(_onDraftUpdated);
    on<AddBookSubmitted>(_onSubmitted);
    on<AddBookReset>((event, emit) => emit(const AddBookState()));
  }

  void _onDraftUpdated(AddBookDraftUpdated event, Emitter<AddBookState> emit) {
    emit(state.copyWith(draft: event.draft));
  }

  Future<void> _onSubmitted(
    AddBookSubmitted event,
    Emitter<AddBookState> emit,
  ) async {
    final draft = state.draft;

    // Should never happen if the UI validates each step, but guards the
    // bloc against being driven incorrectly.
    if (draft.image == null ||
        draft.name == null ||
        draft.writerName == null ||
        draft.pages == null ||
        draft.category == null ||
        draft.description == null ||
        draft.price == null) {
      emit(state.copyWith(
        status: AddBookStatus.failure,
        errorMessage: 'Please complete every step before submitting.',
      ));
      return;
    }

    try {
      // ── Step 1: upload the cover photo ────────────────────────────
      emit(state.copyWith(status: AddBookStatus.uploading));
      final imageUrl = await uploadImageUseCase(draft.image!);

      final book = BookEntity(
        id: '',
        category: draft.category!.name,
        name: draft.name!,
        imageUrl: imageUrl,
        writerName: draft.writerName!,
        price: draft.price!,
        pages: draft.pages!,
        description: draft.description!,
        ownerId: ownerId,
        ownerName: ownerName,
      );

      // ── Step 2: publish the book ───────────────────────────────────
      emit(state.copyWith(status: AddBookStatus.publishing));
      await addBookUseCase(book);

      emit(state.copyWith(
        status: AddBookStatus.success,
        draft: draft.copyWith(imageUrl: imageUrl),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AddBookStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}