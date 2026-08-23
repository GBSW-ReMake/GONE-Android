import '../../auth/domain/account_role.dart';
import '../domain/notification.dart';

abstract interface class NotificationRepository {
  Future<List<NotificationItem>> fetchNotifications(AccountRole role);
}
