import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gone/features/camping_reservation/application/camping_reservation_notifier.dart';
import 'package:gone/features/camping_reservation/domain/camping_reservation.dart';

void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  test('날짜를 선택하면 예약 폼으로 이동한다', () {
    final notifier = container.read(campingReservationProvider.notifier);
    final date = DateTime(2026, 7, 29);

    notifier.selectDate(date);

    final state = container.read(campingReservationProvider);
    expect(state.selectedDate, date);
    expect(state.screen, CampingReservationScreen.form);
  });

  test('선생님과 학생을 추가하면 예약을 신청할 수 있다', () {
    final notifier = container.read(campingReservationProvider.notifier);
    notifier.selectDate(DateTime(2026, 7, 29));
    notifier.selectTeacher(mockTeachers.first);
    notifier.addStudent(mockStudents.first);

    expect(container.read(campingReservationProvider).canSubmit, isTrue);

    notifier.submit();

    final state = container.read(campingReservationProvider);
    expect(state.screen, CampingReservationScreen.complete);
    expect(state.reservation?.teacher, mockTeachers.first);
    expect(state.reservation?.students, [mockStudents.first]);
  });

  test('예약 취소 시 예약 정보와 참가자 선택을 초기화한다', () {
    final notifier = container.read(campingReservationProvider.notifier);
    notifier.selectDate(DateTime(2026, 7, 29));
    notifier.selectTeacher(mockTeachers.first);
    notifier.addStudent(mockStudents.first);
    notifier.submit();

    notifier.cancelReservation();

    final state = container.read(campingReservationProvider);
    expect(state.screen, CampingReservationScreen.calendar);
    expect(state.reservation, isNull);
    expect(state.teacher, isNull);
    expect(state.students, isEmpty);
  });
}
