import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/point_system.dart';

class PointSystemState {
  const PointSystemState({this.students = const [], this.drafts = const {}, this.records = const []});
  final List<PointStudent> students;
  final Map<String, PointIssueDraft> drafts;
  final List<PointIssueRecord> records;
  PointSystemState copyWith({List<PointStudent>? students, Map<String, PointIssueDraft>? drafts, List<PointIssueRecord>? records}) => PointSystemState(students: students ?? this.students, drafts: drafts ?? this.drafts, records: records ?? this.records);
}

class PointSystemNotifier extends Notifier<PointSystemState> {
  @override
  PointSystemState build() => const PointSystemState();
  void addStudent(PointStudent student) {
    if (state.students.any((item) => item.id == student.id)) return;
    state = state.copyWith(students: [...state.students, student], drafts: {...state.drafts, student.id: const PointIssueDraft()});
  }
  void saveDraft(PointStudent student, PointIssueDraft draft) => state = state.copyWith(drafts: {...state.drafts, student.id: draft});
  void removeStudent(PointStudent student) {
    final drafts = {...state.drafts}..remove(student.id);
    state = state.copyWith(students: state.students.where((item) => item.id != student.id).toList(), drafts: drafts);
  }
  void clear() => state = PointSystemState(records: state.records);
  List<PointIssueRecord> issueAll() {
    final records = state.students.map((student) => PointIssueRecord(student: student, draft: state.drafts[student.id] ?? const PointIssueDraft(), issuedAt: DateTime.now())).toList();
    state = PointSystemState(records: [...records, ...state.records]);
    return records;
  }
}

final pointSystemProvider = NotifierProvider<PointSystemNotifier, PointSystemState>(PointSystemNotifier.new);
