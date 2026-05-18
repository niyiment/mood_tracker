import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mood_tracker/core/constant/app_string.dart';
import 'package:mood_tracker/core/di/service_locator.dart';
import 'package:mood_tracker/core/theme/app_theme.dart';
import 'package:mood_tracker/features/tracker/presentation/bloc/mood_bloc.dart';
import 'package:mood_tracker/features/tracker/presentation/pages/mood_tracker_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ServiceLocator.init();

  runApp(const MoodTrackerApp());
}

class MoodTrackerApp extends StatelessWidget {
  const MoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MoodBloc>.value(
      value: ServiceLocator.moodBloc,
      child: MaterialApp(
        title:  AppString.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MoodTrackerPage(),
      ),
    );
  }
}
