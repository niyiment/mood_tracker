import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mood_tracker/features/tracker/domain/entities/mood_entry.dart';
import 'package:mood_tracker/features/tracker/presentation/bloc/mood_bloc.dart';
import 'package:mood_tracker/features/tracker/presentation/widgets/animated_mood_face.dart';
import 'package:mood_tracker/features/tracker/presentation/widgets/mood_loader.dart';
import 'package:mood_tracker/features/tracker/presentation/widgets/mood_timeline_card.dart';

class MoodTrackerPage extends StatelessWidget {
  const MoodTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        child: BlocBuilder<MoodBloc, MoodState>(
          builder: (context, state) {
            if (state is MoodInitial || state is MoodLoading) {
              return const MoodLoader();
            }
            if (state is MoodLoaded) {
              return _buildContent(context, state);
            }
            if (state is MoodError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, MoodLoaded state) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Text(
                'Mood Canvas',
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1C1E),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'How are you feeling today?',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        // Mood Selector
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _MoodSelectorItem(
                    type: MoodType.happy,
                    label: 'Happy',
                    color: const Color(0xFF4ADE80),
                    onTap: () => context.read<MoodBloc>().add(
                      const AddMood(MoodType.happy),
                    ),
                  ),
                  const SizedBox(width: 32),
                  _MoodSelectorItem(
                    type: MoodType.neutral,
                    label: 'Neutral',
                    color: const Color(0xFF94A3B8),
                    onTap: () => context.read<MoodBloc>().add(
                      const AddMood(MoodType.neutral),
                    ),
                  ),
                  const SizedBox(width: 32),
                  _MoodSelectorItem(
                    type: MoodType.sad,
                    label: 'Sad',
                    color: const Color(0xFF818CF8),
                    onTap: () => context.read<MoodBloc>().add(
                      const AddMood(MoodType.sad),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Timeline Section
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Recent History',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1C1E),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: state.entries.isEmpty
              ? Center(
            child: Text(
              'No moods logged yet',
              style: TextStyle(color: Colors.grey[400]),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: state.entries.length,
            itemBuilder: (context, index) {
              final entry = state.entries[index];
              return MoodTimelineCard(
                entry: entry,
                isAnimating: state.animatingEntryId == entry.id,
                onTap: () {
                  context.read<MoodBloc>().add(
                    TriggerReplayAnimation(entry.id),
                  );
                },
                onAnimationComplete: () {
                  context.read<MoodBloc>().add(ClearAnimation());
                },
                onDelete: () {
                  context.read<MoodBloc>().add(DeleteMood(entry.id));
                },
              );
            },
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _MoodSelectorItem extends StatelessWidget {
  final MoodType type;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MoodSelectorItem({
    required this.type,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: AnimatedMoodFace(moodType: type, color: color, size: 80),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}

