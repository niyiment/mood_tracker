import 'package:flutter/material.dart';
import 'package:mood_tracker/features/tracker/domain/entities/mood_entry.dart';
import 'mood_button.dart';

class MoodSelector extends StatelessWidget {
  final ValueChanged<MoodType> onMoodSelected;

  const MoodSelector({
    super.key,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return Wrap(
          spacing: isMobile ? 16 : 32,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: MoodType.values.map((type) {
            return MoodButton(
              moodType: type,
              onPressed: () => onMoodSelected(type),
            );
          }).toList(),
        );
      },
    );
  }
}

