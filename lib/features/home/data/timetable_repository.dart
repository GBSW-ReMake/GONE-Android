import 'package:dio/dio.dart';
import 'package:gone/features/home/domain/timetable.dart';

class TimetableRepository {
  TimetableRepository(this._dio);

  final Dio _dio;

  Future<Timetable?> loadToday() async {
    try {
      final now = DateTime.now();

      final response = await _dio.get(
        '/api/v1/timetables',
        queryParameters: {
          'date':
              '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}',
        },
      );

      final jsonBody = response.data;
      print(jsonBody);
      return Timetable.fromJson(jsonBody['data']);
    } catch (e) {
      final error = e as DioException;
      final data = error.response?.data;
      print(data);
      return null;
    }
  }
}
