part of 'addbook_bloc.dart';

enum AddBookStatus { initial, uploading, publishing, success, failure }

class AddBookState extends Equatable {
  final AddBookDraft draft;
  final AddBookStatus status;
  final String? errorMessage;

  const AddBookState({
    this.draft = const AddBookDraft(),
    this.status = AddBookStatus.initial,
    this.errorMessage,
  });

  bool get isLoading =>
      status == AddBookStatus.uploading || status == AddBookStatus.publishing;

  /// Text shown above the action button while submitting.
  String get loadingMessage => switch (status) {
        AddBookStatus.uploading => 'Uploading photo…',
        AddBookStatus.publishing => 'Publishing your book…',
        _ => '',
      };

  AddBookState copyWith({
    AddBookDraft? draft,
    AddBookStatus? status,
    String? errorMessage,
  }) {
    return AddBookState(
      draft: draft ?? this.draft,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [draft, status, errorMessage];
}