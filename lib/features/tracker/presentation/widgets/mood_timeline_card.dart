import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/mood_entry.dart';
import 'animated_mood_face.dart';

class MoodTimelineCard extends StatelessWidget {
  final MoodEntry entry;
  final bool isAnimating;
  final VoidCallback onTap;
  final VoidCallback onAnimationComplete;
  final VoidCallback onDelete;

  const MoodTimelineCard({
    super.key,
    required this.entry,
    required this.isAnimating,
    required this.onTap,
    required this.onAnimationComplete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: entry.accentColor.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: entry.accentColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.close_rounded, size: 16),
                color: Colors.grey[400],
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Remove Entry',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedMoodFace(
                    moodType: entry.moodType,
                    color: entry.accentColor,
                    size: 50,
                    isAnimating: isAnimating,
                    onAnimationComplete: onAnimationComplete,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    DateFormat('E, MMM d').format(entry.timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    DateFormat('jm').format(entry.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

