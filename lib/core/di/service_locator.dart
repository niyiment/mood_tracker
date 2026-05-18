
import 'package:mood_tracker/features/tracker/data/datasources/mood_local_datasource.dart';
import 'package:mood_tracker/features/tracker/data/repositories/mood_repository_impl.dart';
import 'package:mood_tracker/features/tracker/presentation/bloc/mood_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();

  factory ServiceLocator() {
    return _instance;
  }

  ServiceLocator._internal();

  /// Initialize all dependencies
  static Future<void> init() async {
    // External dependencies
    final sharedPreferences = await SharedPreferences.getInstance();

    // Data sources
    final moodLocalDataSource = MoodLocalDatasourceImpl(
      sharedPreferences: sharedPreferences,
    );

    // Repositories
    final moodRepository = MoodRepositoryImpl(
      localDatasource: moodLocalDataSource,
    );

    // BLoCs
    _moodBloc = MoodBloc(
      repository: moodRepository,
    );
  }

  static late MoodBloc _moodBloc;

  static MoodBloc get moodBloc => _moodBloc;
}

