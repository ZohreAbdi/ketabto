
import 'package:ketabto_test/features/feature_home/data/data_source/recent_search_local_data_source.dart';

class RecentSearchRepository {
  final RecentSearchLocalDataSource localDataSource;

  RecentSearchRepository({
    required this.localDataSource,
  });

  Future<void> init() async {
    await localDataSource.init();
  }

  List<String> getSearches() {
    return localDataSource.getSearches();
  }

  Future<void> addSearch(String query) async {
    query = query.trim();

    if (query.isEmpty) return;

    final searches = localDataSource.getSearches();

    searches.remove(query);
    searches.insert(0, query);

    if (searches.length > 10) {
      searches.removeLast();
    }

    await localDataSource.saveSearches(searches);
  }

  Future<void> removeSearch(String query) async {
    final searches = localDataSource.getSearches();

    searches.remove(query);

    await localDataSource.saveSearches(searches);
  }

  Future<void> clearAll() async {
    await localDataSource.clearSearches();
  }
}