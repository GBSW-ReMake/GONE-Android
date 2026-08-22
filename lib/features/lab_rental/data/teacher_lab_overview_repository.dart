import '../domain/teacher_lab_overview.dart';

abstract interface class TeacherLabOverviewRepository {
  Future<List<TeacherLabRoomStatus>> fetchOverview({
    required DateTime date,
    required int floor,
  });
}
