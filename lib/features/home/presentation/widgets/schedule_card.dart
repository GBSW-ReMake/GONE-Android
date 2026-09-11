import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gone/core/design_system/gone_theme.dart';
import 'package:gone/features/home/application/home_schedule_provider.dart';
import 'package:gone/features/home/domain/period.dart';
import 'package:gone/features/home/presentation/widgets/card_title.dart';

const _periodTimes = [
  (8 * 60 + 40, 9 * 60 + 30),
  (9 * 60 + 40, 10 * 60 + 30),
  (10 * 60 + 40, 11 * 60 + 30),
  (11 * 60 + 40, 12 * 60 + 30),
  (13 * 60 + 40, 14 * 60 + 30),
  (14 * 60 + 40, 15 * 60 + 30),
  (15 * 60 + 40, 16 * 60 + 30),
];

String _periodTimeLabel(int period) {
  final (start, end) = _periodTimes[period - 1];
  return '${_formatMinutes(start)}–${_formatMinutes(end)}';
}

String _formatMinutes(int minutes) {
  final hour = (minutes ~/ 60).toString().padLeft(2, '0');
  final minute = (minutes % 60).toString().padLeft(2, '0');
  return '$hour:$minute';
}

class ScheduleCard extends ConsumerStatefulWidget {
  const ScheduleCard({super.key});

  @override
  ConsumerState<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends ConsumerState<ScheduleCard> {
  late final PageController _scheduleController = _createScheduleController();

  int get _schedulePage => _scheduleController.hasClients
      ? _scheduleController.page?.round() ?? 0
      : 0;

  PageController _createScheduleController() {
    final now = DateTime.now();
    final minutesNow = now.hour * 60 + now.minute;

    for (var i = 0; i < _periodTimes.length; i++) {
      final (start, end) = _periodTimes[i];
      if (minutesNow < end) return PageController(initialPage: i);
    }
    return PageController(initialPage: _periodTimes.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final scheduleAsync = ref.watch(homeScheduleProvider);

    return Column(
      children: [
        CardTitle(
          icon: 'section-schedule.png',
          label: '오늘 시간표',
          action: Text('${_schedulePage + 1}/7', style: TextTheme.of(context).bodyMedium?.copyWith(
            color: GoneColors.textSecondary
          ),),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: scheduleAsync.when(
            error: (error, stackTrace) => Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: const Center(child: Text('시간표를 불러오지 못했습니다.')),
            ),
            loading: () =>
                const CircularProgressIndicator(color: GoneColors.primary),
            data: (scheduleData) => SizedBox(
              height: 134,
              child: PageView.builder(
                controller: _scheduleController,
                itemCount: scheduleData.periods.length,
                onPageChanged: (value) => setState(() {}),
                itemBuilder: (context, index) => _ScheduleCardItem(
                  currentPeriod: scheduleData.periods[index],
                  nextPeriod: scheduleData.periods.length - 1 == index
                      ? null
                      : scheduleData.periods[index + 1],
                  classSummary:
                      '${scheduleData.grade}학년 ${scheduleData.classNm}반',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScheduleCardItem extends StatelessWidget {
  const _ScheduleCardItem({
    required this.currentPeriod,
    required this.nextPeriod,
    required this.classSummary,
  });

  final Period currentPeriod;
  final Period? nextPeriod;
  final String classSummary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          height: 80,
          child: Row(
            children: [
              Text(
                currentPeriod.period.toString(),
                style: TextTheme.of(context).titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: GoneColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentPeriod.subject,
                    style: TextTheme.of(context).bodyLarge?.copyWith(
                      color: GoneColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    classSummary,
                    style: TextTheme.of(
                      context,
                    ).bodySmall?.copyWith(color: GoneColors.textSecondary),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                _periodTimeLabel(currentPeriod.period),
                style: TextTheme.of(
                  context,
                ).bodySmall?.copyWith(color: GoneColors.textSecondary),
              ),
            ],
          ),
        ),
        const Divider(color: GoneColors.gray300, height: 1),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                '다음',
                style: TextTheme.of(
                  context,
                ).bodySmall?.copyWith(color: GoneColors.textSecondary),
              ),
              const SizedBox(width: 10),
              Text(
                nextPeriod == null
                    ? '오늘 마지막 수업입니다!'
                    : '${nextPeriod!.period}교시 · ${nextPeriod!.subject}',
                style: TextTheme.of(context).bodyMedium?.copyWith(
                  color: GoneColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
