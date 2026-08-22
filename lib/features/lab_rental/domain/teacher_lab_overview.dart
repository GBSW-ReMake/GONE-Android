import 'lab_rental.dart';

enum LabUsagePeriod {
  nightStudy('야자시간'),
  afterSchool('방과후'),
  none('미예약');

  const LabUsagePeriod(this.label);

  final String label;
}

class TeacherLabBooking {
  const TeacherLabBooking({
    required this.dateLabel,
    required this.period,
    required this.usageTime,
    required this.bookers,
    required this.purpose,
    required this.location,
  });

  final String dateLabel;
  final LabUsagePeriod period;
  final String usageTime;
  final String bookers;
  final String purpose;
  final String location;
}

class TeacherLabRoomStatus {
  const TeacherLabRoomStatus({required this.room, this.booking});

  final LabRoom room;
  final TeacherLabBooking? booking;

  bool get isReserved => booking != null;
}
