import 'package:dio/dio.dart';
import 'package:gone/features/home/data/mock_timetable_data.dart';
import 'package:gone/features/home/domain/timetable.dart';

import '../../../core/network/token_storage.dart';

class TimetableRepository {
  TimetableRepository(this._dio, this._tokenStorage);

  final Dio _dio;
  final TokenStorage _tokenStorage;

  Future<Timetable> loadToday() async {
    return mockTimetableData;
  }
}