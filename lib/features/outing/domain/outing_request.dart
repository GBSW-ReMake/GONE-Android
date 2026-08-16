enum OutingTimeType { lunch, dinner, custom }

enum OutingStatus { waitingApproval, approved, outing, completed }

class OutingTeacher {
  const OutingTeacher({required this.id, required this.name});

  final String id;
  final String name;

  String get label => '$name 선생님';
}

class OutingTimeRange {
  const OutingTimeRange({required this.startMinute, required this.endMinute});

  final int startMinute;
  final int endMinute;

  bool get isValid =>
      startMinute >= 0 && endMinute <= 24 * 60 && startMinute < endMinute;

  String get label => '${_format(startMinute)} ~ ${_format(endMinute)}';

  static String _format(int minute) {
    final hour = minute ~/ 60;
    final minutes = minute % 60;
    final period = hour < 12 ? '오전' : '오후';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$period $displayHour:${minutes.toString().padLeft(2, '0')}';
  }
}

class OutingRequest {
  const OutingRequest({
    required this.id,
    required this.date,
    required this.timeType,
    required this.timeRange,
    required this.teacher,
    required this.reason,
    required this.status,
  });

  final String id;
  final DateTime date;
  final OutingTimeType timeType;
  final OutingTimeRange timeRange;
  final OutingTeacher teacher;
  final String reason;
  final OutingStatus status;

  OutingRequest copyWith({OutingStatus? status}) => OutingRequest(
    id: id,
    date: date,
    timeType: timeType,
    timeRange: timeRange,
    teacher: teacher,
    reason: reason,
    status: status ?? this.status,
  );
}

const lunchTimeRange = OutingTimeRange(
  startMinute: 12 * 60 + 30,
  endMinute: 13 * 60 + 30,
);
const dinnerTimeRange = OutingTimeRange(
  startMinute: 18 * 60 + 10,
  endMinute: 19 * 60 + 10,
);

const mockOutingTeachers = [
  OutingTeacher(id: 'T-100', name: '이OO'),
  OutingTeacher(id: 'T-101', name: '박OO'),
  OutingTeacher(id: 'T-102', name: '김OO'),
];
