import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ketabto_test/features/feature_home/domain/repositories/recent_search_repository.dart';

part 'recent_search_event.dart';
part 'recent_search_state.dart';

class RecentSearchBloc
    extends Bloc<RecentSearchEvent, RecentSearchState> {
  final RecentSearchRepository repository;

  RecentSearchBloc({
    required this.repository,
  }) : super(const RecentSearchInitial()) {
    on<LoadRecentSearches>(_onLoad);
    on<AddRecentSearch>(_onAdd);
    on<RemoveRecentSearch>(_onRemove);
    on<ClearRecentSearches>(_onClear);
  }

  Future<void> _onLoad(
    LoadRecentSearches event,
    Emitter<RecentSearchState> emit,
  ) async {
    try {
      emit(const RecentSearchLoading());

      await repository.init();

      final searches = repository.getSearches();

      emit(RecentSearchLoaded(searches));
    } catch (e) {
      emit(
        RecentSearchError(e.toString()),
      );
    }
  }

  Future<void> _onAdd(
    AddRecentSearch event,
    Emitter<RecentSearchState> emit,
  ) async {
    try {
      await repository.addSearch(event.query);

      final searches = repository.getSearches();

      emit(RecentSearchLoaded(searches));
    } catch (e) {
      emit(
        RecentSearchError(e.toString()),
      );
    }
  }

  Future<void> _onRemove(
    RemoveRecentSearch event,
    Emitter<RecentSearchState> emit,
  ) async {
    try {
      await repository.removeSearch(event.query);

      final searches = repository.getSearches();

      emit(RecentSearchLoaded(searches));
    } catch (e) {
      emit(
        RecentSearchError(e.toString()),
      );
    }
  }

  Future<void> _onClear(
    ClearRecentSearches event,
    Emitter<RecentSearchState> emit,
  ) async {
    try {
      await repository.clearAll();

      emit(const RecentSearchLoaded([]));
    } catch (e) {
      emit(
        RecentSearchError(e.toString()),
      );
    }
  }
}
