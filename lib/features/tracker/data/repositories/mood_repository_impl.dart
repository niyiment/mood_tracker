
import 'package:mood_tracker/features/tracker/data/datasources/mood_local_datasource.dart';
import 'package:mood_tracker/features/tracker/data/models/mood_entry_model.dart';
import 'package:mood_tracker/features/tracker/domain/entities/mood_entry.dart';
import 'package:mood_tracker/features/tracker/domain/repositories/mood_repository.dart';

class MoodRepositoryImpl implements MoodRepository {
  final MoodLocalDatasource localDatasource;

  MoodRepositoryImpl({required this.localDatasource});


  @override
  Future<void> addMoodEntry(MoodEntry entry) async {
    await localDatasource.addMoodEntry(MoodEntryModel.fromEntity(entry));
  }

  @override
  Future<void> clearAllMoods() async {
    await localDatasource.clearAllMoods();
  }

  @override
  Future<void> deleteMoodEntry(String id) async {
    await localDatasource.deleteMoodEntry(id);
  }

  @override
  Future<List<MoodEntry>> getRecentMoods() async {
    return await localDatasource.getRecentMoods();
  }

}