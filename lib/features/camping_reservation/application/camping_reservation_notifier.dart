import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/camping_reservation.dart';

enum CampingReservationScreen { calendar, form, complete }

class CampingReservationState {
  const CampingReservationState({
    required this.displayedMonth,
    required this.screen,
    this.selectedDate,
    this.teacher,
    this.students = const [],
    this.reservation,
  });

  final DateTime displayedMonth;
  final CampingReservationScreen screen;
  final DateTime? selectedDate;
  final Participant? teacher;
  final List<Participant> students;
  final CampingReservation? reservation;

  bool get canSubmit =>
      selectedDate != null && teacher != null && students.isNotEmpty;

  CampingReservationState copyWith({
    DateTime? displayedMonth,
    CampingReservationScreen? screen,
    DateTime? selectedDate,
    Participant? teacher,
    List<Participant>? students,
    CampingReservation? reservation,
    bool clearTeacher = false,
    bool clearReservation = false,
  }) {
    return CampingReservationState(
      displayedMonth: displayedMonth ?? this.displayedMonth,
      screen: screen ?? this.screen,
      selectedDate: selectedDate ?? this.selectedDate,
      teacher: clearTeacher ? null : teacher ?? this.teacher,
      students: students ?? this.students,
      reservation: clearReservation ? null : reservation ?? this.reservation,
    );
  }
}

class CampingReservationNotifier extends Notifier<CampingReservationState> {
  static const _maxParticipants = 8;

  @override
  CampingReservationState build() => CampingReservationState(
    displayedMonth: DateTime(2026, 7),
    screen: CampingReservationScreen.calendar,
  );

  void showPreviousMonth() {
    final month = state.displayedMonth;
    state = state.copyWith(
      displayedMonth: DateTime(month.year, month.month - 1),
    );
  }

  void showNextMonth() {
    final month = state.displayedMonth;
    state = state.copyWith(
      displayedMonth: DateTime(month.year, month.month + 1),
    );
  }

  void selectDate(DateTime date) {
    state = state.copyWith(
      selectedDate: date,
      screen: CampingReservationScreen.form,
    );
  }

  void showCalendar() =>
      state = state.copyWith(screen: CampingReservationScreen.calendar);

  void selectTeacher(Participant teacher) {
    if (teacher.role != ParticipantRole.teacher) return;
    state = state.copyWith(teacher: teacher);
  }

  void addStudent(Participant student) {
    if (student.role != ParticipantRole.student ||
        state.students.length >= _maxParticipants ||
        state.students.any((item) => item.id == student.id)) {
      return;
    }
    state = state.copyWith(students: [...state.students, student]);
  }

  void removeStudent(String id) {
    state = state.copyWith(
      students: state.students.where((student) => student.id != id).toList(),
    );
  }

  void submit() {
    if (!state.canSubmit) return;
    state = state.copyWith(
      screen: CampingReservationScreen.complete,
      reservation: CampingReservation(
        id: 'C-0729-01',
        date: state.selectedDate!,
        teacher: state.teacher!,
        students: state.students,
        status: CampingReservationStatus.submitted,
      ),
    );
  }

  void cancelReservation() {
    state = state.copyWith(
      screen: CampingReservationScreen.calendar,
      clearReservation: true,
      clearTeacher: true,
      students: const [],
    );
  }
}

final campingReservationProvider =
    NotifierProvider<CampingReservationNotifier, CampingReservationState>(
      CampingReservationNotifier.new,
    );
