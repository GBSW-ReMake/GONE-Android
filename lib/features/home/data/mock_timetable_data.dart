import 'package:gone/features/home/domain/period.dart';
import 'package:gone/features/home/domain/timetable.dart';

final mockTimetableData = Timetable(
  date: DateTime(2026, 9, 9),
  grade: 2,
  classNm: '2',
  periods: [
    Period(period: 1, subject: '국어'),
    Period(period: 2, subject: '수학'),
    Period(period: 3, subject: '영어'),
    Period(period: 4, subject: '한국사'),
    Period(period: 5, subject: '체육'),
    Period(period: 6, subject: '네트워크'),
    Period(period: 7, subject: '웹 프로그래밍'),
  ],
);