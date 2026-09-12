import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gone/features/home/application/timetable_repository_provider.dart';
import 'package:gone/features/home/domain/timetable.dart';

final homeScheduleProvider = FutureProvider<Timetable?>((ref) {
  return ref.watch(timetableRepositoryProvider).loadToday();
});
