part of 'mood_bloc.dart';

abstract class MoodState extends Equatable {
  const MoodState();

  @override
  List<Object?> get props => [];
}

class MoodInitial extends MoodState {
  const MoodInitial();
}

class MoodLoading extends MoodState {
  const MoodLoading();
}

class MoodLoaded extends MoodState {
  final List<MoodEntry> entries;
  final String? animatingEntryId;

  const MoodLoaded({required this.entries, this.animatingEntryId});

  @override
  List<Object?> get props => [entries, animatingEntryId];

  MoodLoaded copyWith({
    List<MoodEntry>? entries,
    String? animatingEntryId,
    bool clearAnimation = false,
  }) {
    return MoodLoaded(
      entries: entries ?? this.entries,
      animatingEntryId: clearAnimation ? null : (animatingEntryId ?? this.animatingEntryId),
    );
  }
}

class MoodError extends MoodState {
  final String message;
  const MoodError(this.message);

  @override
  List<Object?> get props => [message];
}
