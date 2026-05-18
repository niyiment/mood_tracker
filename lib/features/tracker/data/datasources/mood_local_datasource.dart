import 'dart:convert';

import 'package:mood_tracker/features/tracker/data/models/mood_entry_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MoodLocalDatasource {
  Future<List<MoodEntryModel>> getRecentMoods();
  Future<void> addMoodEntry(MoodEntryModel entry);
  Future<void> clearAllMoods();
  Future<void> deleteMoodEntry(String id);
}

class MoodLocalDatasourceImpl extends MoodLocalDatasource {
  final SharedPreferences sharedPreferences;
  static const String key = 'CACHED_MOOD_ENTRIES';

  MoodLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<void> addMoodEntry(MoodEntryModel entry) async {
    final entries = await getRecentMoods();
    entries.insert(0, entry);

    if (entries.length > 7) {
      entries.removeRange(7, entries.length);
    }
    await _saveEntries(entries);
  }

  @override
  Future<void> clearAllMoods() async {
    await sharedPreferences.remove(key);
  }

  @override
  Future<void> deleteMoodEntry(String id) async {
    final entries = await getRecentMoods();
    entries.removeWhere((element) => element.id == id);
    await _saveEntries(entries);
  }

  @override
  Future<List<MoodEntryModel>> getRecentMoods() async {
    final jsonString = sharedPreferences.getString(key);
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((element) => MoodEntryModel.fromJson(element)).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  Future<void> _saveEntries(List<MoodEntryModel> entries) async {
    final jsonString = json.encode(entries.map((e) => e.toJson()).toList());
    await sharedPreferences.setString(key, jsonString);
  }

}
