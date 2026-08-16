import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gone/features/outing/application/outing_notifier.dart';
import 'package:gone/features/outing/domain/outing_request.dart';

void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  test('점심과 저녁 시간은 정책 시간으로 설정한다', () {
    final notifier = container.read(outingProvider.notifier);

    notifier.selectTimeType(OutingTimeType.dinner);

    final state = container.read(outingProvider);
    expect(state.timeRange.startMinute, 18 * 60 + 10);
    expect(state.timeRange.endMinute, 19 * 60 + 10);
  });

  test('유효한 입력으로 외출 신청을 만들고 승인 후 외출을 시작한다', () {
    final notifier = container.read(outingProvider.notifier);
    notifier.selectTeacher(mockOutingTeachers.first);

    expect(notifier.submit('병원 방문'), isTrue);
    expect(container.read(outingProvider).isWaitingApproval, isTrue);

    notifier.approveForPreview();
    notifier.startOuting();

    final state = container.read(outingProvider);
    expect(state.screen, OutingScreen.progress);
    expect(state.isOuting, isTrue);
  });

  test('외출 종료 시 초기 신청 화면으로 돌아간다', () {
    final notifier = container.read(outingProvider.notifier);
    notifier.selectTeacher(mockOutingTeachers.first);
    notifier.submit('병원 방문');
    notifier.approveForPreview();
    notifier.startOuting();

    notifier.endOuting();

    final state = container.read(outingProvider);
    expect(state.screen, OutingScreen.overview);
    expect(state.request, isNull);
  });
}
