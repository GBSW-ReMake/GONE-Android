import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gone/features/auth/domain/account_role.dart';
import 'package:gone/features/notification/application/notification_notifier.dart';
import 'package:gone/features/notification/domain/notification.dart';

void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  test('학생 역할은 학생용 알림을 날짜 그룹별로 불러온다', () async {
    final notifier = container.read(notificationProvider.notifier);

    await notifier.load(AccountRole.student);

    final state = container.read(notificationProvider);
    expect(state.status, NotificationStatus.loaded);
    expect(state.role, AccountRole.student);
    expect(state.groupedItems[NotificationGroup.today], hasLength(2));
    expect(state.items.any((item) => item.title.contains('상점')), isTrue);
  });

  test('선생님 역할은 학생 신청 중심의 알림을 불러온다', () async {
    final notifier = container.read(notificationProvider.notifier);

    await notifier.load(AccountRole.teacher);

    final state = container.read(notificationProvider);
    expect(state.status, NotificationStatus.loaded);
    expect(state.role, AccountRole.teacher);
    expect(state.items.any((item) => item.title.contains('학생이')), isTrue);
    expect(
      state.items.any((item) => item.type == NotificationType.reward),
      isFalse,
    );
  });

  test('모두 읽음 처리하면 읽지 않은 개수가 0이 된다', () async {
    final notifier = container.read(notificationProvider.notifier);

    await notifier.load(AccountRole.student);
    expect(container.read(notificationProvider).unreadCount, greaterThan(0));

    notifier.markAllRead();

    final state = container.read(notificationProvider);
    expect(state.unreadCount, 0);
    expect(state.items.every((item) => item.isRead), isTrue);
  });
}
