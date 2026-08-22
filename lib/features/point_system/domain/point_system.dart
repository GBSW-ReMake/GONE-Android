enum PointKind { reward, penalty }

extension PointKindX on PointKind {
  String get label => this == PointKind.reward ? '상점' : '벌점';
  String get prefix => this == PointKind.reward ? '+' : '-';
}

class PointStudent {
  const PointStudent({required this.id, required this.name, required this.info});
  final String id;
  final String name;
  final String info;
}

class PointIssueDraft {
  const PointIssueDraft({this.kind = PointKind.reward, this.points = 2, this.item = '학교 홍보 활동에 성실히 참여한 학생', this.memo = ''});
  final PointKind kind;
  final int points;
  final String item;
  final String memo;
  PointIssueDraft copyWith({PointKind? kind, int? points, String? item, String? memo}) => PointIssueDraft(kind: kind ?? this.kind, points: points ?? this.points, item: item ?? this.item, memo: memo ?? this.memo);
}

class PointIssueRecord {
  const PointIssueRecord({required this.student, required this.draft, required this.issuedAt});
  final PointStudent student;
  final PointIssueDraft draft;
  final DateTime issuedAt;
}

const mockPointStudents = [
  PointStudent(id: '3206', name: '김은찬', info: '3학년 2반 6번'),
  PointStudent(id: '3201', name: '김민준', info: '3학년 2반 1번'),
  PointStudent(id: '3202', name: '박서연', info: '3학년 2반 2번'),
  PointStudent(id: '3203', name: '이도윤', info: '3학년 2반 3번'),
];
