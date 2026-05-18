import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

enum MoodType { happy, neutral, sad }

class MoodEntry extends Equatable {
  final String id;
  final MoodType moodType;
  final DateTime timestamp;
  final Color accentColor;

  const MoodEntry({
    required this.id,
    required this.moodType,
    required this.timestamp,
    required this.accentColor,
  });

  @override
  List<Object?> get props => [id, moodType, timestamp, accentColor];
}


/// Extension to provide properties for each mood
extension MoodTypeExtension on MoodType {
  /// Get display name
  String get displayName {
    switch (this) {
      case MoodType.happy:
        return 'Happy';
      case MoodType.neutral:
        return 'Neutral';
      case MoodType.sad:
        return 'Sad';
    }
  }

  /// Get accent color for the mood
  Color get accentColor {
    switch (this) {
      case MoodType.happy:
        return const Color(0xFFFFD700); // Gold
      case MoodType.neutral:
        return const Color(0xFF9E9E9E); // Gray
      case MoodType.sad:
        return const Color(0xFF5C6BC0); // Indigo
    }
  }

  /// Get mood type from string
  static MoodType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'happy':
        return MoodType.happy;
      case 'neutral':
        return MoodType.neutral;
      case 'sad':
        return MoodType.sad;
      default:
        return MoodType.neutral;
    }
  }

  /// Convert to string
  String toStringValue() => displayName.toLowerCase();
}

