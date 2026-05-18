
part of 'mood_bloc.dart';

abstract class MoodEvent extends Equatable {
  const MoodEvent();

  @override
  List<Object?> get props => [];
}

class MoodInitializedEvent extends MoodEvent {
  const MoodInitializedEvent();

  @override
  List<Object?> get props => [];
}

class LoadMoods extends MoodEvent {}

class AddMood extends MoodEvent {
  final MoodType moodType;
  const AddMood(this.moodType);

  @override
  List<Object?> get props => [moodType];
}

class TriggerReplayAnimation extends MoodEvent {
  final String entryId;
  const TriggerReplayAnimation(this.entryId);

  @override
  List<Object?> get props => [entryId];
}

class ClearAnimation extends MoodEvent {}

class DeleteMood extends MoodEvent {
  final String id;
  const DeleteMood(this.id);

  @override
  List<Object?> get props => [id];
}

