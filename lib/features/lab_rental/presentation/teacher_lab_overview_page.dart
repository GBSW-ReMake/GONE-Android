import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/gone_theme.dart';
import '../application/teacher_lab_overview_notifier.dart';
import '../domain/teacher_lab_overview.dart';

class TeacherLabOverviewPage extends ConsumerStatefulWidget {
  const TeacherLabOverviewPage({super.key});

  @override
  ConsumerState<TeacherLabOverviewPage> createState() =>
      _TeacherLabOverviewPageState();
}

class _TeacherLabOverviewPageState
    extends ConsumerState<TeacherLabOverviewPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(teacherLabOverviewProvider.notifier).load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(teacherLabOverviewProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(28, 38, 28, 24),
          children: [
            const Text(
              '실습실 대여',
              style: TextStyle(fontSize: 14, color: Color(0xFF667085)),
            ),
            const SizedBox(height: 10),
            _DateTitle(date: state.selectedDate),
            const SizedBox(height: 24),
            _FloorTabs(
              selectedFloor: state.selectedFloor,
              onSelected: (floor) => ref
                  .read(teacherLabOverviewProvider.notifier)
                  .selectFloor(floor),
            ),
            const SizedBox(height: 22),
            _OverviewContent(state: state),
          ],
        ),
      ),
    );
  }
}

class _DateTitle extends StatelessWidget {
  const _DateTitle({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '${date.month}월',
            style: const TextStyle(color: GoneColors.primary),
          ),
          TextSpan(
            text: ' ${date.day}일 실습실 현황',
            style: const TextStyle(color: Color(0xFF1F2937)),
          ),
        ],
      ),
      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
    );
  }
}

class _FloorTabs extends StatelessWidget {
  const _FloorTabs({required this.selectedFloor, required this.onSelected});

  final int selectedFloor;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEBECEE),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [4, 3, 2].map((floor) {
          final selected = floor == selectedFloor;
          return Expanded(
            child: Semantics(
              button: true,
              selected: selected,
              label: '$floor층',
              child: InkWell(
                onTap: () => onSelected(floor),
                borderRadius: BorderRadius.circular(11),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(11),
                    boxShadow: selected
                        ? const [
                            BoxShadow(
                              color: Color(0x14101828),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    '$floor층',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                      color: selected
                          ? GoneColors.primary
                          : const Color(0xFF98A2B3),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _OverviewContent extends StatelessWidget {
  const _OverviewContent({required this.state});

  final TeacherLabOverviewState state;

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case TeacherLabOverviewStatus.initial:
      case TeacherLabOverviewStatus.loading:
        return const SizedBox(
          height: 240,
          child: Center(child: CircularProgressIndicator()),
        );
      case TeacherLabOverviewStatus.empty:
        return const _OverviewMessage(
          icon: Icons.meeting_room_outlined,
          title: '실습실 현황이 없어요',
          message: '선택한 층에 실습실이 없습니다.',
        );
      case TeacherLabOverviewStatus.error:
        return _OverviewMessage(
          icon: Icons.wifi_off,
          title: '현황을 불러올 수 없어요',
          message: state.errorMessage ?? '잠시 후 다시 시도해 주세요.',
        );
      case TeacherLabOverviewStatus.loaded:
        return _LoadedOverview(state: state);
    }
  }
}

class _LoadedOverview extends StatelessWidget {
  const _LoadedOverview({required this.state});

  final TeacherLabOverviewState state;

  @override
  Widget build(BuildContext context) {
    final reservedCount = state.rooms.where((room) => room.isReserved).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${state.selectedFloor}층 실습실',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
            const Spacer(),
            Text(
              '예약 $reservedCount개',
              style: const TextStyle(fontSize: 12, color: Color(0xFF667085)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        for (final status in state.rooms) ...[
          _TeacherLabRoomCard(status: status),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _TeacherLabRoomCard extends StatelessWidget {
  const _TeacherLabRoomCard({required this.status});

  final TeacherLabRoomStatus status;

  @override
  Widget build(BuildContext context) {
    final booking = status.booking;
    final card = Semantics(
      button: booking != null,
      enabled: booking != null,
      label: booking == null
          ? '${status.room.name}, 미예약'
          : '${status.room.name}, ${booking.bookers}, ${booking.period.label}',
      child: InkWell(
        onTap: booking == null
            ? null
            : () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => TeacherLabBookingDetailPage(
                    status: status,
                    booking: booking,
                  ),
                ),
              ),
        borderRadius: BorderRadius.circular(17),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 19),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 36,
                child: Text(
                  '${status.room.number}',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: booking == null
                        ? const Color(0xFF98A2B3)
                        : GoneColors.primary,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status.room.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      booking?.bookers ?? '예약없음',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF667085),
                      ),
                    ),
                    if (booking != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        booking.purpose,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF667085),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _UsageBadge(period: booking?.period ?? LabUsagePeriod.none),
            ],
          ),
        ),
      ),
    );
    return card;
  }
}

class _UsageBadge extends StatelessWidget {
  const _UsageBadge({required this.period});

  final LabUsagePeriod period;

  @override
  Widget build(BuildContext context) {
    final color = switch (period) {
      LabUsagePeriod.nightStudy => GoneColors.primary,
      LabUsagePeriod.afterSchool => const Color(0xFFFFB541),
      LabUsagePeriod.none => const Color(0xFF98A2B3),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        period.label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _OverviewMessage extends StatelessWidget {
  const _OverviewMessage({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 72, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        children: [
          Icon(icon, size: 36, color: const Color(0xFF98A2B3)),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Color(0xFF667085)),
          ),
        ],
      ),
    );
  }
}

class TeacherLabBookingDetailPage extends StatelessWidget {
  const TeacherLabBookingDetailPage({
    super.key,
    required this.status,
    required this.booking,
  });

  final TeacherLabRoomStatus status;
  final TeacherLabBooking booking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Semantics(
                    button: true,
                    label: '뒤로가기',
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      status.room.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 32),
              _UsageBadge(period: booking.period),
              const SizedBox(height: 28),
              Text(
                '${booking.dateLabel} ${booking.weekdayLabel}',
                style: const TextStyle(fontSize: 18, color: Color(0xFF667085)),
              ),
              const SizedBox(height: 24),
              Text(
                status.room.name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 30),
              _DetailSection(title: '이용시간', value: booking.usageTime),
              _DetailSection(title: '대여자', value: booking.bookers),
              _DetailSection(title: '사용 목적', value: booking.purpose),
              _DetailSection(title: '사용 위치', value: booking.location),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 17, color: Color(0xFF1F2937)),
          ),
        ],
      ),
    );
  }
}
