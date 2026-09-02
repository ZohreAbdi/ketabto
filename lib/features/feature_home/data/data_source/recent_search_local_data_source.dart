import 'package:hive/hive.dart';

class RecentSearchLocalDataSource {
  static const String boxName = 'recent_searches';
  static const String queriesKey = 'queries';

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
  }

  Box get _box => Hive.box(boxName);

  List<String> getSearches() {
    final data = _box.get(
      queriesKey,
      defaultValue: <String>[],
    );

    return List<String>.from(data);
  }

  Future<void> saveSearches(List<String> searches) async {
    await _box.put(queriesKey, searches);
  }

  Future<void> clearSearches() async {
    await _box.delete(queriesKey);
  }
}