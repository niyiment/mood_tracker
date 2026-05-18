

import 'dart:ui';

import 'package:mood_tracker/features/tracker/domain/entities/mood_entry.dart';

class MoodEntryModel extends MoodEntry {
  const MoodEntryModel({
    required super.id,
    required super.moodType,
    required super.timestamp,
    required super.accentColor,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'moodType': moodType.index,
      'timestamp': timestamp.toIso8601String(),
      'accentColor': accentColor.toARGB32(),
    };
  }

  factory MoodEntryModel.fromJson(Map<String, dynamic> json) {
    return MoodEntryModel(
      id: json['id'],
      moodType: MoodType.values[json['moodType']],
      timestamp: DateTime.parse(json['timestamp']),
      accentColor: Color(json['accentColor']),
    );
  }

  factory MoodEntryModel.fromEntity(MoodEntry entity) {
    return MoodEntryModel(
      id: entity.id,
      moodType: entity.moodType,
      timestamp: entity.timestamp,
      accentColor: entity.accentColor,
    );
  }
}
