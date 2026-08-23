import '../domain/lab_rental.dart';
import '../domain/teacher_lab_overview.dart';
import 'teacher_lab_overview_repository.dart';

class MockTeacherLabOverviewRepository
    implements TeacherLabOverviewRepository {
  @override
  Future<List<TeacherLabRoomStatus>> fetchOverview({
    required DateTime date,
    required int floor,
  }) async {
    final rooms = mockLabRooms.where((room) => room.floor == floor).toList();
    return rooms
        .map(
          (room) => TeacherLabRoomStatus(
            room: room,
            booking: _bookingFor(room, date),
          ),
        )
        .toList();
  }

  TeacherLabBooking? _bookingFor(LabRoom room, DateTime date) {
    if (room.id == 'lab-401') {
      return TeacherLabBooking(
        dateLabel: _dateLabel(date),
        weekdayLabel: _weekdayLabel(date),
        period: LabUsagePeriod.nightStudy,
        usageTime: '19:10 ~ 20:30',
        bookers: '김은찬 외 4명',
        purpose: '대회 준비',
        location: '4층 1학년 1반 앞 실습실',
      );
    }
    if (room.id == 'lab-402') {
      return TeacherLabBooking(
        dateLabel: _dateLabel(date),
        weekdayLabel: _weekdayLabel(date),
        period: LabUsagePeriod.afterSchool,
        usageTime: '16:30 ~ 18:00',
        bookers: '김은찬 외 4명',
        purpose: '캡스톤 개발',
        location: '4층 1학년 1반 앞 실습실',
      );
    }
    return null;
  }

  String _dateLabel(DateTime date) => '${date.month}월 ${date.day}일';

  String _weekdayLabel(DateTime date) {
    const weekdays = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    return weekdays[date.weekday - 1];
  }
}
