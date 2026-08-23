import '../../auth/domain/account_role.dart';
import '../domain/notification.dart';
import 'notification_repository.dart';

class MockNotificationRepository implements NotificationRepository {
  @override
  Future<List<NotificationItem>> fetchNotifications(AccountRole role) async {
    return role == AccountRole.teacher
        ? _teacherNotifications
        : _studentNotifications;
  }

  static const _studentNotifications = [
    NotificationItem(
      id: 'student-camping-open-today',
      role: AccountRole.student,
      group: NotificationGroup.today,
      type: NotificationType.camping,
      title: '8월 스쿨캠핑이 오픈되었습니다',
      description: '8월 스쿨캠핑 예약이 시작됐어요. 원하는 날짜를 확인해 주세요',
      timeLabel: '방금 전',
    ),
    NotificationItem(
      id: 'student-outing-approved-today',
      role: AccountRole.student,
      group: NotificationGroup.today,
      type: NotificationType.outing,
      title: '외출 신청이 승인되었습니다',
      description: '오늘 14:00~17:50 외출이 승인되어 외출증이 발급됐어요',
      timeLabel: '30분 전',
    ),
    NotificationItem(
      id: 'student-reward-yesterday',
      role: AccountRole.student,
      group: NotificationGroup.yesterday,
      type: NotificationType.reward,
      title: '상점 5점이 발급 되었습니다',
      description: '학교 홍보 활동에 성실히 참여한 학생 항목으로 발급됐어요',
      timeLabel: '1시간 전',
      isRead: true,
    ),
    NotificationItem(
      id: 'student-penalty-yesterday',
      role: AccountRole.student,
      group: NotificationGroup.yesterday,
      type: NotificationType.penalty,
      title: '벌점 3점이 발급 되었습니다',
      description: '교복을 착용하지 않은 학생',
      timeLabel: '어제',
      isRead: true,
    ),
    NotificationItem(
      id: 'student-lab-yesterday',
      role: AccountRole.student,
      group: NotificationGroup.yesterday,
      type: NotificationType.lab,
      title: '실습실 대여가 승인되었습니다',
      description: '오늘 19:00~21:00 iOS실을 이용할 수 있어요',
      timeLabel: '어제',
      isRead: true,
    ),
    NotificationItem(
      id: 'student-outing-recent',
      role: AccountRole.student,
      group: NotificationGroup.recentWeek,
      type: NotificationType.outing,
      title: '외출 신청이 승인되었습니다',
      description: '오늘 14:00~17:50 외출이 승인되어 외출증이 발급됐어요',
      timeLabel: '8월 11일',
      isRead: true,
    ),
    NotificationItem(
      id: 'student-lab-recent',
      role: AccountRole.student,
      group: NotificationGroup.recentWeek,
      type: NotificationType.lab,
      title: '실습실 대여가 승인되었습니다',
      description: '8월 11일 · 8명 · 19:00~21:00 · iOS실',
      timeLabel: '8월 11일',
      isRead: true,
    ),
  ];

  static const _teacherNotifications = [
    NotificationItem(
      id: 'teacher-camping-request-today',
      role: AccountRole.teacher,
      group: NotificationGroup.today,
      type: NotificationType.camping,
      title: '박지민 학생이 스쿨캠핑을 신청 했습니다.',
      description: '8월 12일 · 학생 6명',
      timeLabel: '방금 전',
    ),
    NotificationItem(
      id: 'teacher-camping-open-today',
      role: AccountRole.teacher,
      group: NotificationGroup.today,
      type: NotificationType.camping,
      title: '8월 스쿨캠핑이 오픈되었습니다',
      description: '8월 스쿨캠핑 예약이 시작됐어요. 원하는 날짜를 확인해 주세요',
      timeLabel: '방금 전',
    ),
    NotificationItem(
      id: 'teacher-outing-request-today',
      role: AccountRole.teacher,
      group: NotificationGroup.today,
      type: NotificationType.outing,
      title: '김은찬 학생이 외출을 신청 했습니다.',
      description: '2학년 2반 6번 · 오늘 14:00~17:00 · 병원방문',
      timeLabel: '30분 전',
    ),
    NotificationItem(
      id: 'teacher-outing-request-yesterday',
      role: AccountRole.teacher,
      group: NotificationGroup.yesterday,
      type: NotificationType.outing,
      title: '정문경 학생이 외출을 신청 했습니다.',
      description: '3학년 2반 18번 · 오늘 14:00~17:00 · 병원방문',
      timeLabel: '30분 전',
      isRead: true,
    ),
    NotificationItem(
      id: 'teacher-lab-request-yesterday',
      role: AccountRole.teacher,
      group: NotificationGroup.yesterday,
      type: NotificationType.lab,
      title: '김은찬 학생이 실습실을 대여 신청 했습니다.',
      description: '8월 11일 · 8명 · 19:00~21:00 · iOS실',
      timeLabel: '어제',
      isRead: true,
    ),
    NotificationItem(
      id: 'teacher-outing-request-recent',
      role: AccountRole.teacher,
      group: NotificationGroup.recentWeek,
      type: NotificationType.outing,
      title: '정문경 학생이 외출을 신청 했습니다.',
      description: '3학년 2반 18번 · 오늘 14:00~17:00 · 병원방문',
      timeLabel: '8월 11일',
      isRead: true,
    ),
    NotificationItem(
      id: 'teacher-lab-request-recent',
      role: AccountRole.teacher,
      group: NotificationGroup.recentWeek,
      type: NotificationType.lab,
      title: '김은찬 학생이 실습실을 대여 신청 했습니다.',
      description: '8월 11일 · 8명 · 19:00~21:00 · iOS실',
      timeLabel: '8월 11일',
      isRead: true,
    ),
  ];
}
