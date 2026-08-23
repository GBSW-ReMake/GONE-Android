import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/domain/account_role.dart';
import '../data/mock_notification_repository.dart';
import '../data/notification_repository.dart';
import '../domain/notification.dart';

enum NotificationStatus { initial, loading, loaded, empty, error }

class NotificationState {
  const NotificationState({
    required this.status,
    required this.role,
    this.items = const [],
    this.errorMessage,
  });

  final NotificationStatus status;
  final AccountRole role;
  final List<NotificationItem> items;
  final String? errorMessage;

  int get unreadCount => items.where((item) => !item.isRead).length;

  Map<NotificationGroup, List<NotificationItem>> get groupedItems {
    final grouped = <NotificationGroup, List<NotificationItem>>{};
    for (final group in NotificationGroup.values) {
      final itemsInGroup = items
          .where((item) => item.group == group)
          .toList(growable: false);
      if (itemsInGroup.isNotEmpty) grouped[group] = itemsInGroup;
    }
    return grouped;
  }

  NotificationState copyWith({
    NotificationStatus? status,
    AccountRole? role,
    List<NotificationItem>? items,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationState(
      status: status ?? this.status,
      role: role ?? this.role,
      items: items ?? this.items,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class NotificationNotifier extends Notifier<NotificationState> {
  NotificationNotifier({NotificationRepository? repository})
    : _repository = repository ?? MockNotificationRepository();

  final NotificationRepository _repository;

  @override
  NotificationState build() => const NotificationState(
    status: NotificationStatus.initial,
    role: AccountRole.student,
  );

  Future<void> load(AccountRole role) async {
    state = state.copyWith(
      status: NotificationStatus.loading,
      role: role,
      clearError: true,
    );
    try {
      final items = await _repository.fetchNotifications(role);
      state = state.copyWith(
        status: items.isEmpty
            ? NotificationStatus.empty
            : NotificationStatus.loaded,
        items: items,
      );
    } catch (error) {
      state = state.copyWith(
        status: NotificationStatus.error,
        errorMessage: error.toString(),
      );
    }
  }

  void markAllRead() {
    state = state.copyWith(
      items: state.items
          .map((item) => item.copyWith(isRead: true))
          .toList(growable: false),
    );
  }

  void markRead(String id) {
    state = state.copyWith(
      items: state.items
          .map((item) => item.id == id ? item.copyWith(isRead: true) : item)
          .toList(growable: false),
    );
  }
}

final notificationProvider =
    NotifierProvider<NotificationNotifier, NotificationState>(
      NotificationNotifier.new,
    );
