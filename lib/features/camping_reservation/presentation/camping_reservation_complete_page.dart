import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/gone_theme.dart';
import '../application/camping_reservation_notifier.dart';
import '../domain/camping_reservation.dart';

class CampingReservationCompletePage extends ConsumerWidget {
  const CampingReservationCompletePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservation = ref.watch(
      campingReservationProvider.select((state) => state.reservation),
    );
    if (reservation == null) return const _EmptyReservationView();
    final controller = ref.read(campingReservationProvider.notifier);
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(28, 26, 28, 24),
          children: [
            Row(
              children: [
                const Text(
                  '예약 신청 완료',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                TextButton(
                  onPressed: controller.showCalendar,
                  child: const Text('달력 보기'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _ReservationCard(reservation: reservation),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF98A2B3)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                '예약한 날짜는 달력에서 내 예약 상태로 표시됩니다.',
                style: TextStyle(fontSize: 12, color: Color(0xFF667085)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReservationCard extends ConsumerWidget {
  const _ReservationCard({required this.reservation});
  final CampingReservation reservation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final date = reservation.date;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDCE8FF), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _StatusBadge(),
              const Spacer(),
              Text(
                '예약번호 ${reservation.id}',
                style: const TextStyle(fontSize: 10, color: Color(0xFF667085)),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            '${date.month}월',
            style: const TextStyle(fontSize: 12, color: Color(0xFF667085)),
          ),
          const SizedBox(height: 5),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
              children: [
                TextSpan(
                  text: '${date.day}일 ',
                  style: const TextStyle(color: GoneColors.primary),
                ),
                TextSpan(text: '${weekdays[date.weekday - 1]}요일'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _InfoRow(label: '담당 선생님', value: reservation.teacher.label),
          const Divider(height: 1, color: Color(0xFFE4E7EC)),
          _InfoRow(
            label: '예약 인원',
            value: '${reservation.students.length}명 / 최대 8명',
          ),
          const Divider(height: 1, color: Color(0xFFE4E7EC)),
          _InfoRow(label: '대표 학생', value: reservation.students.first.label),
          const SizedBox(height: 18),
          _ParticipantPreview(students: reservation.students),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () => _confirmCancellation(context, ref),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFFF5A5F),
                side: const BorderSide(color: Color(0xFFFF5A5F)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: const Text('예약 취소'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmCancellation(BuildContext context, WidgetRef ref) async {
    final cancelled = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('예약을 취소할까요?'),
        content: const Text('취소한 예약은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('유지하기'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('취소하기'),
          ),
        ],
      ),
    );
    if (cancelled == true) {
      ref.read(campingReservationProvider.notifier).cancelReservation();
    }
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
    decoration: BoxDecoration(
      color: const Color(0xFFEAF1FF),
      borderRadius: BorderRadius.circular(14),
    ),
    child: const Text(
      '예약 완료',
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: GoneColors.primary,
      ),
    ),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 14),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF667085)),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

class _ParticipantPreview extends StatelessWidget {
  const _ParticipantPreview({required this.students});
  final List<Participant> students;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    decoration: BoxDecoration(
      color: const Color(0xFFF5F7FA),
      borderRadius: BorderRadius.circular(13),
    ),
    child: Row(
      children: [
        const Expanded(
          child: Text(
            '참여 명단 확인 · 수정',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        Text('${students.length}명', style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 8),
        const Icon(Icons.chevron_right, size: 20),
      ],
    ),
  );
}

class _EmptyReservationView extends ConsumerWidget {
  const _EmptyReservationView();

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    backgroundColor: const Color(0xFFF3F5F9),
    body: SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cabin_outlined,
              size: 46,
              color: Color(0xFF98A2B3),
            ),
            const SizedBox(height: 16),
            const Text(
              '예약 내역이 없어요',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 22),
            FilledButton(
              onPressed: ref
                  .read(campingReservationProvider.notifier)
                  .showCalendar,
              child: const Text('달력 보기'),
            ),
          ],
        ),
      ),
    ),
  );
}
