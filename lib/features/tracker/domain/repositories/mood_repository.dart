
import '../entities/mood_entry.dart';

abstract class MoodRepository {
  Future<List<MoodEntry>> getRecentMoods();
  Future<void> addMoodEntry(MoodEntry entry);
  Future<void> deleteMoodEntry(String id);
  Future<void> clearAllMoods();
}

