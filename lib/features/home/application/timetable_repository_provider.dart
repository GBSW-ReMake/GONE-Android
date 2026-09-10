import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gone/core/network/dio_provider.dart';
import 'package:gone/features/home/data/timetable_repository.dart';

import '../../../core/network/token_storage.dart';

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) {
  return TimetableRepository(
    ref.read(dioProvider),
    ref.read(tokenStorageProvider),
  );
});
