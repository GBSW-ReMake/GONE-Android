import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/design_system/gone_theme.dart';
import '../application/camping_reservation_notifier.dart';

class CampingCalendarPage extends ConsumerWidget {
  const CampingCalendarPage({super.key, this.showBottomNavigation = true});

  final bool showBottomNavigation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(campingReservationProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SafeArea(child: _CampingCalendarView(state: state)),
      bottomNavigationBar: showBottomNavigation
          ? const _CampingBottomNavigation()
          : null,
    );
  }
}

class _CampingCalendarView extends ConsumerWidget {
  const _CampingCalendarView({required this.state});

  final CampingReservationState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(campingReservationProvider.notifier);
    final month = state.displayedMonth;
    return ListView(
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 20),
      children: [
        Row(
          children: [
            const Text(
              '스쿨캠핑',
              style: TextStyle(fontSize: 13, color: Color(0xFF667085)),
            ),
            const Spacer(),
            TextButton(
              onPressed: state.reservation == null
                  ? null
                  : controller.showComplete,
              child: const Text('내 예약'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          '원하는 날짜를 선택하세요',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 42),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: controller.showPreviousMonth,
              tooltip: '이전 달',
              icon: const Icon(Icons.chevron_left, color: Color(0xFF667085)),
            ),
            const SizedBox(width: 36),
            Text(
              '${month.year}.${month.month.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 36),
            IconButton(
              onPressed: controller.showNextMonth,
              tooltip: '다음 달',
              icon: const Icon(Icons.chevron_right, color: Color(0xFF667085)),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const _WeekdayLabels(),
        const SizedBox(height: 12),
        _MonthGrid(month: month),
        const SizedBox(height: 16),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Legend(color: Color(0xFFE6EAF0), label: '예약 가능'),
            SizedBox(width: 15),
            _Legend(color: Color(0xFF5B8DEF), label: '내 예약'),
            SizedBox(width: 15),
            _Legend(color: Color(0xFFE4E7EC), label: '예약 불가'),
          ],
        ),
      ],
    );
  }
}

class _WeekdayLabels extends StatelessWidget {
  const _WeekdayLabels();

  @override
  Widget build(BuildContext context) {
    const labels = ['일', '월', '화', '수', '목', '금', '토'];
    return Row(
      children: labels
          .map(
            (label) => Expanded(
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _MonthGrid extends ConsumerWidget {
  const _MonthGrid({required this.month});

  final DateTime month;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(campingReservationProvider.notifier);
    final firstDay = DateTime(month.year, month.month);
    final firstWeekday = firstDay.weekday % 7;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF0F1F3)),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 42,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 0.78,
        ),
        itemBuilder: (context, index) {
          final day = index - firstWeekday + 1;
          if (day < 1 || day > daysInMonth) {
            return const _CalendarCell();
          }
          final date = DateTime(month.year, month.month, day);
          return _CalendarCell(
            day: day,
            onTap: () => controller.selectDate(date),
          );
        },
      ),
    );
  }
}

class _CalendarCell extends StatelessWidget {
  const _CalendarCell({this.day, this.onTap});

  final int? day;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(color: Color(0xFFF0F1F3)),
            bottom: BorderSide(color: Color(0xFFF0F1F3)),
          ),
        ),
        child: day == null
            ? null
            : Center(
                child: Semantics(
                  button: true,
                  label: '$day일 예약하기',
                  child: Text(
                    '$day',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 4),
      Text(
        label,
        style: const TextStyle(fontSize: 10, color: Color(0xFF667085)),
      ),
    ],
  );
}

class _CampingBottomNavigation extends StatelessWidget {
  const _CampingBottomNavigation();

  @override
  Widget build(BuildContext context) {
    const labels = ['홈', '실습실', '외출', '스쿨캠핑', '설정'];
    const icons = [
      'home.svg',
      'lab.svg',
      'outing.svg',
      'camping.svg',
      'settings.svg',
    ];
    return SafeArea(
      top: false,
      child: Container(
        height: 68,
        margin: const EdgeInsets.fromLTRB(22, 0, 22, 12),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(34),
        ),
        child: Row(
          children: List.generate(labels.length, (index) {
            final selected = index == 3;
            return Expanded(
              child: Semantics(
                button: true,
                selected: selected,
                label: labels[index],
                child: Container(
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFE9EDF4)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/${icons[index]}',
                        width: 19,
                        height: 19,
                        colorFilter: ColorFilter.mode(
                          selected
                              ? GoneColors.primary
                              : const Color(0xFF667085),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        labels[index],
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: selected
                              ? GoneColors.primary
                              : const Color(0xFF667085),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
