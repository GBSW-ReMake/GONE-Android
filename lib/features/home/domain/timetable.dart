import 'package:gone/features/home/domain/period.dart';

class Timetable {
  final DateTime date;
  final int grade;
  final String classNm;
  final List<Period> periods;

  Timetable({
    required this.date,
    required this.grade,
    required this.classNm,
    required this.periods,
  });

  factory Timetable.fromJson(Map<dynamic, dynamic> json) => Timetable(
    date: DateTime.parse(json['date']),
    grade: json['grade'],
    classNm: json['classNm'],
    periods: (json['periods'] as List)
        .map((e) => Period.fromJson(e))
        .toList(),
  );
}
