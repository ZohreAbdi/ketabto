part of 'recent_search_bloc.dart';

abstract class RecentSearchEvent{
  const RecentSearchEvent();
}

class LoadRecentSearches extends RecentSearchEvent {
  const LoadRecentSearches();
}

class AddRecentSearch extends RecentSearchEvent {
  final String query;

  const AddRecentSearch(this.query);
}

class RemoveRecentSearch extends RecentSearchEvent {
  final String query;

  const RemoveRecentSearch(this.query);
}

class ClearRecentSearches extends RecentSearchEvent {
  const ClearRecentSearches();
}
