import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/gone_theme.dart';
import '../../auth/domain/account_role.dart';
import '../application/notification_notifier.dart';
import '../domain/notification.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key, required this.role});

  final AccountRole role;

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(notificationProvider.notifier).load(widget.role),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(28, 12, 28, 32),
          children: [
            _NotificationHeader(
              onBack: () => Navigator.of(context).pop(),
              onMarkAllRead: state.unreadCount == 0
                  ? null
                  : ref.read(notificationProvider.notifier).markAllRead,
            ),
            const SizedBox(height: 38),
            _NotificationContent(state: state),
          ],
        ),
      ),
    );
  }
}

class _NotificationHeader extends StatelessWidget {
  const _NotificationHeader({required this.onBack, this.onMarkAllRead});

  final VoidCallback onBack;
  final VoidCallback? onMarkAllRead;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Semantics(
            button: true,
            label: '뒤로가기',
            child: IconButton(
              onPressed: onBack,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 48, height: 48),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 24),
            ),
          ),
          const Expanded(
            child: Text(
              '알림',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: GoneColors.deepNavy,
              ),
            ),
          ),
          Semantics(
            button: true,
            enabled: onMarkAllRead != null,
            label: '모두 읽음',
            child: TextButton(
              onPressed: onMarkAllRead,
              style: TextButton.styleFrom(
                minimumSize: const Size(72, 48),
                padding: EdgeInsets.zero,
              ),
              child: const Text(
                '모두 읽음',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: GoneColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationContent extends StatelessWidget {
  const _NotificationContent({required this.state});

  final NotificationState state;

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case NotificationStatus.initial:
      case NotificationStatus.loading:
        return const SizedBox(
          height: 280,
          child: Center(child: CircularProgressIndicator()),
        );
      case NotificationStatus.empty:
        return const _NotificationMessage(
          icon: Icons.notifications_none_rounded,
          title: '새로운 알림이 없어요',
          message: '새로운 소식이 도착하면 알려드릴게요.',
        );
      case NotificationStatus.error:
        return _NotificationMessage(
          icon: Icons.wifi_off,
          title: '알림을 불러올 수 없어요',
          message: state.errorMessage ?? '잠시 후 다시 시도해 주세요.',
        );
      case NotificationStatus.loaded:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final entry in state.groupedItems.entries) ...[
              Text(
                entry.key.title,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  color: GoneColors.deepNavy,
                ),
              ),
              const SizedBox(height: 22),
              for (final item in entry.value) ...[
                _NotificationRow(item: item),
                const SizedBox(height: 28),
              ],
              const SizedBox(height: 10),
            ],
          ],
        );
    }
  }
}

class _NotificationRow extends ConsumerWidget {
  const _NotificationRow({required this.item});

  final NotificationItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      button: true,
      label: '${item.title}. ${item.description}. ${item.timeLabel}',
      child: InkWell(
        onTap: item.isRead
            ? null
            : () => ref.read(notificationProvider.notifier).markRead(item.id),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: Image.asset(item.type.assetPath, fit: BoxFit.contain),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.35,
                      fontWeight: item.isRead
                          ? FontWeight.w600
                          : FontWeight.w700,
                      color: item.isRead
                          ? const Color(0xFF344054)
                          : GoneColors.deepNavy,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: Color(0xFF7C879D),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 58,
              child: Text(
                item.timeLabel,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 12,
                  color: item.isRead
                      ? const Color(0xFF98A2B3)
                      : GoneColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationMessage extends StatelessWidget {
  const _NotificationMessage({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Column(
        children: [
          Icon(icon, size: 42, color: const Color(0xFF98A2B3)),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: const TextStyle(fontSize: 13, color: Color(0xFF667085)),
          ),
        ],
      ),
    );
  }
}
