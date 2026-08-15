import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/gone_theme.dart';
import '../application/lab_rental_notifier.dart';
import '../domain/lab_rental.dart';

class MyLabRentalPage extends ConsumerWidget {
  const MyLabRentalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(labRentalProvider);
    final rental = state.rental;
    if (rental == null) return const _EmptyLabRentalView();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 24),
          children: [
            Row(
              children: [
                const Text(
                  '내 실습실 대여',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                TextButton(
                  onPressed: ref.read(labRentalProvider.notifier).showRooms,
                  child: const Text(
                    '새 예약',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF667085),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            _RentalCard(rental: rental),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF98A2B3)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                '담당 선생님이 승인하면 이용 가능 상태로 변경되고, 홈의 신청 현황에서도 바로 확인할 수 있습니다.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: Color(0xFF667085),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RentalCard extends ConsumerWidget {
  const _RentalCard({required this.rental});
  final LabRental rental;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                '신청번호 ${rental.id}',
                style: const TextStyle(fontSize: 10, color: Color(0xFF667085)),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Text(
            rental.room.name,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            '${rental.room.floor}층 · ${rental.dateLabel}',
            style: const TextStyle(fontSize: 12, color: Color(0xFF667085)),
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              const Text(
                '이용시간',
                style: TextStyle(fontSize: 14, color: Color(0xFF667085)),
              ),
              const Spacer(),
              Text(
                rental.timeLabel,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFE4E7EC)),
          _InfoRow(label: '대표자', value: rental.leader),
          const Divider(height: 1, color: Color(0xFFE4E7EC)),
          _InfoRow(label: '사용인원', value: '${rental.memberCount}명'),
          const Divider(height: 1, color: Color(0xFFE4E7EC)),
          _InfoRow(label: '사용목적', value: rental.purpose),
          const SizedBox(height: 26),
          const _RentalProgress(),
          const SizedBox(height: 28),
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
              child: const Text(
                '대여 취소',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmCancellation(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('대여를 취소할까요?'),
        content: const Text('취소한 대여는 되돌릴 수 없습니다.'),
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
    if (confirmed == true) ref.read(labRentalProvider.notifier).cancelRental();
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF1D6),
      borderRadius: BorderRadius.circular(14),
    ),
    child: const Text(
      '예약 가능',
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Color(0xFF9B6518),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 95,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF667085)),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}

class _RentalProgress extends StatelessWidget {
  const _RentalProgress();
  @override
  Widget build(BuildContext context) => const Row(
    children: [
      Expanded(child: _ProgressStep(label: '신청완료', active: true)),
      _ProgressLine(),
      Expanded(child: _ProgressStep(label: '승인대기')),
      _ProgressLine(),
      Expanded(child: _ProgressStep(label: '이용가능')),
    ],
  );
}

class _ProgressStep extends StatelessWidget {
  const _ProgressStep({required this.label, this.active = false});
  final String label;
  final bool active;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: active ? GoneColors.primary : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: active ? GoneColors.primary : const Color(0xFF98A2B3),
            width: 3,
          ),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: active ? FontWeight.w700 : FontWeight.w400,
          color: active ? GoneColors.primary : const Color(0xFF98A2B3),
        ),
      ),
    ],
  );
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine();
  @override
  Widget build(BuildContext context) => const Expanded(
    child: Padding(
      padding: EdgeInsets.only(bottom: 25),
      child: Divider(color: Color(0xFFD0D5DD), thickness: 1),
    ),
  );
}

class _EmptyLabRentalView extends ConsumerWidget {
  const _EmptyLabRentalView();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.meeting_room_outlined,
                  size: 46,
                  color: Color(0xFF98A2B3),
                ),
                const SizedBox(height: 16),
                const Text(
                  '진행 중인 실습실 대여가 없어요',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 9),
                const Text(
                  '필요한 실습실을 예약해보세요.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF667085)),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: ref.read(labRentalProvider.notifier).showRooms,
                  child: const Text('새 예약하기'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
