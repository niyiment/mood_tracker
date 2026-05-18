
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mood_tracker/features/tracker/domain/entities/mood_entry.dart';
import 'package:mood_tracker/features/tracker/domain/repositories/mood_repository.dart';

part 'mood_event.dart';
part 'mood_state.dart';


class MoodBloc extends Bloc<MoodEvent, MoodState> {
  final MoodRepository repository;

  MoodBloc({
    required this.repository,
  }) : super(MoodInitial()) {
    on<LoadMoods>(_onLoadMoods);
    on<AddMood>(_onAddMood);
    on<TriggerReplayAnimation>(_onTriggerReplayAnimation);
    on<ClearAnimation>(_onClearAnimation);
    on<DeleteMood>(_onDeleteMood);

    add(LoadMoods());
  }

  Future<void> _onDeleteMood(DeleteMood event, Emitter<MoodState> emit) async {
    await repository.deleteMoodEntry(event.id);
    add(LoadMoods());
  }

  Future<void> _onLoadMoods(LoadMoods event, Emitter<MoodState> emit) async {
    emit(MoodLoading());
    try {
      final entries = await repository.getRecentMoods();
      emit(MoodLoaded(entries: entries));
    } catch (e) {
      emit(const MoodError('Failed to load moods'));
    }
  }

  Future<void> _onAddMood(AddMood event, Emitter<MoodState> emit) async {
    final currentState = state;
    if (currentState is MoodLoaded) {
      final Color accentColor = _getAccentColor(event.moodType);
      final newEntry = MoodEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        moodType: event.moodType,
        timestamp: DateTime.now(),
        accentColor: accentColor,
      );

      try {
        await repository.addMoodEntry(newEntry);
        final updatedEntries = await repository.getRecentMoods();
        emit(currentState.copyWith(entries: updatedEntries));
      } catch (e) {
        emit(const MoodError('Failed to add mood'));
      }
    }
  }

  void _onTriggerReplayAnimation(TriggerReplayAnimation event, Emitter<MoodState> emit) {
    final currentState = state;
    if (currentState is MoodLoaded) {
      emit(currentState.copyWith(animatingEntryId: event.entryId));
      // The UI will handle the animation duration and then call ClearAnimation
    }
  }

  void _onClearAnimation(ClearAnimation event, Emitter<MoodState> emit) {
    final currentState = state;
    if (currentState is MoodLoaded) {
      emit(currentState.copyWith(clearAnimation: true));
    }
  }

  Color _getAccentColor(MoodType type) {
    switch (type) {
      case MoodType.happy:
        return const Color(0xFF4ADE80); // Vibrant Soft Green
      case MoodType.neutral:
        return const Color(0xFF94A3B8); // Slate Blue-Gray
      case MoodType.sad:
        return const Color(0xFF818CF8); // Indigo-Purple
    }
  }
}
