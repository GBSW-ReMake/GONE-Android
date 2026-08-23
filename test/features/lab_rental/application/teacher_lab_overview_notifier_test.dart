import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gone/features/lab_rental/application/teacher_lab_overview_notifier.dart';

void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  test('선생님 현황을 불러오면 선택한 층의 실습실 목록을 제공한다', () async {
    final notifier = container.read(teacherLabOverviewProvider.notifier);

    await notifier.load();

    final state = container.read(teacherLabOverviewProvider);
    expect(state.status, TeacherLabOverviewStatus.loaded);
    expect(state.selectedFloor, 4);
    expect(state.rooms, hasLength(5));
    expect(state.rooms.first.booking?.period.label, '야자시간');
  });

  test('층을 변경하면 해당 층의 현황을 다시 불러온다', () async {
    final notifier = container.read(teacherLabOverviewProvider.notifier);

    await notifier.load();
    await notifier.selectFloor(3);

    final state = container.read(teacherLabOverviewProvider);
    expect(state.status, TeacherLabOverviewStatus.loaded);
    expect(state.selectedFloor, 3);
    expect(state.rooms, hasLength(1));
    expect(state.rooms.single.isReserved, isFalse);
  });
}
