part of 'addbook_bloc.dart';

abstract class AddBookEvent extends Equatable {
  const AddBookEvent();

  @override
  List<Object?> get props => [];
}

/// Merges new values into the current draft. Pass only the fields that
/// changed — copyWith keeps everything else as-is.
class AddBookDraftUpdated extends AddBookEvent {
  final AddBookDraft draft;
  const AddBookDraftUpdated(this.draft);

  @override
  List<Object?> get props => [draft];
}

/// Fired on the final step. Uses whatever is already in the bloc's draft —
/// no need to pass data again.
class AddBookSubmitted extends AddBookEvent {
  const AddBookSubmitted();
}

/// Resets the bloc back to an empty draft.
class AddBookReset extends AddBookEvent {
  const AddBookReset();
}