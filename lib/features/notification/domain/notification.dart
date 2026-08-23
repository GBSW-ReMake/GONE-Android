import '../../auth/domain/account_role.dart';

enum NotificationGroup {
  today('오늘'),
  yesterday('어제'),
  recentWeek('최근 7일');

  const NotificationGroup(this.title);

  final String title;
}

enum NotificationType {
  camping('assets/images/home-camping.png'),
  outing('assets/images/home-outing.png'),
  reward('assets/images/notification-reward.png'),
  penalty('assets/images/notification-penalty.png'),
  lab('assets/images/home-lab.png');

  const NotificationType(this.assetPath);

  final String assetPath;
}

class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.role,
    required this.group,
    required this.type,
    required this.title,
    required this.description,
    required this.timeLabel,
    this.isRead = false,
  });

  final String id;
  final AccountRole role;
  final NotificationGroup group;
  final NotificationType type;
  final String title;
  final String description;
  final String timeLabel;
  final bool isRead;

  NotificationItem copyWith({bool? isRead}) => NotificationItem(
    id: id,
    role: role,
    group: group,
    type: type,
    title: title,
    description: description,
    timeLabel: timeLabel,
    isRead: isRead ?? this.isRead,
  );
}
