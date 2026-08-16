enum ParticipantRole { teacher, student }

enum CampingReservationStatus { submitted, waitingApproval, available }

class Participant {
  const Participant({required this.id, required this.name, required this.role});

  final String id;
  final String name;
  final ParticipantRole role;

  String get label =>
      role == ParticipantRole.student ? '$id $name' : '$name 선생님';
}

class CampingReservation {
  const CampingReservation({
    required this.id,
    required this.date,
    required this.teacher,
    required this.students,
    required this.status,
  });

  final String id;
  final DateTime date;
  final Participant teacher;
  final List<Participant> students;
  final CampingReservationStatus status;
}

const mockTeachers = [
  Participant(id: 'teacher-park', name: '박OO', role: ParticipantRole.teacher),
  Participant(id: 'teacher-kim', name: '김OO', role: ParticipantRole.teacher),
  Participant(id: 'teacher-lee', name: '이OO', role: ParticipantRole.teacher),
];

const mockStudents = [
  Participant(id: '3206', name: '김은찬', role: ParticipantRole.student),
  Participant(id: '3201', name: '김민준', role: ParticipantRole.student),
  Participant(id: '3202', name: '박서연', role: ParticipantRole.student),
  Participant(id: '3203', name: '이도윤', role: ParticipantRole.student),
  Participant(id: '3204', name: '최유진', role: ParticipantRole.student),
  Participant(id: '3205', name: '한지민', role: ParticipantRole.student),
];
