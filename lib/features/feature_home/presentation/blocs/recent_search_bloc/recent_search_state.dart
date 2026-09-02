part of 'recent_search_bloc.dart';

abstract class RecentSearchState {
  const RecentSearchState();
}

class RecentSearchInitial extends RecentSearchState {
  const RecentSearchInitial();
}

class RecentSearchLoading extends RecentSearchState {
  const RecentSearchLoading();
}

class RecentSearchLoaded extends RecentSearchState {
  final List<String> searches;

  const RecentSearchLoaded(this.searches);
}

class RecentSearchError extends RecentSearchState {
  final String message;

  const RecentSearchError(this.message);
}