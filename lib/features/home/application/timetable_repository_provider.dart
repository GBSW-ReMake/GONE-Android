import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gone/core/network/dio_provider.dart';
import 'package:gone/features/home/data/timetable_repository.dart';

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) {
  return TimetableRepository(
    ref.read(dioProvider),
  );
});
